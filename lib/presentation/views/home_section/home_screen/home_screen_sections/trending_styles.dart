import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class TrendingStyles extends StatelessWidget {
  const TrendingStyles({super.key});

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: styles.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120, // Adjust width as needed
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EBF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    // styles[index],
                    'Coming Soon',
                    style: AppTextstyle.interMedium(
                      color: Colors.black54
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
