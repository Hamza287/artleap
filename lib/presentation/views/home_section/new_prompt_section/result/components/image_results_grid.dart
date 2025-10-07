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
    final generatedImages = ref.watch(generateImageProvider).generatedImage;
    final generatedTextToImageData =
        ref.watch(generateImageProvider).generatedTextToImageData;
    final isLoading = ref.watch(generateImageProvider).isGenerateImageLoading;

    if (isLoading) {
      return _buildLoadingGrid();
    }

    final images =
    _getImagesToDisplay(generatedImages, generatedTextToImageData);

    if (images.isEmpty) {
      return _buildEmptyState();
    }

    return _buildImagesGrid(context, ref, images);
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

  Widget _buildLoadingGrid() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
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
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
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

  Widget _buildEmptyState() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No images generated',
            style: AppTextstyle.interMedium(
              fontSize: 16,
              color: Colors.grey[600]!,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try generating some amazing AI art!',
            style: AppTextstyle.interRegular(
              fontSize: 14,
              color: Colors.grey[500]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesGrid(
      BuildContext context, WidgetRef ref, List<dynamic> images) {
    final isSingleImage = images.length == 1;

    if (isSingleImage) {
      return _buildSingleImage(context, ref, images[0]!);
    } else {
      return _buildMultipleImages(context, ref, images);
    }
  }

  Widget _buildSingleImage(
      BuildContext context, WidgetRef ref, dynamic imageData) {
    return GestureDetector(
      onTap: () => _navigateToSeePicture(context, ref, imageData),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              _buildImageWidget(imageData.imageUrl, 280),
              // Removed the eye icon button from here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleImages(
      BuildContext context, WidgetRef ref, List<dynamic> images) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            return _buildGridImageItem(context, ref, images[index]!, index);
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
      BuildContext context, WidgetRef ref, dynamic imageData, int index) {
    return GestureDetector(
      onTap: () => _navigateToSeePicture(context, ref, imageData),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              _buildImageWidget(imageData.imageUrl, 150),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
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
                        Colors.black.withOpacity(0.3),
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

  Widget _buildImageWidget(String imageUrl, double height) {
    return SafeNetworkImage(
      imageUrl: imageUrl,
      placeholder: (_, __) => Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      errorWidget: (_, __, error) => Container(
        height: height,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              'Failed to load',
              style: TextStyle(color: Colors.grey[600]),
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