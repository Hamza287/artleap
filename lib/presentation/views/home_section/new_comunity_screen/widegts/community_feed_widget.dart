import 'package:Artleap.ai/providers/user_profile_provider.dart';
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
  final _throttleDuration = const Duration(milliseconds: 200);
  DateTime? _lastScrollTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(homeScreenProvider).page == 0) {
        ref.read(homeScreenProvider).getUserCreations();
      }
    });

    _scrollController.addListener(() {
      final now = DateTime.now();
      if (_lastScrollTime != null &&
          now.difference(_lastScrollTime!) < _throttleDuration) {
        return;
      }
      _lastScrollTime = now;

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !ref.read(homeScreenProvider).isLoadingMore) {
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBlue),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = ref.watch(homeScreenProvider);
    final userProfileProviderWatch = ref.watch(userProfileProvider);
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
              cacheExtent: 1000,
              itemCount: filteredList.length +
                  (homeProvider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= filteredList.length) {
                  return _buildLoadMoreShimmer();
                }

                final image = filteredList[index];
                if (image == null) return const SizedBox.shrink();

                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final posts = ref.read(homeScreenProvider).communityImagesList;
                  final ids = posts.map((p) => p.userId).whereType<String>().toSet().toList();
                  await ref.read(userProfileProvider).getProfilesForUserIds(ids);});
                final profile = userProfileProviderWatch.getProfileById(image.userId ?? "");
                final profileImage = profile?.user.profilePic;

                return PostCard(
                  key: ValueKey('post_${image.id}_$index'),
                  image: image,
                  index: index,
                  homeProvider: homeProvider,
                  profileImage: profileImage,
                );
              },
            ),
          ),
        ),

      ],
    );
  }
}