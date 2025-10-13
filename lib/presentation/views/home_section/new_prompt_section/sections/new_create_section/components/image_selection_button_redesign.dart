import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class ImageSelectionButtonRedesign extends StatelessWidget {
  final bool hasImage;
  final VoidCallback onPressed;
  final bool showPremiumIcon;

  const ImageSelectionButtonRedesign({
    super.key,
    required this.hasImage,
    required this.onPressed,
    this.showPremiumIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: hasImage
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.surface,
            border: Border.all(
              color: showPremiumIcon && !hasImage
                  ? theme.colorScheme.primary.withOpacity(0.4)
                  : theme.colorScheme.outline.withOpacity(0.2),
              width: showPremiumIcon && !hasImage ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
              if (showPremiumIcon && !hasImage)
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(14),
              splashColor: theme.colorScheme.primary.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: hasImage
                            ? theme.colorScheme.primary.withOpacity(0.15)
                            : theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        hasImage ? Icons.photo_library_rounded : Icons.add_photo_alternate_rounded,
                        color: hasImage ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasImage ? "Change Image" : "Add Reference Image",
                            style: AppTextstyle.interMedium(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!hasImage)
                            Text(
                              "Upload for image-to-image",
                              style: AppTextstyle.interMedium(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (hasImage)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Active",
                          style: AppTextstyle.interMedium(
                            fontSize: 10,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Premium Badge
        if (showPremiumIcon && !hasImage)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                ],
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'PRO',
                    style: AppTextstyle.interMedium(
                      fontSize: 10,
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