import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/subscriptions/subscription_repo_provider.dart';

class ErrorState extends ConsumerWidget {
  final Object error;
  const ErrorState(this.error, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.redColor.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load plans',
              style: AppTextstyle.interBold(
                fontSize: 18,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again',
              textAlign: TextAlign.center,
              style: AppTextstyle.interRegular(
                fontSize: 14,
                color: AppColors.darkBlue.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Simply invalidate without awaiting
                ref.invalidate(subscriptionPlansProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh),
              label: Text(
                'Retry',
                style: AppTextstyle.interBold(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}