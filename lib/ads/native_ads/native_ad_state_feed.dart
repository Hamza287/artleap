import 'package:Artleap.ai/shared/route_export.dart';

// Native Ad Provider for Feed
final nativeAdProviderFeed = StateNotifierProvider<NativeAdNotifierFeed, NativeAdStateFeed>((ref) {
  return NativeAdNotifierFeed();
});

class NativeAdStateFeed {
  final NativeAd? nativeAd;
  final bool isLoading;
  final bool isLoaded;
  final bool showAds;
  final int retryCount;
  final String? errorMessage;

  NativeAdStateFeed({
    this.nativeAd,
    this.isLoading = false,
    this.isLoaded = false,
    this.showAds = true,
    this.retryCount = 0,
    this.errorMessage,
  });

  NativeAdStateFeed copyWith({
    NativeAd? nativeAd,
    bool? isLoading,
    bool? isLoaded,
    bool? showAds,
    int? retryCount,
    String? errorMessage,
  }) {
    return NativeAdStateFeed(
      nativeAd: nativeAd ?? this.nativeAd,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      showAds: showAds ?? this.showAds,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage,
    );
  }
}

class NativeAdNotifierFeed extends StateNotifier<NativeAdStateFeed> {
  NativeAdNotifierFeed() : super(NativeAdStateFeed());

  Future<void> loadNativeAd() async {
    final config = RemoteConfigService.instance;

    if (!config.showNativeAds) {
      state = state.copyWith(showAds: false);
      return;
    }

    if (state.isLoading || state.isLoaded) return;

    if (!AdService.instance.isInitialized) {
      await AdService.instance.initialize();
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final ad = NativeAd(
        adUnitId: config.nativeAdUnit,
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.medium,
          cornerRadius: 12,
        ),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            state = state.copyWith(
              nativeAd: ad as NativeAd,
              isLoading: false,
              isLoaded: true,
              retryCount: 0,
              errorMessage: null,
            );
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            state = state.copyWith(
              nativeAd: null,
              isLoading: false,
              isLoaded: false,
              retryCount: state.retryCount + 1,
              errorMessage: error.message,
            );
          },
        ),
      );

      await ad.load();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void disposeAd() {
    state.nativeAd?.dispose();
    state = state.copyWith(
      nativeAd: null,
      isLoaded: false,
      isLoading: false,
    );
  }

  void resetAd() {
    disposeAd();
    loadNativeAd();
  }

  @override
  void dispose() {
    state.nativeAd?.dispose();
    super.dispose();
  }
}