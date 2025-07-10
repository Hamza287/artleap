import 'package:Artleap.ai/domain/notification_model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../shared/notification_utils/error_handler.dart';
import '../notifications_repo/notification_repository.dart';


final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

class NotificationService {
  final Ref ref;
  final NotificationRepository _repository;
  final GlobalKey<NavigatorState>? navigatorKey;

  NotificationService(this.ref, {this.navigatorKey})
      : _repository = ref.read(notificationRepositoryProvider) {
    assert(_repository != null, 'NotificationRepository cannot be null');
  }

  Future<List<AppNotification>> getUserNotifications(String userId) async {
    try {
      if (userId.isEmpty) throw ArgumentError('User ID cannot be empty');

      final notifications = await _repository.getUserNotifications(userId);
      return notifications;
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      ErrorHandler.showError(error);
      return [];
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      ErrorHandler.showError(error);
      return [];
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      if (notificationId.isEmpty) throw ArgumentError('Notification ID cannot be empty');
      await _repository.markAsRead(notificationId);
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      ErrorHandler.showError(error);
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      ErrorHandler.showError(error);
    }
  }

  Future<void> markAllAsRead(List<String> notificationIds) async {
    try {
      if (notificationIds.isEmpty) return;
      if (notificationIds.any((id) => id.isEmpty)) {
        throw ArgumentError('Notification IDs cannot contain empty strings');
      }
      await _repository.markAllAsRead(notificationIds);
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      ErrorHandler.showError(error);
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      ErrorHandler.showError(error);
    }
  }

  Future<void> deleteNotification(String notificationId,String userId) async {
    try {
      if (notificationId.isEmpty) throw ArgumentError('Notification ID cannot be empty');
      await _repository.deleteNotification(notificationId: notificationId,userId: userId);
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      ErrorHandler.showError(error);
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      ErrorHandler.showError(error);
    }
  }

  Future<void> createNotification({
    required String title,
    required String body,
    required String type,
    String? userId,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (title.isEmpty || body.isEmpty || type.isEmpty) {
        throw ArgumentError('Title, body and type cannot be empty');
      }
      await _repository.createNotification(
        title: title,
        body: body,
        type: type,
        userId: userId,
        data: data ?? {},
      );
    } on DioException catch (e) {
      final error = ErrorHandler.handleDioError(e);
      ErrorHandler.showError(error);
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      ErrorHandler.showError(error);
    }
  }

  void _navigateToMessage(String routeName, {Object? arguments}) {
    try {
      final context = navigatorKey?.currentContext;
      if (context == null) throw StateError('Navigator context is not available');

      Navigator.of(context).pushNamed(routeName, arguments: arguments);
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      ErrorHandler.showError(error);
    }
  }

  void _setupInteractions() {
    try {
      // Your interaction setup logic here
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      ErrorHandler.showError(error);
    }
  }

  Future<void> initialize() async {
    try {
      _setupInteractions();
    } catch (e) {
      final error = ErrorHandler.handleError(e);
      ErrorHandler.showError(error);
    }
  }
}

// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final navigatorKey = ref.read(navigatorKeyProvider);
  return NotificationService(ref, navigatorKey: navigatorKey);
});