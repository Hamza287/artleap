import 'package:Artleap.ai/shared/route_export.dart';

class InterestOnboardingScreenWrapper extends ConsumerStatefulWidget {
  static const String routeName = "interest_onboarding_screen";
  const InterestOnboardingScreenWrapper({super.key});

  @override
  ConsumerState<InterestOnboardingScreenWrapper> createState() =>
      _InterestOnboardingScreenWrapperState();
}

class _InterestOnboardingScreenWrapperState
    extends ConsumerState<InterestOnboardingScreenWrapper> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nativeAdProvider.notifier).loadMultipleAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const InterestOnboardingScreen();
  }
}

final nativeAdProvider =
StateNotifierProvider<NativeAdNotifier, NativeAdState>((ref) {
  return NativeAdNotifier();
});

class NativeAdState {
  final List<NativeAd> nativeAds;
  final bool isLoading;
  final bool isLoaded;
  final bool showAds;
  final int retryCount;
  final String? errorMessage;

  NativeAdState({
    List<NativeAd>? nativeAds,
    this.isLoading = false,
    this.isLoaded = false,
    this.showAds = true,
    this.retryCount = 0,
    this.errorMessage,
  }) : nativeAds = nativeAds ?? [];

  NativeAdState copyWith({
    List<NativeAd>? nativeAds,
    bool? isLoading,
    bool? isLoaded,
    bool? showAds,
    int? retryCount,
    String? errorMessage,
  }) {
    return NativeAdState(
      nativeAds: nativeAds ?? this.nativeAds,
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

  Future<void> loadMultipleAds() async {
    final config = RemoteConfigService.instance;

    if (!config.showNativeAds) {
      state = state.copyWith(showAds: false);
      return;
    }

    if (state.isLoading) return;

    for (var ad in state.nativeAds) {
      ad.dispose();
    }

    state = state.copyWith(
      nativeAds: [],
      isLoading: true,
      isLoaded: false,
      errorMessage: null,
    );

    final List<NativeAd> loadedAds = [];
    int loadedCount = 0;
    int failedCount = 0;
    final int adCount = 5;

    for (int i = 0; i < adCount; i++) {
      final ad = NativeAd(
        adUnitId: config.nativeAdUnit,
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.medium,
          cornerRadius: 12,
        ),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            loadedAds.add(ad as NativeAd);
            loadedCount++;

            if (loadedCount + failedCount >= adCount) {
              state = state.copyWith(
                nativeAds: loadedAds,
                isLoading: false,
                isLoaded: loadedCount > 0,
                retryCount: 0,
                errorMessage: null,
              );
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            failedCount++;

            if (loadedCount + failedCount >= adCount) {
              state = state.copyWith(
                nativeAds: loadedAds,
                isLoading: false,
                isLoaded: loadedCount > 0,
                retryCount: state.retryCount + 1,
                errorMessage: error.message,
              );
            }
          },
        ),
      );

      await ad.load();
    }
  }

  Future<void> loadInitialAd() async {
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
            nativeAds: [ad as NativeAd],
            isLoading: false,
            isLoaded: true,
            retryCount: 0,
            errorMessage: null,
          );
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          state = state.copyWith(
            nativeAds: [],
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

  Future<void> loadNativeAd() async {
    final config = RemoteConfigService.instance;

    if (!config.showNativeAds) {
      state = state.copyWith(showAds: false);
      return;
    }

    if (state.isLoading) return;

    for (var ad in state.nativeAds) {
      ad.dispose();
    }

    state = state.copyWith(
      nativeAds: [],
      isLoading: true,
      isLoaded: false,
      errorMessage: null,
    );

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
            nativeAds: [ad as NativeAd],
            isLoading: false,
            isLoaded: true,
            retryCount: 0,
            errorMessage: null,
          );
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          state = state.copyWith(
            nativeAds: [],
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

  void disposeAd() {
    for (var ad in state.nativeAds) {
      ad.dispose();
    }
    state = state.copyWith(nativeAds: [], isLoaded: false, isLoading: false);
  }

  void safeDisposeAds() {
    for (var ad in state.nativeAds) {
      ad.dispose();
    }
  }

  @override
  void dispose() {
    for (var ad in state.nativeAds) {
      ad.dispose();
    }
    super.dispose();
  }
}
