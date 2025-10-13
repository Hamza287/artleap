import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class StyleSelectionRedesign extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const StyleSelectionRedesign({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Style Icon Container
            Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Style Image
                    Center(
                      child: Image.asset(
                        icon,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.palette_rounded,
                          size: 24,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ),

                    // Selection Overlay
                    if (isSelected)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: theme.colorScheme.onPrimary,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Style Title
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextstyle.interMedium(
                  fontSize: 12,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}