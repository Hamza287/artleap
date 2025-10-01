import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CommunityFeedWidget extends ConsumerStatefulWidget {
  const CommunityFeedWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommunityFeedWidgetState();
}

class _CommunityFeedWidgetState extends ConsumerState<CommunityFeedWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.watch(homeScreenProvider).page == 0) {
        ref.read(homeScreenProvider).getUserCreations();
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !ref.watch(homeScreenProvider).isLoadingMore) {
        ref.read(homeScreenProvider).loadMoreImages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = ref.watch(homeScreenProvider);
    final filteredList = homeProvider.filteredCreations.isNotEmpty
        ? homeProvider.filteredCreations
        : homeProvider.communityImagesList;

    return Column(
      children: [
        // Filter Section
        _buildFilterSection(),

        // Feed
        Expanded(
          child: homeProvider.usersData == null
              ? _buildShimmerLoading()
              : _buildFeedList(filteredList, homeProvider),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer user info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 16,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 12,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Shimmer image
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),
              ),

              // Shimmer buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Community Feed',
            style: AppTextstyle.interBold(
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) {
              return _buildFilterButton();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBlue, AppColors.darkBlue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.filter_alt_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            'Filter',
            style: AppTextstyle.interMedium(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedList(List filteredList, HomeScreenProvider homeProvider) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: filteredList.length + (homeProvider.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= filteredList.length) {
          return _buildLoadMoreShimmer();
        }

        final image = filteredList[index];
        if (image == null) return const SizedBox.shrink();

        return _buildPostCard(image, index, homeProvider);
      },
    );
  }

  Widget _buildLoadMoreShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(dynamic image, int index, HomeScreenProvider homeProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Section
          _buildUserInfoSection(image),

          // Image Section
          _buildImageSection(image, homeProvider, index),

          // Action Buttons
          _buildActionButtons(image),

          // Description and Stats
          _buildDescriptionSection(image),

          // Comments Preview
          _buildCommentsPreview(),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(dynamic image) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.darkBlue, AppColors.pinkColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBlue.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getUserInitials(image),
                style: AppTextstyle.interBold(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDisplayName(image),
                  style: AppTextstyle.interBold(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'AI Art Creator',
                  style: AppTextstyle.interRegular(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          _buildMoreOptionsButton(),
        ],
      ),
    );
  }

  Widget _buildMoreOptionsButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.more_horiz,
        color: Colors.grey.shade600,
        size: 20,
      ),
    );
  }

  Widget _buildImageSection(dynamic image, HomeScreenProvider homeProvider, int index) {
    return VisibilityDetector(
      key: Key('image-${image.id}'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        const double bufferZone = 300.0;
        final bool isInBufferZone =
            info.visibleBounds.top - bufferZone < 0 &&
                info.visibleBounds.bottom + bufferZone > 0;
        if (isInBufferZone) {
          ref
              .read(homeScreenProvider)
              .visibilityInfo(info, image.imageUrl);
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
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
          ),
          child: homeProvider.visibleImages.contains(image.imageUrl)
              ? CachedNetworkImage(
            imageUrl: image.imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: Duration.zero,
            placeholder: (context, url) => _buildImageShimmer(),
            errorWidget: (context, url, error) {
              return _buildErrorPlaceholder();
            },
          )
              : _buildImageShimmer(),
        ),
      ),
    );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 400,
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

  Widget _buildActionButtons(dynamic image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Like Button
          _buildActionButton(
            icon: Icons.favorite_outline,
            activeIcon: Icons.favorite,
            label: 'Like',
            count: _getRandomLikes(image),
            isActive: false,
            onPressed: () {},
          ),

          const SizedBox(width: 16),

          // Comment Button
          _buildActionButton(
            icon: Icons.mode_comment_outlined,
            activeIcon: Icons.mode_comment,
            label: 'Comment',
            count: _getRandomCommentCount(image),
            isActive: false,
            onPressed: () {},
          ),

          const Spacer(),

          // Share Button
          _buildIconButton(
            icon: Icons.share_outlined,
            onPressed: () {},
          ),

          const SizedBox(width: 12),

          // Save Button
          _buildIconButton(
            icon: Icons.bookmark_outline,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String count,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.darkBlue.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.darkBlue : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.darkBlue : Colors.grey.shade700,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              count,
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: isActive ? AppColors.darkBlue : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.grey.shade700,
        size: 20,
      ),
    );
  }

  Widget _buildDescriptionSection(dynamic image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt Section with enhanced visibility
          if (image.prompt != null && image.prompt!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.darkBlue.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.darkBlue,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'AI Prompt',
                        style: AppTextstyle.interBold(
                          fontSize: 12,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    image.prompt!,
                    style: AppTextstyle.interRegular(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

          // Engagement stats
          Row(
            children: [
              Text(
                '${_getRandomLikes(image)} likes',
                style: AppTextstyle.interBold(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${_getRandomCommentCount(image)} comments',
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Timestamp
          Text(
            _getTimeAgo(image),
            style: AppTextstyle.interRegular(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCommentsPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkBlue, AppColors.darkBlue.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Post',
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getUserInitials(dynamic image) {
    if (image.username != null && image.username!.isNotEmpty) {
      final names = image.username!.split(' ');
      if (names.length > 1) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return image.username!.substring(0, 1).toUpperCase();
    }
    if (image.userEmail != null && image.userEmail!.isNotEmpty) {
      return image.userEmail!.substring(0, 1).toUpperCase();
    }
    return 'A';
  }

  String _getDisplayName(dynamic image) {
    if (image.username != null && image.username!.isNotEmpty) {
      return image.username!;
    }
    if (image.userEmail != null && image.userEmail!.isNotEmpty) {
      return image.userEmail!.split('@')[0];
    }
    return 'Anonymous Artist';
  }

  String _getRandomLikes(dynamic image) {
    final likes = ['1.2K', '856', '432', '2.1K', '567', '789', '934', '1.5K'];
    return likes[(image.id?.hashCode ?? 0).abs() % likes.length];
  }

  String _getRandomCommentCount(dynamic image) {
    final counts = ['24', '12', '36', '8', '45', '18', '6', '29'];
    return counts[(image.id?.hashCode ?? 0).abs() % counts.length];
  }

  String _getTimeAgo(dynamic image) {
    if (image.createdAt == null) return 'Recently';
    final times = ['2 hours ago', '1 day ago', '3 hours ago', 'Just now', '5 days ago', '1 week ago'];
    return times[(image.id?.hashCode ?? 0).abs() % times.length];
  }
}