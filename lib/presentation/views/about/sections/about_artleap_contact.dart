import 'package:Artleap.ai/widgets/custom_text/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapContactSection extends StatelessWidget {
  const AboutArtleapContactSection({super.key});

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
            theme.colorScheme.secondaryContainer.withOpacity(0.1),
            theme.colorScheme.primaryContainer.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          AppText(
            'Get In Touch',
              size: 24,
              color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 24),
          _buildContactMethod(
            icon: Icons.email,
            title: 'Email Us',
            value: 'info@x-r.digital',
            theme: theme,
          ),
          _buildContactMethod(
            icon: Icons.language,
            title: 'Website',
            value: 'https://x-r.digital/',
            theme: theme,
          ),
          _buildContactMethod(
            icon: Icons.phone,
            title: 'Support',
            value: '+44 (20) 3807 5235',
            theme: theme,
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
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  size: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                AppText(
                  value,
                  size: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}