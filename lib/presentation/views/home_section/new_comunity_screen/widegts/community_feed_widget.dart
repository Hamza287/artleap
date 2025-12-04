import '../components/communiry_header.dart';
import '../components/post_card.dart';
import 'package:Artleap.ai/shared/route_export.dart';

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
  double _previousScrollPosition = 0.0;
  bool _shouldRestoreScrollPosition = false;
  String? _previousSearchQuery;
  String? _previousFilter;
  bool _shouldRestoreFilterPosition = false;
  bool _isScrollControllerAttached = false;
  int _lastShownAdIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(homeScreenProvider).page == 0) {
        ref.read(homeScreenProvider).getUserCreations();
      }
      ref.read(interstitialAdProvider).loadInterstitialAd();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_isScrollControllerAttached) return;
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
    } else if (!isSearching &&
        _shouldRestoreScrollPosition &&
        _previousSearchQuery == null) {
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

  Future<void> _showInterstitialAdAfterPost(int postIndex) async {
    if ((postIndex + 1) % 3 == 0 && postIndex != _lastShownAdIndex) {
      _lastShownAdIndex = postIndex;
      await Future.delayed(const Duration(milliseconds: 500));
      final interstitialNotifier = ref.read(interstitialAdProvider);
      await interstitialNotifier.showInterstitialAd();
      interstitialNotifier.loadInterstitialAd();
    }
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
              ? const LoadingState(
            useShimmer: true,
            shimmerItemCount: 3,
            loadingType: LoadingType.post,
          )
              : RefreshIndicator(
            onRefresh: () async {
              await ref.read(homeScreenProvider).refreshUserCreations();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  _isScrollControllerAttached =
                      _scrollController.hasClients;
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                cacheExtent: 1000,
                itemCount: displayedImages.length +
                    (homeProvider.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= displayedImages.length) {
                    return const LoadingState(
                      useShimmer: true,
                      shimmerItemCount: 3,
                      loadingType: LoadingType.post,
                    );
                  }

                  final image = displayedImages[index];

                  final posts = ref
                      .read(homeScreenProvider)
                      .communityImagesList;
                  final ids = posts
                      .map((p) => p.userId)
                      .whereType<String>()
                      .toSet()
                      .toList();
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await ref
                        .read(userProfileProvider)
                        .getProfilesForUserIds(ids);
                  });

                  final profile = userProfileProviderWatch
                      .getProfileById(image.userId);
                  final profileImage = profile?.user.profilePic;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showInterstitialAdAfterPost(index);
                  });

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
}