import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/utilities/safe_network_image.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class ProfileHeader extends StatelessWidget {
  final String? profilePic;
  final String username;
  final String email;

  const ProfileHeader({
    super.key,
    required this.profilePic,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image or Gradient
        if (profilePic != null && profilePic!.isNotEmpty)
          SafeNetworkImage(
            imageUrl: profilePic!,
          )
        else
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.purple,
                  AppColors.lightPurple,
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: 120,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // User Info
        Positioned(
          bottom: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: AppTextstyle.interBold(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: AppTextstyle.interRegular(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}