import 'package:Artleap.ai/shared/route_export.dart';



class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;
  DateTime? _lastShownTime;
  int _retryCount = 0;

  Future<void> loadInterstitialAd(WidgetRef ref) async {
    if (!AdService.instance.isInitialized) {
      await AdService.instance.initialize();
    }

    final showInterstitialAds = ref.read(interstitialAdsEnabledProvider);
    if (!showInterstitialAds) {
      return;
    }

    final maxRetryCount = ref.read(remoteConfigProvider).maxAdRetryCount;

    if (_interstitialAd != null || _isLoading) return;

    if (_retryCount >= maxRetryCount) {
      _retryCount = 0;
      return;
    }

    _isLoading = true;

    final adUnitId = ref.read(remoteConfigProvider).interstitialAdUnit;

    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isLoading = false;
            _retryCount = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isLoading = false;
            _interstitialAd = null;
            _retryCount++;
          },
        ),
      );
    } catch (e) {
      _isLoading = false;
      _retryCount++;
    }
  }

  Future<bool> showInterstitialAd(WidgetRef ref) async {
    final showInterstitialAds = ref.read(interstitialAdsEnabledProvider);
    if (!showInterstitialAds) {
      return false;
    }

    if (_interstitialAd == null) {
      await loadInterstitialAd(ref);
      return false;
    }

    final now = DateTime.now();
    if (_lastShownTime != null) {
      final secondsSinceLastAd = now.difference(_lastShownTime!).inSeconds;
      final interval = ref.read(interstitialIntervalProvider);
      if (secondsSinceLastAd < interval) {
        return false;
      }
    }

    try {
      await _interstitialAd!.show();
      _lastShownTime = now;
      _interstitialAd = null;
      loadInterstitialAd(ref);
      return true;
    } catch (e) {
      _interstitialAd = null;
      loadInterstitialAd(ref);
      return false;
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoading = false;
  }
}