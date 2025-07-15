import 'dart:async';
import 'package:Artleap.ai/domain/notification_services/firebase_notification_service.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/providers/theme_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/firebase_options.dart';
import 'package:Artleap.ai/presentation/splash_screen.dart';
import 'package:Artleap.ai/shared/theme/light_theme.dart';
import 'di/di.dart';
import 'providers/notification_provider.dart';
import 'domain/notification_services/notification_service.dart'
    hide notificationServiceProvider;
import 'shared/navigation/navigator_key.dart';
import 'shared/navigation/route_generator.dart';
import 'providers/localization_provider.dart';
import 'shared/app_persistance/app_local.dart';
import 'shared/localization/app_localization.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize other services
    await AppLocal.ins.initStorage();
    await DI.initDI();

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
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(authprovider).ensureValidFirebaseToken();

      // Refresh token every hour
      _refreshTokenTimer = Timer.periodic(const Duration(hours: 1), (_) async {
        await ref.read(authprovider).ensureValidFirebaseToken();
        debugPrint('✅ Firebase token refreshed.');
      });
    });

    Future.microtask(
        () => ref.read(firebaseNotificationServiceProvider).initialize());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserData.ins.userId;
      if (userId != null) {
        ref.read(notificationProvider(userId).notifier).loadNotifications();
      }
    });
  }

  @override
  void dispose() {
    _refreshTokenTimer?.cancel();
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
        GlobalCupertinoLocalizations.delegate
      ],
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: SplashScreen.routeName,
    );
  }
}
