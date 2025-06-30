import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_model.dart';
import '../providers/notification_provider.dart';
import '../presentation/views/Notifications/notification_details_screen.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'premium_notifications';
  static const String _channelName = 'Stylish Alerts';
  static const String _channelDesc = 'Beautiful interactive notifications';

  static Future<void> initialize(BuildContext context, WidgetRef ref) async {
    await _setupFirebase(context, ref);
    await _setupLocalNotifications(ref);
    await _setupInteractions(context, ref);
    await _manageToken();
  }

  static Future<void> _setupFirebase(BuildContext context, WidgetRef ref) async {
    await Firebase.initializeApp();

    final status = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (status.authorizationStatus == AuthorizationStatus.authorized) {
      _showWelcomeNotification(context);
    }

    FirebaseMessaging.onMessage.listen((message) {
      _showDesignerNotification(message, context, ref);
    });
  }

  static Future<void> _setupLocalNotifications(WidgetRef ref) async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notificationsPlugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          _handleNotificationTap(response.payload!, ref);
        }
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _showDesignerNotification(
      RemoteMessage message, BuildContext context, WidgetRef ref) async {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      // Add notification to provider
      final appNotification = AppNotification.fromRemoteMessage(message);
      ref.read(notificationProvider.notifier).addNotification(appNotification);

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        color: Colors.blueAccent,
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await _notificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        ),
        payload: jsonEncode(data),
      );
    }
  }

  static Future<void> _showWelcomeNotification(BuildContext context) async {
    await _notificationsPlugin.show(
      0,
      '🌟 Welcome Aboard!',
      'You\'ll receive beautiful notifications here',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.max,
          priority: Priority.high,
          color: Colors.blue,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  static Future<void> _setupInteractions(
      BuildContext context, WidgetRef ref) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateToMessage(context, message, ref);
    });

    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _navigateToMessage(context, initialMessage, ref);
    }
  }

  static void _navigateToMessage(
      BuildContext context, RemoteMessage message, WidgetRef ref) {
    // Mark as read in provider
    if (message.messageId != null) {
      ref.read(notificationProvider.notifier).markAsRead(message.messageId!);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotificationDetailScreen(message: message),
      ),
    );
  }

  static Future<void> _manageToken() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
    });

    String? token = await _firebaseMessaging.getToken();
    print('Current FCM Token: $token');
  }

  static void _handleNotificationTap(String payload, WidgetRef ref) {
    final data = jsonDecode(payload) as Map<String, dynamic>;
    print('Tapped with data: $data');
  }
}