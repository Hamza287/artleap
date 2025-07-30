import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../sections/create_section/image_control_widgets/style_selection_card.dart';

void showStylesBottomSheet(BuildContext context, WidgetRef ref) {
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top drag handle with close button
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              "Select Style",
              style: AppTextstyle.interMedium(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // Styles grid
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