import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

import 'coming_soon_button.dart';


class CreditsCard extends StatelessWidget {
  final int dailyCredits;
  final int totalCredits;
  final int usedImageCredits;
  final int imageGenerationCredits;
  final int usedPromptCredits;
  final int promptGenerationCredits;

  const CreditsCard({
    super.key,
    required this.dailyCredits,
    required this.totalCredits,
    required this.usedImageCredits,
    required this.imageGenerationCredits,
    required this.usedPromptCredits,
    required this.promptGenerationCredits,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.purple),
                const SizedBox(width: 12),
                Text(
                  "Credits",
                  style: AppTextstyle.interBold(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _CreditProgress(
              label: "Daily Credits",
              used: dailyCredits,
              total: totalCredits,
              icon: Icons.calendar_today_outlined,
              color: AppColors.purple,
            ),
            const SizedBox(height: 16),
            _CreditProgress(
              label: "Image Generation",
              used: usedImageCredits,
              total: imageGenerationCredits,
              icon: Icons.image_outlined,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _CreditProgress(
              label: "Prompt Generation",
              used: usedPromptCredits,
              total: promptGenerationCredits,
              icon: Icons.text_fields_outlined,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            ComingSoonButton(
              label: "Buy More Credits",
              icon: Icons.add_circle_outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditProgress extends StatelessWidget {
  final String label;
  final int used;
  final int total;
  final IconData icon;
  final Color color;

  const _CreditProgress({
    required this.label,
    required this.used,
    required this.total,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (used / total) : 0.0;
    final remaining = total - used;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextstyle.interMedium(
                      fontSize: 14,
                      color: Colors.grey[700]!,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$used of $total used ($remaining remaining)",
                    style: AppTextstyle.interRegular(
                      fontSize: 12,
                      color: Colors.grey[600]!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[200],
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}