import 'package:Artleap.ai/shared/route_export.dart';

final nativeAdProvider =
StateNotifierProvider<NativeAdNotifier, NativeAdState>((ref) {
  return NativeAdNotifier();
});

class NativeAdState {
  final NativeAd? nativeAd;
  final bool isLoading;
  final bool isLoaded;
  final bool showAds;
  final int retryCount;
  final String? errorMessage;

  NativeAdState({
    this.nativeAd,
    this.isLoading = false,
    this.isLoaded = false,
    this.showAds = true,
    this.retryCount = 0,
    this.errorMessage,
  });

  NativeAdState copyWith({
    NativeAd? nativeAd,
    bool? isLoading,
    bool? isLoaded,
    bool? showAds,
    int? retryCount,
    String? errorMessage,
  }) {
    return NativeAdState(
      nativeAd: nativeAd ?? this.nativeAd,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      showAds: showAds ?? this.showAds,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage,
    );
  }
}

class NativeAdNotifier extends StateNotifier<NativeAdState> {
  NativeAdNotifier() : super(NativeAdState());

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
  }

  /// Cleanly dispose the current ad
  void disposeAd() {
    state.nativeAd?.dispose();
    state = state.copyWith(
      nativeAd: null,
      isLoaded: false,
      isLoading: false,
    );
  }

  @override
  void dispose() {
    state.nativeAd?.dispose();
    super.dispose();
  }
}
