import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../domain/subscriptions/subscription_model.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool isSelected;
  final VoidCallback onSelect;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 280,
        height: 480,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.purple : Colors.black.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.purple : Colors.grey.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: AppTextstyle.interBold(
                      fontSize: 20,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan.description,
                    style: AppTextstyle.interRegular(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${plan.price.toStringAsFixed(2)}/${_getPlanPeriod(plan.type)}',
                    style: AppTextstyle.interMedium(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan Features',
                        style: AppTextstyle.interBold(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...plan.features.map((feature) => _featureRow(feature)).toList(),
                      const SizedBox(height: 16),
                      _featureRow('Image Generations: ${plan.imageGenerationCredits}'),
                      _featureRow('Prompt Generations: ${plan.promptGenerationCredits}'),
                      _featureRow('Total Credits: ${plan.totalCredits}'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String title, [bool check = true]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextstyle.interRegular(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Icon(
            check ? Icons.check : Icons.close,
            size: 18,
            color: check ? Colors.green : Colors.black,
          ),
        ],
      ),
    );
  }

  String _getPlanPeriod(String type) {
    switch (type.toLowerCase()) {
      case 'weekly':
        return 'week';
      case 'monthly':
        return 'month';
      case 'yearly':
        return 'year';
      case 'trial':
        return 'trial';
      default:
        return '';
    }
  }
}