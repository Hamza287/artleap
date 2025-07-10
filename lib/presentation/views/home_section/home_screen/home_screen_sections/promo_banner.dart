import 'package:flutter/material.dart';

import '../../../../../shared/constants/app_colors.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/vector.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Title and Subtitle
             Positioned(
              bottom: 70,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Special Filter",
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Limited time offer",
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Full-width button at bottom
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9A57FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Use Filter ✨",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}