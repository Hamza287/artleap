import 'package:Artleap.ai/shared/route_export.dart';

class ReportCommonButton extends ConsumerWidget {
  final String title;
  final VoidCallback? onpress;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final Color? textColor;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final bool showShadow;
  final bool isDisabled;
  final bool isLoading;

  const ReportCommonButton({
    super.key,
    required this.title,
    this.onpress,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.height,
    this.textColor,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.showShadow = false,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = isDisabled || isLoading
        ? theme.colorScheme.surfaceContainerHighest
        : backgroundColor ?? theme.colorScheme.primary;
    final effectiveTextColor = isDisabled || isLoading
        ? theme.colorScheme.onSurfaceVariant
        : textColor ?? theme.colorScheme.onPrimary;
    final effectiveIconColor = isDisabled || isLoading
        ? theme.colorScheme.onSurfaceVariant
        : iconColor ?? theme.colorScheme.onPrimary;

    return Container(
      width: width,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(
          color: isDisabled || isLoading
              ? theme.colorScheme.outline.withOpacity(0.3)
              : borderColor!,
          width: 1.5,
        )
            : null,
        boxShadow: showShadow && !isDisabled && !isLoading
            ? [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled || isLoading ? null : onpress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  isLoading ? "Submitting..." : title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: effectiveTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (icon != null && !isLoading) ...[
                  const SizedBox(width: 8),
                  Icon(
                    icon,
                    size: iconSize ?? 18,
                    color: effectiveIconColor,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}