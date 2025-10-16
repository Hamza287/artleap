import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
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
                theme.colorScheme.surfaceContainer.withOpacity(0.06),
                theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              ],
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.4),
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
                      (iconColor ?? theme.colorScheme.primary).withOpacity(0.25),
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
                    color: iconColor ?? theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.025),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextstyle.interMedium(
                  color: theme.colorScheme.onSurface,
                  fontSize: size.width * 0.05,
                ),
              ),
              SizedBox(height: size.height * 0.012),

              // Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextstyle.interRegular(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
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