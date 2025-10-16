import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../providers/notification_provider.dart';

Future<bool?> showDeleteConfirmationDialog(
  BuildContext context, {
  required String notificationId,
  required String userId,
  String title = 'Notification',
}) async {
  final theme = Theme.of(context);

  return showDialog<bool>(
    context: context,
    builder: (context) {
      final notifier = ProviderScope.containerOf(context)
          .read(notificationProvider(userId).notifier);

      return AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete $title',
          style: AppTextstyle.interBold(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          'Are you sure you want to delete this $title?',
          style: AppTextstyle.interRegular(
              color: theme.colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextstyle.interMedium(
                  color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
              try {
                await notifier.deleteNotification(notificationId, userId);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Failed to delete notification: ${e.toString()}'),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: AppTextstyle.interMedium(color: theme.colorScheme.error),
            ),
          ),
        ],
      );
    },
  );
}
