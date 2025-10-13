import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class RatioSelectionRedesign extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isAspectRatio;
  final String? aspectRatio;
  final int? credits;

  const RatioSelectionRedesign({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isAspectRatio = false,
    this.aspectRatio,
    this.credits,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isAspectRatio) {
      return _buildAspectRatioCard(theme);
    } else {
      return _buildNumberCard(theme);
    }
  }

  Widget _buildAspectRatioCard(ThemeData theme) {
    final ratioParts = text.split(':');
    final isPortrait = ratioParts.length == 2 &&
        double.parse(ratioParts[0]) < double.parse(ratioParts[1]);
    final isLandscape = ratioParts.length == 2 &&
        double.parse(ratioParts[0]) > double.parse(ratioParts[1]);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 48,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.15)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ratio Icon
            Icon(
              isPortrait
                  ? Icons.crop_portrait_rounded
                  : isLandscape
                      ? Icons.crop_landscape_rounded
                      : Icons.crop_square_rounded,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
              size: 16,
            ),
            const SizedBox(height: 4),
            // Ratio Text
            Text(
              text,
              style: AppTextstyle.interMedium(
                fontSize: 12,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberCard(ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                text,
                style: AppTextstyle.interMedium(
                  fontSize: 18,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (credits != null)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.onPrimary.withOpacity(0.2)
                        : theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        size: 8,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        credits.toString(),
                        style: AppTextstyle.interMedium(
                          fontSize: 8,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
