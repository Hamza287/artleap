import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../providers/notification_provider.dart';

Future<bool?> showDeleteConfirmationDialog(
    BuildContext context, {
      required String notificationId,
      required String userId,
      String title = 'Notification',
    }) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      final notifier = ProviderScope.containerOf(context)
          .read(notificationProvider(userId).notifier);

      return AlertDialog(
        backgroundColor: AppColors.greyBlue,
        title: Text(
          'Delete $title',
          style: AppTextstyle.interBold(color: AppColors.white),
        ),
        content: Text(
          'Are you sure you want to delete this $title?',
          style: AppTextstyle.interRegular(color: AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextstyle.interMedium(color: AppColors.lightPurple),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
              try {
                await notifier.deleteNotification(notificationId,userId);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete notification: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: AppTextstyle.interMedium(color: AppColors.shockingPink),
            ),
          ),
        ],
      );
    },
  );
}