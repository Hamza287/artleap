import 'package:flutter/material.dart';

import 'saved_image_card.dart';

class SavedImagesGrid extends StatelessWidget {
  final List<String> savedImageIds;
  final Function(String) onUnsave;

  const SavedImagesGrid({
    super.key,
    required this.savedImageIds,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final imageId = savedImageIds[index];
            return SavedImageCard(
              imageId: imageId,
              onUnsave: () => onUnsave(imageId),
            );
          },
          childCount: savedImageIds.length,
        ),
      ),
    );
  }
}