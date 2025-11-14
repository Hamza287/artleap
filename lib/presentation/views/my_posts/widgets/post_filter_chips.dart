import 'package:Artleap.ai/shared/route_export.dart';

class PostsFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const PostsFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(
        label,
        style: AppTextstyle.interMedium(
          fontSize: 13,
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      selectedColor: theme.colorScheme.primary,
      checkmarkColor: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}