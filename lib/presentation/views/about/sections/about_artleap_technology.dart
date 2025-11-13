import 'package:Artleap.ai/widgets/custom_text/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapTechnologySection extends StatelessWidget {
  const AboutArtleapTechnologySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      color: theme.colorScheme.background,
      child: Column(
        children: [
          AppText(
            'Our Technology',
            size: 24,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 24),
          _buildTechItem(
            icon: Icons.psychology,
            title: 'Advanced AI Models',
            description: 'State-of-the-art diffusion models trained on diverse artistic styles',
            theme: theme,
          ),
          _buildTechItem(
            icon: Icons.speed,
            title: 'Real-time Processing',
            description: 'Optimized neural networks for fast generation on any device',
            theme: theme,
          ),
          _buildTechItem(
            icon: Icons.security,
            title: 'Privacy Focused',
            description: 'Your data remain private and anyone can view your creations',
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem({
    required IconData icon,
    required String title,
    required String description,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        children: [
          Icon(icon, size: 40, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 8),
                AppText(
                  description,
                  size: 15,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}