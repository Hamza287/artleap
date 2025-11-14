import 'package:Artleap.ai/widgets/custom_text/custom_text_widget.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Container(
          padding: EdgeInsets.all(size.width * 0.06),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: theme.colorScheme.surface,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                theme.colorScheme.surfaceContainer.withOpacity(0.06),
                theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              ]
                  : [
                theme.colorScheme.surfaceContainer.withOpacity(0.03),
                theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(isDark ? 0.1 : 0.08),
              width: 1.0, // Slightly thinner for light theme
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(isDark ? 0.4 : 0.1),
                blurRadius: isDark ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width * 0.22,
                height: size.width * 0.22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (iconColor ?? theme.colorScheme.primary).withOpacity(isDark ? 0.25 : 0.15),
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
              AppText(
                title,
                size: size.width * 0.05,
                weight: FontWeight.w600, // Slightly bolder for better readability
                color: theme.colorScheme.onSurface,
                align: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.012),
              AppText(
                subtitle,
                size: size.width * 0.038,
                weight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant, // Use onSurfaceVariant for better contrast
                align: TextAlign.center,
              ),
              if (onAction != null && actionText != null) ...[
                SizedBox(height: size.height * 0.03),
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    elevation: isDark ? 2 : 1, // Adjust elevation based on theme
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: size.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: AppText(
                    actionText!,
                    size: size.width * 0.038,
                    weight: FontWeight.w500,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}