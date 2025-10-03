import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class PostImage extends ConsumerWidget {
  final dynamic image;
  final HomeScreenProvider homeProvider;
  final int index;

  const PostImage({
    super.key,
    required this.image,
    required this.homeProvider,
    required this.index,
  });

  String _getDisplayName(dynamic image) {
    if (image.username != null && image.username!.isNotEmpty) {
      return image.username!;
    }
    if (image.userEmail != null && image.userEmail!.isNotEmpty) {
      return image.userEmail!.split('@')[0];
    }
    return 'Anonymous Artist';
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey.shade400,
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              'Image not available',
              style: AppTextstyle.interRegular(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isImageVisible = homeProvider.visibleImages.contains(image.imageUrl);

    return VisibilityDetector(
      key: Key('image-${image.id}'),
      onVisibilityChanged: (info) {
        if (!context.mounted) return;
        const double bufferZone = 500.0;
        final bool isInBufferZone =
            info.visibleBounds.top - bufferZone < 0 &&
                info.visibleBounds.bottom + bufferZone > 0;

        if (isInBufferZone && !homeProvider.visibleImages.contains(image.imageUrl)) {
          // Add to visible images to trigger loading
          ref.read(homeScreenProvider).visibilityInfo(info, image.imageUrl);
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigation.pushNamed(
            SeePictureScreen.routeName,
            arguments: SeePictureParams(
              imageId: image.id,
              userId: image.userId,
              profileName: image.username ?? _getDisplayName(image),
              image: image.imageUrl,
              prompt: image.prompt,
              modelName: image.modelName,
              createdDate: image.createdAt,
              index: index,
              creatorEmail: image.userEmail,
              privacy: image.privacy,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 450,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
          ),
          child: isImageVisible
              ? CachedNetworkImage(
            imageUrl: image.imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: Duration.zero,
            placeholder: (context, url) => _buildImageShimmer(),
            errorWidget: (context, url, error) => _buildErrorPlaceholder(),
            cacheKey: image.imageUrl,
            maxWidthDiskCache: 1080,
            maxHeightDiskCache: 1080,
            useOldImageOnUrlChange: true,
          )
              : _buildImageShimmer(),
        ),
      ),
    );
  }
}