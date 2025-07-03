import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/notification_model/notification_model.dart';
import 'package:Artleap.ai/domain/notification_services/notification_service.dart';


final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});


class NotificationNotifier extends StateNotifier<AsyncValue<List<AppNotification>>> {
  final NotificationService _service;
  final String userId;

  NotificationNotifier(this._service, this.userId) : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = const AsyncValue.loading();
    try {
      final notifications = await _service.getUserNotifications(userId);
      state = AsyncValue.data(notifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addNotification(AppNotification notification) async {
    state.whenData((notifications) {
      if (!notifications.any((n) => n.id == notification.id)) {
        state = AsyncValue.data([notification, ...notifications]);
      }
    });
  }


  Future<void> deleteNotification(String notificationId,String userId) async {
    try {
      state.whenData((notifications) async {
        // Optimistic update
        state = AsyncValue.data(
          notifications.where((n) => n.id != notificationId).toList(),
        );

        await _service.deleteNotification(notificationId,userId);
      });
    } catch (e) {
      // If error occurs, reload the original state
      loadNotifications();
      rethrow;
    }
  }


  Future<void> markAsRead(String notificationId) async {
    try {
      await _service.markAsRead(notificationId);
      state.whenData((notifications) {
        state = AsyncValue.data([
          for (final notification in notifications)
            if (notification.id == notificationId)
              notification.copyWith(isRead: true)
            else
              notification
        ]);
      });
    } catch (e) {
      loadNotifications();
      rethrow;
    }
  }



  Future<void> markAllAsRead() async {
    state.whenData((notifications) async {
      final unreadIds = notifications
          .where((n) => !n.isRead)
          .map((n) => n.id)
          .toList();

      if (unreadIds.isEmpty) return;

      // Optimistic update
      state = AsyncValue.data([
        for (final notification in notifications)
          notification.copyWith(isRead: true)
      ]);

      try {
        await _service.markAllAsRead(unreadIds);
      } catch (e) {
        loadNotifications();
        rethrow;
      }
    });
  }

}

final notificationProvider = StateNotifierProvider.family<NotificationNotifier, AsyncValue<List<AppNotification>>, String>(
      (ref, userId) => NotificationNotifier(
    ref.read(notificationServiceProvider),
    userId,
  ),
);