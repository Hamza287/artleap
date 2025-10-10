import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class TrendingStyles extends StatelessWidget {
  const TrendingStyles({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styles = [
      "Anime",
      "Cyberpunk",
      "Watercolor",
      "Oil Painting",
      "Pixel Art",
      "3D Render"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(
            "Trending styles",
            style: AppTextstyle.interMedium(
                fontSize: 18,
                color: theme.colorScheme.onSurface
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: styles.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Coming Soon',
                    style: AppTextstyle.interMedium(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}