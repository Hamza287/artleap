import 'style_selection_card.dart';
import 'package:Artleap.ai/shared/route_export.dart';

void showStylesBottomSheet(BuildContext context, WidgetRef ref) {
  final theme = Theme.of(context);
  final selectedStyle = ref.watch(generateImageProvider).selectedStyle;
  final styles = ref.watch(generateImageProvider).images.isEmpty
      ? freePikStyles
      : textToImageStyles;

  // Sort to show selected style first
  final sortedStyles = List.from(styles)
    ..sort((a, b) => a['title'] == selectedStyle ? -1 : 1);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;

      return Container(
        height: screenHeight * 0.75, // 75% of screen height
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Styles",
                    style: AppTextstyle.interBold(
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 24,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: sortedStyles.length,
                itemBuilder: (context, index) {
                  final style = sortedStyles[index];
                  return StyleSelectionCard(
                    title: style['title'] ?? '',
                    icon: style['icon'] ?? '',
                    isSelected: style['title'] == selectedStyle,
                    onTap: () {
                      ref.read(generateImageProvider.notifier).selectedStyle = style['title'];
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}