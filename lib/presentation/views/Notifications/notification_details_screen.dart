import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class NotificationDetailScreen extends StatelessWidget {
  final RemoteMessage? message;
  static const String routeName = '/notification-details';

  const NotificationDetailScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notification Error'),
          backgroundColor: AppColors.darkBlue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.redColor),
              const SizedBox(height: 16),
              Text(
                'Notification data not available',
                style: AppTextstyle.interMedium(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'The notification content could not be loaded',
                style: AppTextstyle.interRegular(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.baseGreenColor,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Go Back',
                  style: AppTextstyle.interMedium(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Safe access to notification properties
    final notification = message!.notification;
    final notificationData = message!.data;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          notification?.title ?? 'Notification',
          style: AppTextstyle.interMedium(color: AppColors.white),
        ),
        backgroundColor: AppColors.darkBlue,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification?.body != null) ...[
                Text(
                  notification!.body!,
                  style: AppTextstyle.interRegular(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (notificationData.isNotEmpty)
                Card(
                  color: AppColors.greyBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Additional Data:',
                          style: AppTextstyle.interMedium(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...notificationData.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: AppTextstyle.interRegular(
                                color: AppColors.lightgrey,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              // Add empty state if no content is available
              if (notification?.body == null && notificationData.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 64,
                          color: AppColors.lightgrey),
                      const SizedBox(height: 16),
                      Text(
                        'No content available',
                        style: AppTextstyle.interMedium(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}