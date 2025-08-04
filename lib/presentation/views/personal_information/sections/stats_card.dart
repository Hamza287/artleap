import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class StatsCard extends StatelessWidget {
  final int followers;
  final int following;
  final int images;

  const StatsCard({
    super.key,
    required this.followers,
    required this.following,
    required this.images,
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              value: followers,
              label: "Followers",
              icon: Icons.people_alt_outlined,
            ),
            _StatItem(
              value: following,
              label: "Following",
              icon: Icons.person_outline,
            ),
            _StatItem(
              value: images,
              label: "Images",
              icon: Icons.image_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.purple, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: AppTextstyle.interBold(
            fontSize: 22,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextstyle.interRegular(
            fontSize: 14,
            color: Colors.grey[600]!,
          ),
        ),
      ],
    );
  }
}