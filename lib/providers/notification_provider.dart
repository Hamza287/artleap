import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/models/notification_model.dart';

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  NotificationNotifier() : super([]);

  void addNotification(AppNotification notification) {
    state = [notification, ...state];
  }

  void markAsRead(String notificationId) {
    state = [
      for (final notification in state)
        if (notification.id == notificationId)
          notification.copyWith(isRead: true) // Now this will work
        else
          notification
    ];
  }

  void markAllAsRead() {
    state = [
      for (final notification in state)
        notification.copyWith(isRead: true) // Now this will work
    ];
  }

  void deleteNotification(String notificationId) {
    state = state.where((n) => n.id != notificationId).toList();
  }

  // Optional: Add clear all notifications method
  void clearAll() {
    state = [];
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<AppNotification>>(
      (ref) => NotificationNotifier(),
);