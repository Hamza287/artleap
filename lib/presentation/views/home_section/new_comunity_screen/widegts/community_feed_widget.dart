import 'package:Artleap.ai/shared/route_export.dart';

enum ItemType { post, ad }

class AdItem {
  final ItemType type;
  final int index;

  AdItem({
    required this.type,
    required this.index,
  });
}

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
  final Set<int> _adPositions = {};
  int _adFrequency = 4;
  bool _isFirstBuild = true;
  bool _shouldLoadNewAd = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(homeScreenProvider).page == 0) {
        ref.read(homeScreenProvider).getUserCreations();
      }
      _loadNativeAd();
    });

    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadNativeAd() async {
    if (RemoteConfigService.instance.showNativeAds) {
      await ref.read(nativeAdProviderFeed.notifier).loadNativeAd();
    }
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

    _checkForAdLoad();
  }

  void _checkForAdLoad() {
    if (!_scrollController.hasClients || !_isScrollControllerAttached) return;

    final currentPosition = _scrollController.position.pixels;
    final maxPosition = _scrollController.position.maxScrollExtent;

    if (currentPosition > maxPosition * 0.7) {
      _shouldLoadNewAd = true;
    }
  }

  List<dynamic> _getItemsWithAds(List<dynamic> posts) {
    if (!RemoteConfigService.instance.showNativeAds || posts.isEmpty) {
      return posts;
    }

    final adState = ref.read(nativeAdProviderFeed);

    if (posts.length ~/ _adFrequency != _adPositions.length) {
      _adPositions.clear();
      for (int i = _adFrequency; i < posts.length; i += _adFrequency) {
        _adPositions.add(i);
      }
    }

    final List<dynamic> itemsWithAds = [];
    int adIndex = 0;

    for (int i = 0; i < posts.length; i++) {
      itemsWithAds.add(posts[i]);

      if (_adPositions.contains(i + 1)) {
        if (adState.isLoaded && adState.nativeAd != null) {
          itemsWithAds.add(AdItem(
            type: ItemType.ad,
            index: adIndex++,
          ));
        } else if (adState.errorMessage != null && _shouldLoadNewAd) {
          _loadNativeAd();
          _shouldLoadNewAd = false;
        }
      }
    }

    return itemsWithAds;
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

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    ref.read(nativeAdProviderFeed.notifier).disposeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeProvider = ref.watch(homeScreenProvider);
    final userProfileProviderWatch = ref.watch(userProfileProvider);
    final displayedImages = homeProvider.getDisplayedImages();
    final hasActiveFilter = homeProvider.selectedStyleTitle != null;

    final itemsWithAds = _getItemsWithAds(displayedImages);

    if (hasActiveFilter && _previousFilter != homeProvider.selectedStyleTitle) {
      _handleFilterStateChange(homeProvider.selectedStyleTitle);
    } else if (!hasActiveFilter && _previousFilter != null) {
      _handleFilterStateChange(null);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isScrollControllerAttached = _scrollController.hasClients;
      if (_isFirstBuild && _scrollController.hasClients) {
        _isFirstBuild = false;
      }
    });

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
              _loadNativeAd();
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
                itemCount: itemsWithAds.length +
                    (homeProvider.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= itemsWithAds.length) {
                    return const LoadingState(
                      useShimmer: true,
                      shimmerItemCount: 3,
                      loadingType: LoadingType.post,
                    );
                  }

                  final item = itemsWithAds[index];

                  if (item is AdItem) {
                    return NativeAdPostWidget(
                      key: ValueKey('native_ad_${item.index}'),
                      onAdDisposed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _loadNativeAd();
                        });
                      },
                    );
                  }

                  final image = item;

                  final posts =
                      ref.read(homeScreenProvider).communityImagesList;
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

                  final profile =
                  userProfileProviderWatch.getProfileById(image.userId);
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
}