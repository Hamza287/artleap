import 'dart:async';
import 'package:Artleap.ai/domain/notification_services/firebase_notification_service.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/presentation/views/subscriptions/payment_screen.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/providers/theme_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/firebase_options.dart';
import 'package:Artleap.ai/presentation/splash_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'di/di.dart';
import 'domain/api_services/api_response.dart';
import 'domain/subscriptions/plan_provider.dart';
import 'domain/subscriptions/subscription_repo_provider.dart';
import 'providers/notification_provider.dart';
import 'domain/notification_services/notification_service.dart'
    hide notificationServiceProvider;
import 'providers/localization_provider.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize other services
    await AppLocal.ins.initStorage();
    await DI.initDI();

    // await dotenv.load(fileName: ".env");
    // Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
    // await Stripe.instance.applySettings();

    // Set up error handling
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Configure system UI
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.topBar,
      statusBarColor: AppColors.topBar,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    // Run the app
    runApp(
      ProviderScope(
        overrides: [
          notificationServiceProvider
              .overrideWith((ref) => NotificationService(ref)),
        ],
        child: const MyApp(),
      ),
    );
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Timer? _refreshTokenTimer;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    // Initialize in-app purchase stream
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onError: (error) {
      debugPrint('Purchase stream error: $error');
      appSnackBar(
          'Error', 'Failed to process purchase stream: $error', Colors.red);
    });

    Future.microtask(() async {
      await ref.read(authprovider).ensureValidFirebaseToken();
      // Refresh token every hour
      _refreshTokenTimer = Timer.periodic(const Duration(hours: 1), (_) async {
        await ref.read(authprovider).ensureValidFirebaseToken();
        debugPrint('✅ Firebase token refreshed.');
      });

      // Initialize notifications
      await ref.read(firebaseNotificationServiceProvider).initialize();
      final userId = UserData.ins.userId;
      if (userId != null) {
        ref.read(notificationProvider(userId).notifier).loadNotifications();
      }
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    final selectedPlan = ref.read(selectedPlanProvider);
    final basePlanId = selectedPlan?.basePlanId;
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint('Purchase pending: ${purchaseDetails.productID}');
        appSnackBar('Info', 'Purchase is pending', Colors.yellow);
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final userId = UserData.ins.userId;
        if (userId == null) {
          debugPrint('User ID not found');
          appSnackBar('Error', 'User not authenticated', Colors.red);
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          return;
        }

        final subscriptionService = ref.read(subscriptionServiceProvider);
        try {
          final response = await subscriptionService.subscribe(
            userId,
            selectedPlan?.id ?? '', // Maps to googleProductId
            'google_play',
            verificationData: {
              'productId': purchaseDetails.productID,
              'basePlanId': basePlanId,
              'purchaseToken':
                  purchaseDetails.verificationData.serverVerificationData,
              'transactionId': purchaseDetails.purchaseID ?? '',
              'platform': 'android',
              'amount': purchaseDetails.verificationData.localVerificationData
                      .contains('price_amount_micros')
                  ? (int.parse(purchaseDetails
                              .verificationData.localVerificationData
                              .split('"price_amount_micros":')[1]
                              .split(',')[0]) /
                          1000000)
                      .toString()
                  : '0',
            },
          );

          if (!mounted) return;

          if (response.status == Status.completed) {
            debugPrint('Subscription created: ${response.data}');
            appSnackBar(
                'Success', 'Subscription created successfully', Colors.green);
            await InAppPurchase.instance.completePurchase(purchaseDetails);
            ref.refresh(currentSubscriptionProvider(userId));
            ref.read(paymentLoadingProvider.notifier).state = false;
            navigatorKey.currentState ?.pushReplacementNamed(BottomNavBar.routeName);
          } else {
            debugPrint('Subscription creation failed: ${response.message}');
            appSnackBar(
                'Error', response.message ?? 'Subscription failed', Colors.red);
            await InAppPurchase.instance.completePurchase(purchaseDetails);
            ref.read(paymentLoadingProvider.notifier).state = false;
          }
        } catch (e) {
          debugPrint('Error processing purchase: $e');
          appSnackBar('Error', 'Purchase error: $e', Colors.red);
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          ref.read(paymentLoadingProvider.notifier).state = false;
        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchaseDetails.error}');
        appSnackBar(
            'Error',
            'Purchase failed: ${purchaseDetails.error?.message ?? 'Unknown error'}',
            Colors.red);
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        ref.read(paymentLoadingProvider.notifier).state = false;
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        debugPrint('Purchase canceled by user');
        appSnackBar('Info', 'Purchase canceled', Colors.yellow);
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        ref.read(paymentLoadingProvider.notifier).state = false;
      }
    }
  }

  @override
  void dispose() {
    _refreshTokenTimer?.cancel();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artleap.ai',
      themeMode: ref.watch(themeProvider),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      supportedLocales: AppLocalization.supportedLocales,
      locale: ref.watch(localizationProvider),
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: SplashScreen.routeName,
    );
  }
}
