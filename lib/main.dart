import 'dart:async';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/providers/theme_provider.dart';
import 'package:Artleap.ai/providers/localization_provider.dart';
import 'package:Artleap.ai/presentation/splash_screen.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/localization/app_localization.dart';
import 'package:Artleap.ai/shared/navigation/navigator_key.dart';
import 'package:Artleap.ai/shared/navigation/route_generator.dart';
import 'package:Artleap.ai/shared/theme/dark_theme.dart';
import 'package:Artleap.ai/shared/theme/light_theme.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'domain/notification_services/notification_service.dart';
import 'main/app_initialization.dart';
import 'main/purchase_handler.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    await AppInitialization.initialize();

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
  late PurchaseHandler _purchaseHandler;

  @override
  void initState() {
    super.initState();
    _purchaseHandler = PurchaseHandler(ref);

    // Initialize in-app purchase stream
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _purchaseHandler.handlePurchaseUpdates(purchaseDetailsList);
    }, onError: (error) {
      appSnackBar('Error', 'Failed to process purchase stream', Colors.red);
    });

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      final result = await AppTrackingTransparency.requestTrackingAuthorization();
      debugPrint("ATT result: $result");
    }

    Future.microtask(() async {
      final token = await AppInitialization.initializeAuthAndNotifications(ref);

      if (token == null) {
        debugPrint('No valid token. Redirecting to login...');
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
            LoginScreen.routeName, (Route<dynamic> route) => false);
        return;
      }

      _refreshTokenTimer = Timer.periodic(const Duration(hours: 1), (_) async {
        final refreshedToken =
            await ref.read(authprovider).ensureValidFirebaseToken();
        if (refreshedToken != null) {
        } else {
          debugPrint('Token refresh skipped: No user signed in.');
        }
      });
    });
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
