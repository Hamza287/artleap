import 'package:Artleap.ai/widgets/custom_text/custom_text_widget.dart';
import 'package:flutter/material.dart';

class AboutArtleapFooter extends StatelessWidget {
  const AboutArtleapFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      width: double.infinity,
      color: theme.colorScheme.primary,
      child: Column(
        children: [
          Image.asset(
            'assets/icons/logo.png',
            height: 60,
          ),
          const SizedBox(height: 24),
          AppText(
            'Artleap - Where Creativity Meets AI',
            size: 16,
            color: theme.colorScheme.onPrimary.withOpacity(0.8),
            align: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppText(
            '© ${DateTime.now().year} Xr Digital. All rights reserved.',
            size: 12,
            color: theme.colorScheme.onPrimary.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
