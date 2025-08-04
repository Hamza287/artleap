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
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFAD6CFF) : Colors.transparent,
            width: 4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan title
            Center(
              child: Text(
                plan.name,
                style: AppTextstyle.interBold(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Price and period
            Center(
              child: Column(
                children: [
                  Text(
                    '\$${plan.price.toStringAsFixed(0)}',
                    style: AppTextstyle.interBold(
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'per editor/month\nbilled monthly',
                    style: AppTextstyle.interMedium(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Features
            ...plan.features.map((feature) => _featureRow(feature)).toList(),
            const SizedBox(height: 16),
            _featureRow('Image Generations: ${plan.imageGenerationCredits}'),
            _featureRow('Text Variations: ${plan.promptGenerationCredits}'),
            _featureRow('Total Credits: ${plan.totalCredits}'),

            const SizedBox(height: 24),

            // Choose Button
            // Container(
            //   width: double.infinity,
            //   height: 44,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: Colors.white),
            //   ),
            //   child: const Center(
            //     child: Text(
            //       "Choose Plan",
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // )
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
