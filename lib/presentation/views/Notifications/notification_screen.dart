import 'package:Artleap.ai/presentation/views/common/dialog_box/notification_delele_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/notification_model/notification_model.dart';
import 'package:Artleap.ai/providers/notification_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import '../../../shared/notification_utils/empty_state.dart';
import '../../../shared/notification_utils/error_state.dart';
import '../../../shared/notification_utils/loading_indicator.dart';
import 'notification_card.dart';
import 'notification_details_screen.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  static const routeName = '/notifications_repo';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  Future<void> _loadNotifications() async {
    final userId = UserData.ins.userId;
    if (userId != null) {
      await ref.read(notificationProvider(userId).notifier).loadNotifications();
    }
  }

  Future<void> _markAllAsRead() async {
    final userId = UserData.ins.userId;
    if (userId != null) {
      await ref.read(notificationProvider(userId).notifier).markAllAsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = UserData.ins.userId;
    if (userId == null) {
      return const ErrorState(message: 'Please login to view notifications_repo');
    }

    final notificationsAsync = ref.watch(notificationProvider(userId));
    final unreadCount = notificationsAsync.maybeWhen(
      data: (notifications) => notifications.where((n) => !n.isRead).length,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Notifications${unreadCount > 0 ? ' ($unreadCount)' : ''}',
          style: AppTextstyle.interBold(
            fontSize: 20,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: Icon(Icons.done_all, color: theme.colorScheme.primary),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
            ),
          IconButton(
            icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
            onPressed: _loadNotifications,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorState(
          message: 'Failed to load notifications',
          onRetry: _loadNotifications,
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_off,
              title: 'No Notifications yet',
              subtitle: 'When we have something to show, it will appear here',
              iconColor: theme.colorScheme.primary,
            );
          }

          return RefreshIndicator(
            backgroundColor: theme.colorScheme.primary,
            color: theme.colorScheme.onPrimary,
            onRefresh: _loadNotifications,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(notification, userId),
                  onMarkAsRead: () => _markAsRead(notification.id, userId),
                  onDelete: _handleDelete,
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification, String userId) {
    if (!notification.isRead) {
      _markAsRead(notification.id, userId);
    }
    Navigator.pushNamed(
      context,
      NotificationDetailScreen.routeName,
      arguments: notification,
    );
  }

  void _markAsRead(String notificationId, String userId) {
    ref.read(notificationProvider(userId).notifier)
        .markAsRead(notificationId);
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref,String notificationId) async {
    final shouldDelete = await showDeleteConfirmationDialog(
      context,
      notificationId: notificationId,
      userId: UserData.ins.userId!,
    );
    if (shouldDelete ?? false) {
      try {
        await ref.read(notificationProvider(UserData.ins.userId!).notifier)
            .deleteNotification(notificationId,UserData.ins.userId!);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete notification: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}

