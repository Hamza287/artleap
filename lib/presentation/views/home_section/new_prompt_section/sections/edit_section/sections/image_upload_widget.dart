import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/prompt_edit_provider.dart';

class ImageUploadContainer extends ConsumerWidget {
  final bool isLargeScreen;
  final double maxHeight;

  const ImageUploadContainer({
    super.key,
    required this.isLargeScreen,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(promptEditProvider);
    final uploadedImage = state.uploadedImageFile;

    return Container(
      height: 364,
      constraints: BoxConstraints(maxHeight: maxHeight * 0.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Stack(
        children: [
          if (uploadedImage != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(uploadedImage.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: isLargeScreen ? 100 : 100,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Upload Image",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          if (uploadedImage != null)
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                    Icons.close,
                    color: theme.colorScheme.error,
                    size: 24
                ),
                onPressed: () => ref.read(promptEditProvider.notifier).removeImage(),
              ),
            ),
        ],
      ),
    );
  }
}