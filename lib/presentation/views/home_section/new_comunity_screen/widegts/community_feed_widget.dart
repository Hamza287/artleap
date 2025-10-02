import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../components/communiry_header.dart';
import '../components/post_card.dart';
import 'shimmer_loading.dart';

class CommunityFeedWidget extends ConsumerStatefulWidget {
  const CommunityFeedWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityFeedWidgetState();
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

  Widget _buildLoadMoreShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBlue),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading more...',
            style: AppTextstyle.interMedium(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final homeProvider = ref.watch(homeScreenProvider);

    final filteredList = homeProvider.selectedStyleTitle != null
        ? homeProvider.filteredCreations
        : homeProvider.communityImagesList;

    return Column(
      children: [
        const CommunityHeader(),
        Expanded(
          child: homeProvider.usersData == null
              ? const ShimmerLoading()
              : RefreshIndicator(
            onRefresh: () async {
              await ref.read(homeScreenProvider).refreshUserCreations();
            },
            child: filteredList.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "No images available for this filter",
                      style: AppTextstyle.interMedium(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: filteredList.length +
                  (homeProvider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= filteredList.length) {
                  return _buildLoadMoreShimmer();
                }

                final image = filteredList[index];
                if (image == null) return const SizedBox.shrink();

                return PostCard(
                  image: image,
                  index: index,
                  homeProvider: homeProvider,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
