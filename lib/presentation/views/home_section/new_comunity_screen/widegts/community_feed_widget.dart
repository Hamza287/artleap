import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import '../components/communiry_header.dart';
import '../components/post_card.dart';
import 'no_image_widget.dart';
import 'shimmer_loading.dart';

class CommunityFeedWidget extends ConsumerStatefulWidget {
  const CommunityFeedWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommunityFeedWidgetState();
}

class _CommunityFeedWidgetState extends ConsumerState<CommunityFeedWidget> {
  final ScrollController _scrollController = ScrollController();
  final _throttleDuration = const Duration(milliseconds: 200);
  DateTime? _lastScrollTime;
  double _previousScrollPosition = 0.0;
  bool _shouldRestoreScrollPosition = false;
  String? _previousSearchQuery;
  String? _previousFilter;
  bool _shouldRestoreFilterPosition = false;
  bool _isScrollControllerAttached = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(homeScreenProvider).page == 0) {
        ref.read(homeScreenProvider).getUserCreations();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_isScrollControllerAttached) return;

    final now = DateTime.now();
    if (_lastScrollTime != null && now.difference(_lastScrollTime!) < _throttleDuration) {
      return;
    }
    _lastScrollTime = now;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && !ref.read(homeScreenProvider).isLoadingMore) {
      ref.read(homeScreenProvider).loadMoreImages();
    }
  }

  void _handleSearchStateChange(bool isSearching, String? searchQuery) {
    final homeProvider = ref.read(homeScreenProvider);

    if (isSearching && searchQuery != null && searchQuery.isNotEmpty) {
      if (_isScrollControllerAttached) {
        _previousScrollPosition = _scrollController.position.pixels;
        _shouldRestoreScrollPosition = true;
      }
      _previousSearchQuery = searchQuery;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isScrollControllerAttached && _scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    } else if (!isSearching && _shouldRestoreScrollPosition && _previousSearchQuery == null) {
      _shouldRestoreScrollPosition = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isScrollControllerAttached && _scrollController.hasClients) {
          _scrollController.animateTo(
            _previousScrollPosition,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
    _previousSearchQuery = searchQuery;
  }

  void _handleFilterStateChange(String? newFilter) {
    final homeProvider = ref.read(homeScreenProvider);

    if (newFilter != null) {
      if (_isScrollControllerAttached) {
        _previousScrollPosition = _scrollController.position.pixels;
      }
      _previousFilter = homeProvider.selectedStyleTitle;
      _shouldRestoreFilterPosition = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isScrollControllerAttached && _scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    } else if (_shouldRestoreFilterPosition && _previousFilter != null) {
      _shouldRestoreFilterPosition = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isScrollControllerAttached && _scrollController.hasClients) {
          _scrollController.animateTo(
            _previousScrollPosition,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  Widget _buildLoadMoreShimmer() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeProvider = ref.watch(homeScreenProvider);
    final userProfileProviderWatch = ref.watch(userProfileProvider);

    final displayedImages = homeProvider.getDisplayedImages();
    final hasActiveFilter = homeProvider.selectedStyleTitle != null;

    if (hasActiveFilter && _previousFilter != homeProvider.selectedStyleTitle) {
      _handleFilterStateChange(homeProvider.selectedStyleTitle);
    } else if (!hasActiveFilter && _previousFilter != null) {
      _handleFilterStateChange(null);
    }

    return Column(
      children: [
        CommunityHeader(
          onSearchStateChanged: _handleSearchStateChange,
          onFilterStateChanged: _handleFilterStateChange,
        ),
        Expanded(
          child: homeProvider.usersData == null
              ? const ShimmerLoading()
              : RefreshIndicator(
            onRefresh: () async {
              await ref.read(homeScreenProvider).refreshUserCreations();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  _isScrollControllerAttached = _scrollController.hasClients;
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                cacheExtent: 1000,
                itemCount: displayedImages.length + (homeProvider.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= displayedImages.length) {
                    return _buildLoadMoreShimmer();
                  }

                  final image = displayedImages[index];

                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    final posts = ref.read(homeScreenProvider).communityImagesList;
                    final ids = posts.map((p) => p.userId).whereType<String>().toSet().toList();
                    await ref.read(userProfileProvider).getProfilesForUserIds(ids);
                  });

                  final profile = userProfileProviderWatch.getProfileById(image.userId);
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
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool hasActiveSearch, bool hasActiveFilter, HomeScreenProvider homeProvider) {
    if (hasActiveSearch) {
      return NoContentWidget.noSearchResults(query: homeProvider.searchQuery);
    } else if (hasActiveFilter) {
      return NoContentWidget.noImagesForFilter(
        filterName: homeProvider.selectedStyleTitle,
        onClearFilter: () {
          ref.read(homeScreenProvider.notifier).clearFilteredList();
        },
      );
    } else {
      return NoContentWidget.noImages();
    }
  }
}