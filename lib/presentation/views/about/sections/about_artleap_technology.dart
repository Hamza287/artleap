import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapTechnologySection extends StatelessWidget {
  const AboutArtleapTechnologySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Our Technology',
            style: AppTextstyle.interBold(
              fontSize: 24,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 24),
          _buildTechItem(
            icon: Icons.psychology,
            title: 'Advanced AI Models',
            description: 'State-of-the-art diffusion models trained on diverse artistic styles',
          ),
          _buildTechItem(
            icon: Icons.speed,
            title: 'Real-time Processing',
            description: 'Optimized neural networks for fast generation on any device',
          ),
          _buildTechItem(
            icon: Icons.security,
            title: 'Privacy Focused',
            description: 'Your data and creations remain private and secure',
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: AppColors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextstyle.interBold(
                    fontSize: 18,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTextstyle.interRegular(
                    fontSize: 15,
                    color: AppColors.darkBlue.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}