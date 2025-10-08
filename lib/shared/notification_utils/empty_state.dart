import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.05,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.05,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.black.withOpacity(0.5),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon inside glowing circle
              Container(
                width: size.width * 0.22,
                height: size.width * 0.22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (iconColor ?? AppColors.lightPurple).withOpacity(0.25),
                      Colors.transparent,
                    ],
                    center: Alignment.center,
                    radius: 0.9,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: size.width * 0.13,
                    color: iconColor ?? AppColors.lightPurple,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.025),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextstyle.interMedium(
                  color: Colors.white,
                  fontSize: size.width * 0.05,
                ),
              ),
              SizedBox(height: size.height * 0.012),

              // Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextstyle.interRegular(
                  color: Colors.white70,
                  fontSize: size.width * 0.038,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
