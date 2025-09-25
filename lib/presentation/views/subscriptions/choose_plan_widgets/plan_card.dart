import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:flutter/material.dart';
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
    // Determine billing period based on plan ID
    String billingPeriod;
    switch (plan.type.toLowerCase()) {
      case 'basic':
        billingPeriod = 'per editor/week \n billed weekly';
        break;
      case 'standard':
        billingPeriod = 'per editor/month \n billed monthly';
        break;
      case 'premium':
        billingPeriod = 'per editor/year \n billed yearly';
        break;
      default:
        billingPeriod = 'per editor/month\nbilled monthly';
    }
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
            Color(0xFF8863F5),
            Color(0xFF000000),
          ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? const Color(0x80AD6CFF) : Colors.transparent,
            width: 12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan title
            Text(
              plan.name,
              style: AppTextstyle.interBold(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Price and period
            Row(
              children: [
                Text(
                  '\$${plan.price.toStringAsFixed(0)}',
                  style: AppTextstyle.interBold(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                ),
                10.spaceX,
                Text(
                  '${billingPeriod}',
                  style: AppTextstyle.interBold(
                    fontSize: 12,
                    color: Color(0xFF868C92),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...plan.features.map((feature) => _featureRow(feature)).toList(),
            _featureRow('Images Without Watermark'),
            _featureRow('Up to ${(plan.imageGenerationCredits / 24).toInt()} Image-to-Image Generations'),
            _featureRow('Up to ${(plan.promptGenerationCredits / 2).toInt()} Text-to-Image Generations'),
            _featureRow('Total Credits: ${plan.totalCredits.toInt()}'),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String title, [bool check = true]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            check ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
