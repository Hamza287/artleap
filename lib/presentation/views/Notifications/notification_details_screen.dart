import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:Artleap.ai/domain/notification_model/notification_model.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

import '../../../providers/notification_provider.dart';
import '../global_widgets/app_common_button.dart';
import '../global_widgets/dialog_box/notification_delele_dialog.dart';

class NotificationDetailScreen extends ConsumerWidget {
  static const routeName = '/notification-details';
  final AppNotification notification;

  const NotificationDetailScreen({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Details',
          style: AppTextstyle.interBold(
            fontSize: 20,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline,color: Colors.red,),
            onPressed: () => _handleDelete(context, ref,notification.id),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.white, AppColors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 24),
              _buildContentSection(),
              if (notification.data?.isNotEmpty ?? false) ...[
                const SizedBox(height: 24),
                _buildDataSection(),
              ],
              const SizedBox(height: 32),
              if (_hasAction()) _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.lightPurple,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: AppColors.black,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: AppTextstyle.interBold(
                  fontSize: 20,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM d, y • h:mm a').format(notification.timestamp),
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        notification.body,
        style: AppTextstyle.interRegular(
          fontSize: 16,
          color: AppColors.black.withValues(),
        ),
      ),
    );
  }

  Widget _buildDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: notification.data!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key}: ',
                      style: AppTextstyle.interMedium(
                        fontSize: 14,
                        color: AppColors.lightPurple,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: AppTextstyle.interRegular(
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Center(
      child: CommonButton(
        title: _getActionText(notification.type),
        onpress: () => _handleNotificationAction(context),
        gradient: const LinearGradient(
          colors: [AppColors.lightPurple, AppColors.matepink],
        ),
      ),
    );
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
            .deleteNotification(notification.id,UserData.ins.userId!);
        if (context.mounted) {
          Navigator.pop(context, true); // Return true to indicate deletion
        }
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

  bool _hasAction() {
    return notification.type == 'message' ||
        notification.data?['action'] != null;
  }

  String _getActionText(String type) {
    switch (type) {
      case 'message':
        return 'Reply to Message';
      case 'alert':
        return 'View Alert Details';
      default:
        return 'View More';
    }
  }

  void _handleNotificationAction(BuildContext context) {
    switch (notification.type) {
      case 'message':
      // Navigate to chat screen
      // Example: Navigator.pushNamed(context, ChatScreen.routeName);
        break;
      case 'alert':
      // Handle alert action
        break;
      default:
        if (notification.data?['url'] != null) {
          // Open URL
          // Example: launchUrl(Uri.parse(notification.data!['url']));
        }
    }
  }
}