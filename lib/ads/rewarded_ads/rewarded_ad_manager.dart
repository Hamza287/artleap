import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  int _retryCount = 0;
  bool _isAdLoaded = false;

  Future<bool> loadRewardedAd(WidgetRef ref) async {
    debugPrint('Loading rewarded ad...');

    try {
      final showRewardedAds = ref.read(rewardedAdsEnabledProvider);
      if (!showRewardedAds) {
        debugPrint('Rewarded ads disabled by config');
        return false;
      }

      if (!AdService.instance.isInitialized) {
        debugPrint('Initializing ad service...');
        try {
          await AdService.instance.initialize();
        } catch (e) {
          debugPrint('Failed to initialize ad service: $e');
          return false;
        }
      }

      if (_rewardedAd != null || _isLoading || _isAdLoaded) {
        debugPrint('Ad already loading or loaded');
        return false;
      }

      final maxRetryCount = ref.read(remoteConfigProvider).maxAdRetryCount;
      if (_retryCount >= maxRetryCount) {
        debugPrint('Max retry count reached: $_retryCount');
        _retryCount = 0;
        return false;
      }

      _isLoading = true;
      _isAdLoaded = false;

      final adUnitId = ref.read(remoteConfigProvider).rewardedAdUnit;
      debugPrint('Loading ad with unit ID: $adUnitId');

      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            debugPrint('Rewarded ad loaded successfully');
            _rewardedAd = ad;
            _isLoading = false;
            _isAdLoaded = true;
            _retryCount = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('Failed to load rewarded ad: ${error.message}');
            _isLoading = false;
            _isAdLoaded = false;
            _rewardedAd = null;
            _retryCount++;
          },
        ),
      );

      return _isAdLoaded;
    } catch (e) {
      debugPrint('Error loading rewarded ad: $e');
      _isLoading = false;
      _isAdLoaded = false;
      _retryCount++;
      return false;
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
    debugPrint('Showing rewarded ad...');

    try {
      final showRewardedAds = ref.read(rewardedAdsEnabledProvider);
      if (!showRewardedAds) {
        debugPrint('Rewarded ads disabled, cannot show');
        return false;
      }

      if (_rewardedAd == null || !_isAdLoaded) {
        debugPrint('Ad not loaded, loading now...');
        await loadRewardedAd(ref);
        return false;
      }

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          debugPrint('Rewarded ad showed');
          onAdShowed?.call();
        },
        onAdImpression: (RewardedAd ad) {
          debugPrint('Rewarded ad impression');
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          debugPrint('Failed to show rewarded ad: ${error.message}');
          _cleanupAd();
          onAdFailedToShow?.call(error);
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          debugPrint('Rewarded ad dismissed');
          _cleanupAd();
          onAdDismissed?.call();
        },
        onAdClicked: (RewardedAd ad) {
          debugPrint('Rewarded ad clicked');
          onAdClicked?.call();
        },
        onAdWillDismissFullScreenContent: (RewardedAd ad) {
          debugPrint('Rewarded ad will dismiss');
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      await _rewardedAd!.show(
        onUserEarnedReward: onUserEarnedReward,
      );

      debugPrint('Rewarded ad shown successfully');
      return true;
    } catch (e) {
      debugPrint('Error showing rewarded ad: $e');
      _cleanupAd();
      return false;
    }
  }

  void _cleanupAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isAdLoaded = false;
    debugPrint('Ad cleaned up');
  }

  bool get isAdLoaded => _isAdLoaded;

  void dispose() {
    _cleanupAd();
    _isLoading = false;
    _retryCount = 0;
  }
}