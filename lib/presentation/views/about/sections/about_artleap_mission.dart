import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapMissionSection extends StatelessWidget {
  const AboutArtleapMissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Text(
            'Our Mission',
            style: AppTextstyle.interBold(
              fontSize: 24,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildMissionCard(
            icon: Icons.brush,
            title: 'Democratize Art Creation',
            description: 'Make professional-quality art tools accessible to everyone, regardless of skill level.',
            theme: theme,
          ),
          const SizedBox(height: 16),
          _buildMissionCard(
            icon: Icons.auto_awesome,
            title: 'Enhance Creativity',
            description: 'Use AI to augment human creativity, not replace it.',
            theme: theme,
          ),
          const SizedBox(height: 16),
          _buildMissionCard(
            icon: Icons.group,
            title: 'Build Community',
            description: 'Foster a global community of digital artists and creators.',
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard({
    required IconData icon,
    required String title,
    required String description,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextstyle.interBold(
                    fontSize: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTextstyle.interRegular(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
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