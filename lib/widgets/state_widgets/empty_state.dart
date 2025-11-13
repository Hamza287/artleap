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
    final size = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Container(
          padding: EdgeInsets.all(size.width * 0.06),
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
              AppText(
                title,
                size: size.width * 0.05,
                weight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
                align: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.012),
              AppText(
                subtitle,
                size: size.width * 0.038,
                weight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                align: TextAlign.center,
              ),
              if (onAction != null && actionText != null) ...[
                SizedBox(height: size.height * 0.03),
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
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