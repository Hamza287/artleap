import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/notification_model/notification_model.dart';
import 'package:Artleap.ai/providers/notification_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:intl/intl.dart';
import '../../../shared/notification_utils/empty_state.dart';
import '../../../shared/notification_utils/error_state.dart';
import '../../../shared/notification_utils/loading_indicator.dart';
import '../global_widgets/dialog_box/notification_delele_dialog.dart';
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
      appBar: AppBar(
        title: Text(
          'Notifications${unreadCount > 0 ? ' ($unreadCount)' : ''}',
          style: AppTextstyle.interBold(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all, color: AppColors.white),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _loadNotifications,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.darkBlue, AppColors.purple],
          ),
        ),
        child: notificationsAsync.when(
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
                iconColor: AppColors.lightPurple,
              );
            }

            return RefreshIndicator(
              backgroundColor: AppColors.lightPurple,
              color: AppColors.white,
              onRefresh: _loadNotifications,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationCard(
                    notification: notification,
                    onTap: () => _handleNotificationTap(notification, userId),
                    onMarkAsRead: () => _markAsRead(notification.id, userId),
                    onDelete: _handleDelete, // Pass the delete function
                  );
                },
              ),
            );
          },
        ),
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
              backgroundColor: AppColors.redColor,
            ),
          );
        }
      }
    }
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final Function(BuildContext, WidgetRef, String) onDelete; // Add this line

  const NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete, // Add this parameter
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer( // Wrap with Consumer to access ref
      builder: (context, ref, child) {
        return Semantics(
          label: notification.isRead
              ? 'Read notification: ${notification.title}'
              : 'Unread notification: ${notification.title}',
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: notification.isRead
                    ? AppColors.greyBlue.withValues()
                    : AppColors.lightIndigo.withValues(),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.lightPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getNotificationIcon(notification.type),
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextstyle.interBold(
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          IconButton(
                            icon: const Icon(Icons.check, size: 20),
                            color: AppColors.white,
                            onPressed: onMarkAsRead,
                            tooltip: 'Mark as read',
                          ),
                        // Add delete icon button here
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          color: AppColors.redColor, // Red color for delete
                          onPressed: () => onDelete(context, ref, notification.id),
                          tooltip: 'Delete notification',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.body,
                      style: AppTextstyle.interRegular(
                        fontSize: 14,
                        color: AppColors.white.withValues(),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          DateFormat('MMM d, y • h:mm a').format(notification.timestamp),
                          style: AppTextstyle.interRegular(
                            fontSize: 12,
                            color: AppColors.lightgrey,
                          ),
                        ),
                        const Spacer(),
                        if (!notification.isRead)
                          TextButton(
                            onPressed: onMarkAsRead,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 20),
                            ),
                            child: Text(
                              'MARK AS READ',
                              style: AppTextstyle.interRegular(
                                fontSize: 12,
                                color: AppColors.lightPurple,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'system':
        return Icons.info_outline;
      case 'message':
        return Icons.message;
      case 'alert':
        return Icons.warning_rounded;
      default:
        return Icons.notifications;
    }
  }
}