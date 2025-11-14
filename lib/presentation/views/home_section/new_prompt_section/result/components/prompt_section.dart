import 'package:Artleap.ai/shared/route_export.dart';

class PromptSection extends ConsumerWidget {
  final WidgetRef ref;

  const PromptSection({super.key, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generatedImages = ref.watch(generateImageProvider).generatedImage;
    final isLoading = ref.watch(generateImageProvider).isGenerateImageLoading;

    if (isLoading) {
      return _buildLoadingPrompt(theme);
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
                color: theme.colorScheme.onSurface,
              ),
            ),
            _buildEditButton(theme),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surfaceContainerHighest,
                theme.colorScheme.surfaceContainerHighest.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getPromptText(ref, generatedImages),
                style: AppTextstyle.interRegular(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              _buildPromptStats(theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPrompt(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
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

  Widget _buildEditButton(ThemeData theme) {
    return Tooltip(
      message: "Coming soon",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Edit Prompt',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptStats(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildStatChip(Icons.style, 'Artistic', theme),
        _buildStatChip(Icons.aspect_ratio, '1024x1024', theme),
        _buildStatChip(Icons.photo_camera, 'Vibrant', theme),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}