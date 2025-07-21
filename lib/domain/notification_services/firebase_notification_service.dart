import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Add this import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/notification_model/notification_model.dart';
import 'package:Artleap.ai/providers/notification_provider.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/constants/user_data.dart';

class FirebaseNotificationService {
  final Ref ref;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; // Add this

  FirebaseNotificationService(this.ref) {
    _initializeLocalNotifications();
  }

  Future<void> initialize() async {
    await _setupFirebase();
    await _setupInteractions();
  }

  Future<void> _initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        // Handle notification tap if needed
      },
    );
  }

  Future<void> _setupFirebase() async {
    final messaging = FirebaseMessaging.instance;

    // Request permissions with more detailed options
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Notification permission status: ${settings.authorizationStatus}');

    // Configure for Android foreground notifications_repo
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get token
    final token = await messaging.getToken();
    debugPrint('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message); // Show local notification
      _handleMessage(message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel', // Same as in AndroidManifest
      'Important Notifications',
      channelDescription: 'This channel is used for important notifications_repo',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      visibility: NotificationVisibility.public, // Show on lockscreen
      playSound: true,
      enableVibration: true,
    );

    final darwinPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  Future<void> _setupInteractions() async {
    // Handle when app is opened from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Handle when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // In FirebaseNotificationService.dart
  void _handleMessage(RemoteMessage message) async {
    try {
      final notification = AppNotification(
        id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        timestamp: DateTime.now(),
        data: message.data,
        type: message.data['type'] == 'user'
            ? AppConstants.userNotificationType
            : AppConstants.generalNotificationType,
      );

      // Get userId - priority order:
      // 1. From message data (for user-specific notifications)
      // 2. From logged-in user (fallback)
      final messageUserId = message.data['userId'];
      final userId = messageUserId ?? UserData.ins.userId;

      if (userId != null) {
        ref.read(notificationProvider(userId).notifier).addNotification(notification);
      }

      // For backend - use message userId if available, otherwise use logged-in user
      final backendUserId = notification.type == AppConstants.generalNotificationType
          ? null
          : (messageUserId ?? userId);

      print('Using backendUserId: $backendUserId');

      await ref.read(notificationServiceProvider).createNotification(
        title: notification.title,
        body: notification.body,
        type: notification.type,
        userId: backendUserId,
        data: notification.data,
      );
    } catch (e) {
      debugPrint('❌ Error handling notification: $e');
    }
  }

}

final firebaseNotificationServiceProvider = Provider<FirebaseNotificationService>((ref) {
  return FirebaseNotificationService(ref);
});