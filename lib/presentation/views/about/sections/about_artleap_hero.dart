import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapHeroSection extends StatelessWidget {
  const AboutArtleapHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer.withOpacity(0.1),
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
              color: theme.colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Artleap is revolutionizing digital art creation by combining human creativity with cutting-edge artificial intelligence.',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}