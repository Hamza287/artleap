import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:Artleap.ai/shared/utilities/safe_network_image.dart';

class ImageResultsGrid extends ConsumerWidget {
  final WidgetRef ref;

  const ImageResultsGrid({super.key, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generatedImages = ref.watch(generateImageProvider).generatedImage;
    final generatedTextToImageData =
        ref.watch(generateImageProvider).generatedTextToImageData;
    final isLoading = ref.watch(generateImageProvider).isGenerateImageLoading;

    if (isLoading) {
      return _buildLoadingGrid(theme);
    }

    final images =
    _getImagesToDisplay(generatedImages, generatedTextToImageData);

    if (images.isEmpty) {
      return _buildEmptyState(theme);
    }

    return _buildImagesGrid(context, ref, images, theme);
  }

  List<dynamic> _getImagesToDisplay(
      List<dynamic> generatedImages, List<dynamic> generatedTextToImageData) {
    if (generatedTextToImageData.isNotEmpty) {
      return generatedTextToImageData;
    } else if (generatedImages.isNotEmpty) {
      return generatedImages;
    }
    return [];
  }

  Widget _buildLoadingGrid(ThemeData theme) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: theme.colorScheme.surfaceContainerHighest,
          highlightColor: theme.colorScheme.surface,
          child: Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Shimmer.fromColors(
                baseColor: theme.colorScheme.surfaceContainerHighest,
                highlightColor: theme.colorScheme.surface,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No images generated',
            style: AppTextstyle.interMedium(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try generating some amazing AI art!',
            style: AppTextstyle.interRegular(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesGrid(
      BuildContext context, WidgetRef ref, List<dynamic> images, ThemeData theme) {
    final isSingleImage = images.length == 1;

    if (isSingleImage) {
      return _buildSingleImage(context, ref, images[0]!, theme);
    } else {
      return _buildMultipleImages(context, ref, images, theme);
    }
  }

  Widget _buildSingleImage(
      BuildContext context, WidgetRef ref, dynamic imageData, ThemeData theme) {
    return GestureDetector(
      onTap: () => _navigateToSeePicture(context, ref, imageData),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              _buildImageWidget(imageData.imageUrl, 280, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleImages(
      BuildContext context, WidgetRef ref, List<dynamic> images, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context),
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 1,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _buildGridImageItem(context, ref, images[index]!, index, theme);
          },
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 3;
    if (width > 400) return 2;
    return 2;
  }

  Widget _buildGridImageItem(
      BuildContext context, WidgetRef ref, dynamic imageData, int index, ThemeData theme) {
    return GestureDetector(
      onTap: () => _navigateToSeePicture(context, ref, imageData),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              _buildImageWidget(imageData.imageUrl, 150, theme),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: theme.colorScheme.surface,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Add a subtle overlay on hover/tap
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        theme.colorScheme.onSurface.withOpacity(0.3),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl, double height, ThemeData theme) {
    return SafeNetworkImage(
      imageUrl: imageUrl,
      placeholder: (_, __) => Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      errorWidget: (_, __, error) => Container(
        height: height,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSeePicture(
      BuildContext context, WidgetRef ref, dynamic imageData) {
    final isTextToImage =
        ref.watch(generateImageProvider).generatedTextToImageData.isNotEmpty;

    // Use Navigator directly instead of Navigation.pushNamed to ensure it works
    Navigator.of(context).pushNamed(
      SeePictureScreen.routeName,
      arguments: SeePictureParams(
        profileName: UserData.ins.userName ?? 'User',
        userId: UserData.ins.userId ?? '',
        imageId: imageData.id ?? '',
        modelName: isTextToImage
            ? ref.read(generateImageProvider).selectedStyle
            : imageData.presetStyle ?? 'Unknown Model',
        prompt: isTextToImage
            ? ref.read(generateImageProvider).promptTextController.text
            : imageData.prompt ?? 'No prompt',
        image: imageData.imageUrl ?? '',
        privacy: imageData.privacy ?? 'public',
      ),
    );
  }
}