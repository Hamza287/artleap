import 'package:Artleap.ai/shared/route_export.dart';

enum ItemType { post, ad }

class AdItem {
  final ItemType type;
  final int index;

  AdItem({required this.type, required this.index});
}

class CommunityFeedWidget extends ConsumerStatefulWidget {
  const CommunityFeedWidget({super.key});

  @override
  ConsumerState createState() => _CommunityFeedWidgetState();
}

class _CommunityFeedWidgetState extends ConsumerState<CommunityFeedWidget> {
  final ScrollController _scrollController = ScrollController();

  bool _shouldLoadNewAd = false;
  bool _isFirstBuild = true;
  bool _isScrollControllerAttached = false;

  late NativeAdNotifier _nativeAdNotifier;

  final Set<int> _adPositions = {};
  final int _adFrequency = 4;

  @override
  void initState() {
    super.initState();

    _nativeAdNotifier = ref.read(nativeAdProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (ref.read(homeScreenProvider).page == 0) {
        ref.read(homeScreenProvider).getUserCreations();
      }

      _loadNativeAd();
    });

    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadNativeAd() async {
    if (RemoteConfigService.instance.showNativeAds) {
      await _nativeAdNotifier.loadNativeAd();
    }
  }

  void _onScroll() {
    if (!_isScrollControllerAttached) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !ref.read(homeScreenProvider).isLoadingMore) {
      ref.read(homeScreenProvider).loadMoreImages();
    }

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

    final adState = ref.read(nativeAdProvider);
    _adPositions.clear();

    for (int i = _adFrequency; i < posts.length; i += _adFrequency) {
      _adPositions.add(i);
    }

    final List<dynamic> itemsWithAds = [];
    int adIndex = 0;

    for (int i = 0; i < posts.length; i++) {
      itemsWithAds.add(posts[i]);

      if (_adPositions.contains(i + 1)) {
        if (adState.isLoaded && adState.nativeAd != null) {
          itemsWithAds.add(AdItem(type: ItemType.ad, index: adIndex++));
        } else if (adState.errorMessage != null && _shouldLoadNewAd) {
          _loadNativeAd();
          _shouldLoadNewAd = false;
        }
      }
    }

    return itemsWithAds;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    _nativeAdNotifier.safeDisposeAd(); // ✅ SAFE

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = ref.watch(homeScreenProvider);
    final userProfileProviderWatch = ref.watch(userProfileProvider);

    final displayedImages = homeProvider.getDisplayedImages();
    final itemsWithAds = _getItemsWithAds(displayedImages);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _isScrollControllerAttached = _scrollController.hasClients;
      if (_isFirstBuild && _scrollController.hasClients) {
        _isFirstBuild = false;
      }
    });

    return Column(
      children: [
        CommunityHeader(
          onSearchStateChanged: (a, b) {},
          onFilterStateChanged: (x) {},
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
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              cacheExtent: 1000,
              itemCount:
              itemsWithAds.length + (homeProvider.isLoadingMore ? 1 : 0),
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
                        if (mounted) _loadNativeAd();
                      });
                    },
                  );
                }

                final image = item;

                final posts = ref.read(homeScreenProvider).communityImagesList;
                final ids = posts.map((p) => p.userId).whereType<String>().toSet().toList();

                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (!mounted) return;
                  await ref.read(userProfileProvider.notifier)
                      .getProfilesForUserIds(ids);
                });

                final profile =
                userProfileProviderWatch.value?.profilesCache[image.userId];

                return PostCard(
                  key: ValueKey('post_${image.id}_$index'),
                  image: image,
                  index: index,
                  homeProvider: homeProvider,
                  profileImage: profile?.user.profilePic,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
