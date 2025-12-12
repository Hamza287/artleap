import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  bool _isAdLoaded = false;
  int _retryCount = 0;
  bool _disposed = false;

  void _log(String msg) {
    debugPrint('[RewardedAdManager] $msg');
  }

  Future<bool> loadRewardedAd({
    required bool rewardedAdsEnabled,
    required String adUnitId,
    required int maxRetryCount,
    required Future<void> Function() initializeAds,
    required bool isAdsInitialized,
  }) async {
    _log('loadRewardedAd called');
    _log('State → disposed=$_disposed, enabled=$rewardedAdsEnabled, isLoading=$_isLoading, isLoaded=$_isAdLoaded, retry=$_retryCount/$maxRetryCount');
    _log('AdUnitId → $adUnitId');

    if (_disposed) {
      _log('ABORT: manager disposed');
      return false;
    }

    if (!rewardedAdsEnabled) {
      _log('ABORT: rewardedAdsEnabled=false');
      return false;
    }

    if (_rewardedAd != null) {
      _log('ABORT: rewardedAd already exists');
      return false;
    }

    if (_isLoading) {
      _log('ABORT: already loading');
      return false;
    }

    if (_isAdLoaded) {
      _log('ABORT: ad already loaded');
      return false;
    }

    if (_retryCount >= maxRetryCount) {
      _log('ABORT: maxRetryCount reached → resetting retryCount');
      _retryCount = 0;
      return false;
    }

    if (!isAdsInitialized) {
      _log('AdService not initialized → initializing');
      try {
        await initializeAds();
        _log('AdService initialized successfully');
      } catch (e) {
        _log('ERROR: AdService initialization failed → $e');
        return false;
      }
    }

    _isLoading = true;
    _isAdLoaded = false;

    _log('Calling RewardedAd.load()');

    try {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _log('onAdLoaded callback fired');

            if (_disposed) {
              _log('Ad loaded AFTER dispose → disposing ad');
              ad.dispose();
              return;
            }

            _rewardedAd = ad;
            _isLoading = false;
            _isAdLoaded = true;
            _retryCount = 0;

            _log('Ad loaded successfully!');
            _log('ResponseInfo → ${ad.responseInfo}');
          },
          onAdFailedToLoad: (error) {
            if (_disposed) return;

            _log('onAdFailedToLoad → code=${error.code}, message=${error.message}');
            _rewardedAd = null;
            _isLoading = false;
            _isAdLoaded = false;
            _retryCount++;
          },
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      _log('Load result → isLoaded=$_isAdLoaded');
      return !_disposed && _isAdLoaded;
    } catch (e) {
      if (_disposed) return false;
      _log('EXCEPTION during load → $e');
      _isLoading = false;
      _isAdLoaded = false;
      _retryCount++;
      return false;
    }
  }

  Future<bool> showRewardedAd({
    required void Function(int coins) onUserEarnedReward,
    void Function()? onAdDismissed,
    void Function(String error)? onAdFailedToShow,
  }) async {
    _log('showRewardedAd called');
    _log('State → disposed=$_disposed, hasAd=${_rewardedAd != null}, isLoaded=$_isAdLoaded');

    if (_disposed || _rewardedAd == null || !_isAdLoaded) {
      _log('ABORT: ad not ready');
      return false;
    }

    try {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdFailedToShowFullScreenContent: (_, error) {
          if (_disposed) return;
          _log('onAdFailedToShow → ${error.message}');
          _cleanupAd();
          onAdFailedToShow?.call(error.message);
        },
        onAdDismissedFullScreenContent: (_) {
          if (_disposed) return;
          _log('onAdDismissed');
          _cleanupAd();
          onAdDismissed?.call();
        },
      );

      _rewardedAd!.setImmersiveMode(true);

      _log('Calling show()');
      _rewardedAd!.show(
        onUserEarnedReward: (_, reward) {
          if (_disposed) return;
          _log('User earned reward → ${reward.amount} ${reward.type}');
          onUserEarnedReward(reward.amount.toInt());
        },
      );

      return true;
    } catch (e) {
      if (_disposed) return false;
      _log('EXCEPTION during show → $e');
      _cleanupAd();
      return false;
    }
  }

  void _cleanupAd() {
    _log('cleanupAd called');
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isAdLoaded = false;
  }

  void dispose() {
    _log('dispose called');
    _disposed = true;
    _cleanupAd();
    _isLoading = false;
    _retryCount = 0;
  }
}
