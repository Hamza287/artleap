import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class RatioSelectionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSmall;

  const RatioSelectionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isSmall) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 73,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.8)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Center(
            child: Text(
              text,
              style: AppTextstyle.interMedium(
                fontSize: 12,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: theme.cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 60,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.85)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Center(
            child: Text(
              text,
              style: AppTextstyle.interMedium(
                fontSize: 16,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}