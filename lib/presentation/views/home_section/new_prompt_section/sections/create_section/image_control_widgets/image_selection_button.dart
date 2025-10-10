import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class ImageSelectionButton extends StatelessWidget {
  final bool hasImage;
  final VoidCallback onPressed;
  final bool showPremiumIcon;

  const ImageSelectionButton({
    super.key,
    required this.hasImage,
    required this.onPressed,
    this.showPremiumIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isSmallScreen = screenWidth < 360;
    final bool isMediumScreen = screenWidth < 400;

    final horizontalPadding = isSmallScreen ? 20.0 : (isMediumScreen ? 25.0 : 30.0);
    final verticalPadding = isSmallScreen ? 6.0 : 7.5;

    final iconTextSpacing = isSmallScreen ? 8.0 : 12.0;

    final fontSize = isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 15.0);

    final iconSize = isSmallScreen ? 18.0 : 20.0;
    final iconPadding = isSmallScreen ? 6.0 : 8.0;

    final premiumBadgeTop = isSmallScreen ? -4.0 : -6.0;
    final premiumBadgeRight = isSmallScreen ? -4.0 : -6.0;
    final premiumIconSize = isSmallScreen ? 10.0 : 12.0;
    final premiumFontSize = isSmallScreen ? 8.0 : 10.0;
    final premiumHorizontalPadding = isSmallScreen ? 6.0 : 8.0;
    final premiumVerticalPadding = isSmallScreen ? 3.0 : 4.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
              if (showPremiumIcon && !hasImage)
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
            ],
            border: Border.all(
              color: showPremiumIcon && !hasImage
                  ? theme.colorScheme.primary.withOpacity(0.3)
                  : theme.colorScheme.outline.withOpacity(0.3),
              width: showPremiumIcon && !hasImage ? 2 : 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(14),
              splashColor: theme.colorScheme.primary.withOpacity(0.2),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(iconPadding),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        hasImage ? Icons.photo_library : Icons.add_photo_alternate,
                        color: theme.colorScheme.primary,
                        size: iconSize,
                      ),
                    ),
                    SizedBox(width: iconTextSpacing),
                    Flexible(
                      child: Text(
                        hasImage ? "Change Image" : "Add Image",
                        style: AppTextstyle.interMedium(
                          fontSize: fontSize,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (showPremiumIcon && !hasImage)
          Positioned(
            top: premiumBadgeTop,
            right: premiumBadgeRight,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: premiumHorizontalPadding,
                vertical: premiumVerticalPadding,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFA500),
                    Color(0xFFFF8C00),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: theme.colorScheme.surface,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: premiumIconSize,
                  ),
                  SizedBox(width: isSmallScreen ? 2.0 : 4.0),
                  Text(
                    'PRO',
                    style: AppTextstyle.interMedium(
                      fontSize: premiumFontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}