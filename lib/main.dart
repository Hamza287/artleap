import 'dart:async';
import 'package:Artleap.ai/main/app_keyboard_listener.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/providers/localization_provider.dart';
import 'package:Artleap.ai/presentation/splash_screen.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/localization/app_localization.dart';
import 'package:Artleap.ai/shared/navigation/navigator_key.dart';
import 'package:Artleap.ai/shared/navigation/route_generator.dart';
import 'package:Artleap.ai/shared/theme/app_theme.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'domain/notification_services/notification_service.dart';
import 'main/app_initialization.dart';
import 'main/purchase_handler.dart';
import 'shared/theme/theme_provider.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppInitialization.initialize();

    runApp(
      ProviderScope(
        overrides: [
          notificationServiceProvider
              .overrideWith((ref) => NotificationService(ref)),
        ],
        child: AppKeyboardListener(child: const MyApp()),
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

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _purchaseHandler.handlePurchaseUpdates(purchaseDetailsList);
    }, onError: (error) {
      appSnackBar('Error', 'Failed to process purchase stream', Colors.red);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeProvider.notifier).loadTheme();
    });

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    Future.microtask(() async {
      final token = await AppInitialization.initializeAuthAndNotifications(ref);

      if (token == null) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
            SplashScreen.routeName, (Route<dynamic> route) => false);
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
    ref.watch(systemThemeMonitorProvider);
    final effectiveThemeMode = ref.watch(effectiveThemeModeProvider);

    return MaterialApp(
      title: 'Artleap.ai',
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalization.supportedLocales,
      locale: ref.watch(localizationProvider),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: effectiveThemeMode,
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
