import 'package:Artleap.ai/shared/route_export.dart';


class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  int _retryCount = 0;
  bool _isAdLoaded = false;

  Future<void> loadRewardedAd(WidgetRef ref) async {
    if (!AdService.instance.isInitialized) {
      await AdService.instance.initialize();
    }

    final showRewardedAds = ref.read(rewardedAdsEnabledProvider);
    if (!showRewardedAds) {
      return;
    }

    final maxRetryCount = ref.read(remoteConfigProvider).maxAdRetryCount;

    if (_rewardedAd != null || _isLoading || _isAdLoaded) return;

    if (_retryCount >= maxRetryCount) {
      _retryCount = 0;
      return;
    }

    _isLoading = true;
    _isAdLoaded = false;

    final adUnitId = ref.read(remoteConfigProvider).rewardedAdUnit;

    try {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _isLoading = false;
            _isAdLoaded = true;
            _retryCount = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isLoading = false;
            _isAdLoaded = false;
            _rewardedAd = null;
            _retryCount++;
          },
        ),
      );
    } catch (e) {
      _isLoading = false;
      _isAdLoaded = false;
      _retryCount++;
    }
  }

  Future<bool> showRewardedAd({
    required WidgetRef ref,
    required OnUserEarnedRewardCallback onUserEarnedReward,
    void Function()? onAdDismissed,
    void Function(AdError)? onAdFailedToShow,
    void Function()? onAdShowed,
    void Function()? onAdClicked,
  }) async {
    final showRewardedAds = ref.read(rewardedAdsEnabledProvider);
    if (!showRewardedAds) {
      return false;
    }

    if (_rewardedAd == null || !_isAdLoaded) {
      await loadRewardedAd(ref);
      return false;
    }

    try {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          onAdShowed?.call();
        },
        onAdImpression: (RewardedAd ad) {},
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          _rewardedAd = null;
          _isAdLoaded = false;
          onAdFailedToShow?.call(error);
          loadRewardedAd(ref);
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          _rewardedAd = null;
          _isAdLoaded = false;
          onAdDismissed?.call();
          loadRewardedAd(ref);
        },
        onAdClicked: (RewardedAd ad) {
          onAdClicked?.call();
        },
        onAdWillDismissFullScreenContent: (RewardedAd ad) {},
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
        onUserEarnedReward: onUserEarnedReward,
      );
      return true;
    } catch (e) {
      _rewardedAd = null;
      _isAdLoaded = false;
      await loadRewardedAd(ref);
      return false;
    }
  }

  bool get isAdLoaded => _isAdLoaded;

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoading = false;
    _isAdLoaded = false;
  }
}