import 'dart:async';
import 'package:Artleap.ai/domain/notification_services/firebase_notification_service.dart';
import 'package:Artleap.ai/domain/notifications_repo/notification_repository.dart';
import 'package:Artleap.ai/domain/tutorial/tutorial_provider.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../di/di.dart';
import '../providers/notification_provider.dart';

class AppInitialization {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await AppLocal.ins.initStorage();
    await DI.initDI();

    await dotenv.load(fileName: ".env");
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
    try {
      await Stripe.instance.applySettings();
    } catch (e) {
      print("Stripe initialization failed: $e");
    }

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  }

  static Future<bool> shouldShowTutorial(WidgetRef ref) async {
    try {
      final storageService = ref.read(tutorialStorageServiceProvider);
      await storageService.init();
      return !storageService.hasSeenTutorial();
    } catch (e) {
      debugPrint('Error checking tutorial status: $e');
      return true;
    }
  }

  static Future<String?> initializeAuthAndNotifications(WidgetRef ref) async {
    final token = await ref.read(authprovider).ensureValidFirebaseToken();

    await ref.read(firebaseNotificationServiceProvider).initialize();
    final userId = UserData.ins.userId;
    if (userId != null) {
      ref.read(notificationProvider(userId).notifier).loadNotifications();
    }

    return token;
  }

  static Future<void> registerUserDeviceToken(Ref ref) async {
    try {
      final userId = UserData.ins.userId;
      if (userId == null || userId.isEmpty) {
        return;
      }

      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();

      if (token != null) {
        final repo = ref.read(notificationRepositoryProvider);
        await repo.registerDeviceToken(userId, token);
      }

      messaging.onTokenRefresh.listen((newToken) async {
        if (UserData.ins.userId != null) {
          final repo = ref.read(notificationRepositoryProvider);
          await repo.registerDeviceToken(UserData.ins.userId!, newToken);
        }
      });
    } catch (e, stack) {
      debugPrint(stack.toString());
    }
  }

  static Future<void> registerUserDeviceTokenRef(WidgetRef ref) async {
    try {
      final userId = UserData.ins.userId;
      if (userId == null || userId.isEmpty) {
        return;
      }

      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();

      if (token != null) {
        final repo = ref.read(notificationRepositoryProvider);
        await repo.registerDeviceToken(userId, token);
      }

      messaging.onTokenRefresh.listen((newToken) async {
        if (UserData.ins.userId != null) {
          final repo = ref.read(notificationRepositoryProvider);
          await repo.registerDeviceToken(UserData.ins.userId!, newToken);
        }
      });
    } catch (e, stack) {
      debugPrint(stack.toString());
    }
  }
}
