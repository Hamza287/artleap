import 'package:Artleap.ai/widgets/custom_dialog/dialog_service.dart';
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

  List<AppNotification> _filterNotifications(
      List<AppNotification> notifications,
      NotificationFilter filter
      ) {
    if (filter == NotificationFilter.all) return notifications;

    return notifications.where((notification) {
      final String? dataType = notification.data?['type']?.toString();
      final String mainType = notification.type;

      final String effectiveType = dataType ?? mainType;

      switch (filter) {
        case NotificationFilter.like:
          return effectiveType == 'like';
        case NotificationFilter.comment:
          return effectiveType == 'comment';
        case NotificationFilter.follow:
          return effectiveType == 'follow';
        case NotificationFilter.alert:
          return effectiveType == 'alert';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = UserData.ins.userId;
    if (userId == null) {
      return const ErrorState(message: 'Please login to view notifications');
    }

    final notificationsAsync = ref.watch(notificationProvider(userId));
    final currentFilter = ref.watch(notificationFilterProvider);
    final filteredNotifications = notificationsAsync.maybeWhen(
      data: (notifications) => _filterNotifications(notifications, currentFilter),
      orElse: () => <AppNotification>[],
    );

    _debugPrintNotificationTypes(notificationsAsync);

    final unreadCount = notificationsAsync.maybeWhen(
      data: (notifications) => notifications.where((n) => !n.isRead).length,
      orElse: () => 0,
    );

    final filteredUnreadCount = filteredNotifications.where((n) => !n.isRead).length;

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
          if (filteredUnreadCount > 0)
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
      body: Column(
        children: [
          _buildFilterTabs(currentFilter, theme),
          Expanded(
            child: notificationsAsync.when(
              loading: () => const LoadingIndicator(),
              error: (error, stack) => ErrorState(
                message: 'Failed to load notifications',
                onRetry: _loadNotifications,
              ),
              data: (allNotifications) {
                if (filteredNotifications.isEmpty) {
                  return EmptyState(
                    icon: Icons.filter_alt_outlined,
                    title: 'No ${currentFilter.displayName} Notifications',
                    subtitle: currentFilter == NotificationFilter.all
                        ? 'When we have something to show, it will appear here'
                        : 'No ${currentFilter.displayName.toLowerCase()} notifications found',
                    iconColor: theme.colorScheme.primary,
                  );
                }

                return RefreshIndicator(
                  backgroundColor: theme.colorScheme.primary,
                  color: theme.colorScheme.onPrimary,
                  onRefresh: _loadNotifications,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(NotificationFilter currentFilter, ThemeData theme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: NotificationFilter.values.map((filter) {
          final isSelected = currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter.displayName,
                style: AppTextstyle.interMedium(
                  fontSize: 14,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                ref.read(notificationFilterProvider.notifier).state = filter;
              },
              backgroundColor: theme.colorScheme.surfaceVariant,
              selectedColor: theme.colorScheme.primary,
              checkmarkColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _debugPrintNotificationTypes(AsyncValue<List<AppNotification>> notificationsAsync) {
    notificationsAsync.whenData((notifications) {
      final dataTypes = notifications
          .map((n) => n.data?['type']?.toString())
          .where((type) => type != null)
          .toSet()
          .toList();

      final mainTypes = notifications
          .map((n) => n.type)
          .toSet()
          .toList();

      if (dataTypes.isNotEmpty) {
        debugPrint('Available data types: $dataTypes');
      }
      if (mainTypes.isNotEmpty) {
        debugPrint('Available main types: $mainTypes');
      }
      if (notifications.isNotEmpty) {
        debugPrint('First notification data: ${notifications.first.data}');
        debugPrint('First notification type: ${notifications.first.type}');
      }
    });
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

  Future<void> _handleDelete(BuildContext context, WidgetRef ref, String notificationId) async {
    DialogService.confirmDelete(
      context: context,
      itemName: 'notification',
      onDelete: () async {
        try {
          await ref.read(notificationProvider(UserData.ins.userId!).notifier)
              .deleteNotification(notificationId, UserData.ins.userId!);
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
      },
    );
  }
}