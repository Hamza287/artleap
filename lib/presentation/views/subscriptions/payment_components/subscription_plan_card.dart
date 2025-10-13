import 'package:flutter/material.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;

  const SubscriptionPlanCard({super.key, required this.plan});

  String _getPlanPeriod(String type) {
    switch (type.toLowerCase()) {
      case 'basic':
        return 'week';
      case 'standard':
        return 'month';
      case 'premium':
        return 'year';
      case 'trial':
        return 'trial';
      default:
        return '';
    }
  }

  Color _getPlanColor(String type, ThemeData theme) {
    switch (type.toLowerCase()) {
      case 'basic':
        return theme.colorScheme.primary;
      case 'standard':
        return theme.colorScheme.primary;
      case 'premium':
        return theme.colorScheme.primary;
      case 'trial':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final planColor = _getPlanColor(plan.type, theme);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            planColor.withOpacity(0.9),
            planColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: planColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.name,
                style: AppTextstyle.interBold(
                  fontSize: 22,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '\$${plan.price.toStringAsFixed(2)}/${_getPlanPeriod(plan.type)}',
                  style: AppTextstyle.interBold(
                    fontSize: 18,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            'Up to ${(plan.imageGenerationCredits / 24).toInt()} Image-to-Image Generations',
            planColor,
            theme,
          ),
          _buildFeatureItem(
            'Up to ${(plan.promptGenerationCredits / 2).toInt()} Text-to-Image Generations',
            planColor,
            theme,
          ),
          _buildFeatureItem(
            'Total Credits: ${plan.totalCredits.toInt()}',
            planColor,
            theme,
          ),
          const SizedBox(height: 12),
          ...plan.features.take(3).map((feature) => _buildFeatureRow(feature, planColor, theme)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, Color planColor, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: theme.colorScheme.onPrimary.withOpacity(0.9),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextstyle.interRegular(
                fontSize: 14,
                color: theme.colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, Color planColor, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.star_rounded,
            size: 14,
            color: theme.colorScheme.onPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}