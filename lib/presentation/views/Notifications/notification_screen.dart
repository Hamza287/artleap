import 'package:Artleap.ai/presentation/views/Notifications/notification_details_screen.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/models/notification_model.dart';
import 'package:Artleap.ai/providers/notification_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});
  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextstyle.interMedium(
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.purple,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.shockingPink,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: AppTextstyle.interMedium(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                onPressed: () {
                  ref.read(notificationProvider.notifier).markAllAsRead();
                },
                tooltip: 'Mark all as read',
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        color: AppColors.baseGreenColor,
        backgroundColor: AppColors.purple,
        onRefresh: () async {
          // Add refresh functionality if needed
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.darkBlue,
                AppColors.purple,
              ],
            ),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: AppColors.lightgrey.withOpacity(0.2),
            ),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationTile(
                notification: notification,
                onTap: () {
                  ref.read(notificationProvider.notifier)
                      .markAsRead(notification.id);
                  Navigator.pushNamed(
                      context,
                      NotificationDetailScreen.routeName
                  );
                },
                onDismiss: () {
                  ref.read(notificationProvider.notifier)
                      .deleteNotification(notification.id);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.darkBlue,
            AppColors.purple,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.lightPurple,
                    AppColors.matepink,
                  ],
                ),
              ),
              child: Icon(
                Icons.notifications_off,
                size: 48,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No notifications yet',
              style: AppTextstyle.interMedium(
                fontSize: 20,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'We\'ll notify you when something new arrives',
                textAlign: TextAlign.center,
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: AppColors.lightgrey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.baseGreenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Refresh',
                style: AppTextstyle.interMedium(
                  color: AppColors.darkBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.redColor,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDismiss(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.greyBlue.withOpacity(0.5)
              : AppColors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: notification.isRead
                          ? [AppColors.lightgrey, AppColors.mediumIndigo]
                          : [AppColors.matepink, AppColors.shockingPink],
                    ),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.data),
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: notification.isRead
                            ? AppTextstyle.interRegular(color: AppColors.lightgrey)
                            : AppTextstyle.interMedium(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: notification.isRead
                            ? AppTextstyle.interRegular(
                          fontSize: 12,
                          color: AppColors.lightgrey.withOpacity(0.7),
                        )
                            : AppTextstyle.interMedium(
                          fontSize: 12,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: notification.isRead
                            ? Colors.transparent
                            : AppColors.baseGreenColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _formatTime(notification.timestamp),
                        style: AppTextstyle.interRegular(
                          fontSize: 10,
                          color: notification.isRead
                              ? AppColors.lightgrey
                              : AppColors.darkBlue,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.baseGreenColor,
                          shape: BoxShape.circle,
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
  }

  IconData _getNotificationIcon(Map<String, dynamic>? data) {
    if (data?['type'] == 'message') return Icons.message_rounded;
    if (data?['type'] == 'alert') return Icons.warning_rounded;
    if (data?['type'] == 'payment') return Icons.payment_rounded;
    if (data?['type'] == 'event') return Icons.event_rounded;
    return Icons.notifications_rounded;
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}