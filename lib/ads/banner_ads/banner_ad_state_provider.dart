import 'package:Artleap.ai/shared/route_export.dart';

final bannerAdStateProvider = StateNotifierProvider<BannerAdStateNotifier, BannerAdState>((ref) {
  return BannerAdStateNotifier(ref);
});

class BannerAdState {
  final bool isExpanded;
  final bool isLoading;
  final bool adLoaded;
  final AdSize adSize;
  final int retryCount;

  BannerAdState({
    this.isExpanded = true,
    this.isLoading = false,
    this.adLoaded = false,
    AdSize? adSize,
    this.retryCount = 0,
  }) : adSize = adSize ?? AdSize.banner;

  BannerAdState copyWith({
    bool? isExpanded,
    bool? isLoading,
    bool? adLoaded,
    AdSize? adSize,
    int? retryCount,
  }) {
    return BannerAdState(
      isExpanded: isExpanded ?? this.isExpanded,
      isLoading: isLoading ?? this.isLoading,
      adLoaded: adLoaded ?? this.adLoaded,
      adSize: adSize ?? this.adSize,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

class BannerAdStateNotifier extends StateNotifier<BannerAdState> {
  final Ref _ref;
  BannerAd? _bannerAd;
  bool _isDisposed = false;

  BannerAdStateNotifier(this._ref) : super(BannerAdState());

  Future<void> initializeBannerAd() async {
    if (_isDisposed || state.isLoading || state.adLoaded) return;

    state = state.copyWith(isLoading: true);

    final showBannerAds = _ref.read(bannerAdsEnabledProvider);
    if (!showBannerAds) {
      state = state.copyWith(isLoading: false, adLoaded: false);
      return;
    }

    await _calculateAdSize();

    await _loadBannerAd();
  }

  Future<void> _calculateAdSize() async {
    try {
      final adaptiveAdSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(300);
      if (adaptiveAdSize != null) {
        state = state.copyWith(adSize: adaptiveAdSize);
      }
    } catch (e) {
      state = state.copyWith(adSize: AdSize.banner);
    }
  }

  Future<void> _loadBannerAd() async {
    if (_isDisposed) return;

    final showBannerAds = _ref.read(bannerAdsEnabledProvider);
    if (!showBannerAds) {
      state = state.copyWith(isLoading: false, adLoaded: false);
      return;
    }

    final adUnitId = _ref.read(remoteConfigProvider).bannerAdUnit;

    _bannerAd?.dispose();
    _bannerAd = null;

    _bannerAd = BannerAd(
      size: state.adSize,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (!_isDisposed) {
            state = state.copyWith(
              isLoading: false,
              adLoaded: true,
              retryCount: 0,
            );
          }
        },
        onAdFailedToLoad: (Ad ad, AdError error) {
          if (!_isDisposed) {
            state = state.copyWith(
              isLoading: false,
              adLoaded: false,
              retryCount: state.retryCount + 1,
            );

            // Auto retry silently without showing error
            if (state.retryCount < 3) {
              Future.delayed(const Duration(seconds: 2), () {
                if (!_isDisposed) {
                  _loadBannerAd();
                }
              });
            }
          }
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
      request: const AdRequest(),
    );

    await _bannerAd!.load();
  }

  void toggleExpand() {
    if (!_isDisposed) {
      state = state.copyWith(isExpanded: !state.isExpanded);
    }
  }

  Widget getBannerWidget() {
    final showBannerAds = _ref.read(bannerAdsEnabledProvider);

    if (_bannerAd == null || !showBannerAds || !state.adLoaded) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  void retryLoading() {
    if (!_isDisposed && !state.isLoading) {
      state = state.copyWith(retryCount: 0);
      initializeBannerAd();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }
}