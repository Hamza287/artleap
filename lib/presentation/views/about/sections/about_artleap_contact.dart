import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapContactSection extends StatelessWidget {
  const AboutArtleapContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.lightPurple.withOpacity(0.1),
            AppColors.lightBlue.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Get In Touch',
            style: AppTextstyle.interBold(
              fontSize: 24,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 24),
          _buildContactMethod(
            icon: Icons.email,
            title: 'Email Us',
            value: 'info@x-r.digital',
          ),
          _buildContactMethod(
            icon: Icons.language,
            title: 'Website',
            value: 'https://x-r.digital/',
          ),
          _buildContactMethod(
            icon: Icons.phone,
            title: 'Support',
            value: '+44 (20) 3807 5235',
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.purple),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextstyle.interRegular(
                    fontSize: 14,
                    color: AppColors.darkBlue.withOpacity(0.6),
                  ),
                ),
                Text(
                  value,
                  style: AppTextstyle.interBold(
                    fontSize: 16,
                    color: AppColors.darkBlue,
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