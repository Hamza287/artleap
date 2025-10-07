import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';

class PromptSection extends ConsumerWidget {
  final WidgetRef ref;

  const PromptSection({super.key, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generatedImages = ref.watch(generateImageProvider).generatedImage;
    final isLoading = ref.watch(generateImageProvider).isGenerateImageLoading;

    if (isLoading) {
      return _buildLoadingPrompt();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Prompt',
              style: AppTextstyle.interMedium(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            _buildEditButton(),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[50]!, Colors.grey[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getPromptText(ref, generatedImages),
                style: AppTextstyle.interRegular(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildPromptStats(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPrompt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }

  String _getPromptText(WidgetRef ref, List<dynamic> generatedImages) {
    final promptController = ref.watch(generateImageProvider).promptTextController;

    if (promptController.text.isNotEmpty) {
      return promptController.text;
    } else if (generatedImages.isNotEmpty) {
      return generatedImages[0]!.prompt;
    } else {
      return "No prompt available";
    }
  }

  Widget _buildEditButton() {
    return Tooltip(
      message: "Coming soon",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, size: 16, color: Colors.blue[600]),
            const SizedBox(width: 4),
            Text(
              'Edit Prompt',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptStats() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildStatChip(Icons.style, 'Artistic'),
        _buildStatChip(Icons.aspect_ratio, '1024x1024'),
        _buildStatChip(Icons.photo_camera, 'Vibrant'),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}