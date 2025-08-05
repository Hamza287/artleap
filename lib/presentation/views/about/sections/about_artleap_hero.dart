import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapHeroSection extends StatelessWidget {
  const AboutArtleapHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.darkBlue,
            AppColors.lightBlue.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/icons/logo.png',
            height: 120,
          ),
          const SizedBox(height: 24),
          Text(
            'Where Creativity Meets AI',
            style: AppTextstyle.interBold(
              fontSize: 28,
              color: AppColors.darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Artleap is revolutionizing digital art creation by combining human creativity with cutting-edge artificial intelligence.',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: AppColors.darkBlue.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}