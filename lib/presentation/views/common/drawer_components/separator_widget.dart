import 'package:Artleap.ai/shared/route_export.dart';

class SeparatorWidget extends ConsumerWidget {
  final String title;
  final Color? textColor;
  final Color? lineColor;
  final double lineWidth;
  final double fontSize;

  const SeparatorWidget({
    super.key,
    required this.title,
    this.textColor,
    this.lineColor,
    this.lineWidth = 200,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final effectiveTextColor = textColor ??
        (isDark ? theme.colorScheme.onSurface : AppColors.white);

    final effectiveLineColor = lineColor ??
        (isDark ? theme.colorScheme.onSurface.withOpacity(0.3) : AppColors.white.withOpacity(0.5));

    return Container(
      height: 20,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            title,
            style: AppTextstyle.interRegular(
              color: effectiveTextColor,
              fontSize: fontSize,
            ),
          ),
          5.spaceX,
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveLineColor,
                    effectiveLineColor.withOpacity(0.1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}