import 'package:Artleap.ai/domain/notification_services/notification_service.dart';
import 'package:Artleap.ai/shared/route_export.dart';

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

enum NotificationFilter {
  all('All'),
  alert('Alerts'),
  like('Likes'),
  comment('Comments'),
  follow('Follows');

  const NotificationFilter(this.displayName);
  final String displayName;
}

final notificationFilterProvider = StateProvider<NotificationFilter>(
      (ref) => NotificationFilter.all,
);

final notificationSelectionProvider = StateNotifierProvider<NotificationSelectionNotifier, NotificationSelectionState>((ref) {
  return NotificationSelectionNotifier();
});

class NotificationSelectionState {
  final Set<String> selectedIds;
  final bool isSelectionMode;

  const NotificationSelectionState({
    this.selectedIds = const {},
    this.isSelectionMode = false,
  });

  NotificationSelectionState copyWith({
    Set<String>? selectedIds,
    bool? isSelectionMode,
  }) {
    return NotificationSelectionState(
      selectedIds: selectedIds ?? this.selectedIds,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }
}

class NotificationSelectionNotifier extends StateNotifier<NotificationSelectionState> {
  NotificationSelectionNotifier() : super(const NotificationSelectionState());

  void toggleSelection(String notificationId) {
    final newSelectedIds = Set<String>.from(state.selectedIds);

    if (newSelectedIds.contains(notificationId)) {
      newSelectedIds.remove(notificationId);
    } else {
      newSelectedIds.add(notificationId);
    }

    state = state.copyWith(
      selectedIds: newSelectedIds,
      isSelectionMode: newSelectedIds.isNotEmpty,
    );
  }

  void selectAll(List<String> allNotificationIds) {
    state = state.copyWith(
      selectedIds: Set<String>.from(allNotificationIds),
      isSelectionMode: true,
    );
  }

  void clearSelection() {
    state = const NotificationSelectionState();
  }

  void setSelectionMode(bool mode) {
    state = state.copyWith(isSelectionMode: mode);
  }
}