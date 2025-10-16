import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/utilities/safe_network_image.dart';
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
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (profilePic != null && profilePic!.isNotEmpty)
          SafeNetworkImage(
            imageUrl: profilePic!,
          )
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: 120,
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                theme.colorScheme.scrim.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
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
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: AppTextstyle.interRegular(
                  fontSize: 16,
                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}