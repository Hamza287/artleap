import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../domain/subscriptions/subscription_model.dart';

class CurrentPlanCard extends StatelessWidget {
  final String planName;
  final bool isActive;
  final UserSubscriptionModel? subscription;
  final User? userPersonalData;

  const CurrentPlanCard({
    super.key,
    required this.planName,
    required this.isActive,
    required this.subscription,
    this.userPersonalData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCredits = (userPersonalData?.totalCredits ?? 0) + (userPersonalData?.usedImageCredits ?? 0) + (userPersonalData?.usedPromptCredits ?? 0) ;
    final usedCredits = (userPersonalData?.usedImageCredits ?? 0) + (userPersonalData?.usedPromptCredits ?? 0);
    final remainingCredits = totalCredits - usedCredits;
    final progressValue = totalCredits > 0 ? remainingCredits / totalCredits : 0;
    final percentageRemaining = (progressValue * 100).toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getPlanColor(planName, theme).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getPlanColor(planName, theme).withOpacity(0.3),
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
                  color: _getPlanColor(planName, theme),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : theme.colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? theme.colorScheme.primary : theme.colorScheme.error,
                    width: 1,
                  ),
                ),
                child: Text(
                  isActive && subscription!.autoRenew ? 'Active' : 'Active',
                  style: AppTextstyle.interMedium(
                    fontSize: 14,
                    color: isActive ? theme.colorScheme.primary : theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (isActive && subscription?.planSnapshot != null) ...[
            LinearProgressIndicator(
              value: progressValue.toDouble(),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(_getPlanColor(planName, theme)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalCredits > 0
                      ? '$remainingCredits of $totalCredits credits left'
                      : 'No credits available',
                  style: AppTextstyle.interRegular(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (totalCredits > 0)
                  Text(
                    '$percentageRemaining% remaining',
                    style: AppTextstyle.interMedium(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
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
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getPlanColor(String planName, ThemeData theme) {
    switch (planName.toLowerCase()) {
      case 'premium':
      case 'weekly pro':
        return theme.colorScheme.primary;
      case 'pro':
      case 'monthly pro':
      case 'standard':
        return theme.colorScheme.primary;
      case 'yearly pro':
      case 'basic':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.primary;
    }
  }
}