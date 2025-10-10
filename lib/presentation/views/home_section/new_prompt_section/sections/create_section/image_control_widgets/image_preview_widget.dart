import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagePreviewWidget extends ConsumerWidget {
  final File imageFile;
  final VoidCallback onRemove;

  const ImagePreviewWidget({
    super.key,
    required this.imageFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceVariant,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error,
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: theme.colorScheme.onError,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}