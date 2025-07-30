import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../domain/subscriptions/subscription_model.dart';

class CurrentPlanCard extends StatelessWidget {
  final String planName;
  final bool isActive;
  final UserSubscriptionModel? subscription;

  const CurrentPlanCard({
    super.key,
    required this.planName,
    required this.isActive,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getPlanColor(planName).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getPlanColor(planName).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                planName,
                style: AppTextstyle.interBold(
                  fontSize: 24,
                  color: _getPlanColor(planName),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.green.withOpacity(0.1)
                      : AppColors.redColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? AppColors.green : AppColors.redColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: AppTextstyle.interMedium(
                    fontSize: 14,
                    color: isActive ? AppColors.green : AppColors.redColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (isActive && subscription?.plan != null) ...[
            LinearProgressIndicator(
              value: subscription!.plan!.totalCredits > 0
                  ? (subscription!.plan!.totalCredits -
                  (subscription!.usedImageCredits +
                      subscription!.usedPromptCredits)) /
                  subscription!.plan!.totalCredits
                  : 0,
              backgroundColor: AppColors.white.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(_getPlanColor(planName)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(subscription!.plan!.totalCredits).toInt()} of ${subscription!.plan!.totalCredits + (subscription!.usedImageCredits + subscription!.usedPromptCredits)} credits left',
                  style: AppTextstyle.interRegular(
                    fontSize: 14,
                    color: AppColors.darkBlue.withOpacity(0.7),
                  ),
                ),
                Text(
                  '${(((subscription!.plan!.totalCredits - (subscription!.usedImageCredits + subscription!.usedPromptCredits)) / subscription!.plan!.totalCredits) * 100).toStringAsFixed(0)}% remaining',
                  style: AppTextstyle.interMedium(
                    fontSize: 14,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            Text(
              'Subscribe to unlock premium features',
              style: AppTextstyle.interRegular(
                fontSize: 14,
                color: AppColors.darkBlue.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getPlanColor(String planName) {
    switch (planName.toLowerCase()) {
      case 'premium':
        return AppColors.purple;
      case 'pro':
      case 'monthly pro':
      case 'standard':
        return AppColors.blue;
      case 'basic':
        return AppColors.green;
      default:
        return AppColors.darkBlue;
    }
  }
}