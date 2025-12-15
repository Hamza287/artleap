import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  bool _isAdLoaded = false;
  int _retryCount = 0;
  bool _disposed = false;
  Completer<bool>? _currentLoadCompleter;
  bool _isAdShowing = false;

  // Store callbacks locally
  void Function(int coins)? _onUserEarnedReward;
  void Function()? _onAdDismissed;
  void Function(String error)? _onAdFailedToShow;

  Future<bool> loadRewardedAd({
    required bool rewardedAdsEnabled,
    required String adUnitId,
    required int maxRetryCount,
    required Future<void> Function() initializeAds,
    required bool isAdsInitialized,
  }) async {
    if (_disposed) {
      return false;
    }

    if (!rewardedAdsEnabled) {
      return false;
    }

    if (_currentLoadCompleter != null) {
      return _currentLoadCompleter!.future;
    }

    if (_isAdLoaded && _rewardedAd != null) {
      return true;
    }

    if (_retryCount >= maxRetryCount) {
      _retryCount = 0;
      return false;
    }

    _currentLoadCompleter = Completer<bool>();
    _isLoading = true;

    try {
      if (!isAdsInitialized) {
        try {
          await initializeAds();
        } catch (e) {
          _currentLoadCompleter?.complete(false);
          _currentLoadCompleter = null;
          _isLoading = false;
          return false;
        }
      }

      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(
          keywords: ['art', 'ai', 'creative'],
          nonPersonalizedAds: true,
        ),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            if (_disposed) {
              ad.dispose();
              _currentLoadCompleter?.complete(false);
              _currentLoadCompleter = null;
              return;
            }

            _rewardedAd = ad;
            _isLoading = false;
            _isAdLoaded = true;
            _retryCount = 0;

            // Set basic callbacks for tracking
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                _isAdShowing = true;
              },
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                _isAdShowing = false;
                _cleanupAd();
                _onAdDismissed?.call();
              },
              onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                _isAdShowing = false;
                _cleanupAd();
                _onAdFailedToShow?.call(error.message);
              },
            );

            _currentLoadCompleter?.complete(true);
            _currentLoadCompleter = null;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _cleanupAd();
            _isLoading = false;
            _retryCount++;

            _currentLoadCompleter?.complete(false);
            _currentLoadCompleter = null;
          },
        ),
      );

      return await _currentLoadCompleter!.future;
    } catch (e) {
      _cleanupAd();
      _isLoading = false;
      _retryCount++;
      _currentLoadCompleter?.complete(false);
      _currentLoadCompleter = null;
      return false;
    }
  }

  Future<bool> showRewardedAd({
    required void Function(int coins) onUserEarnedReward,
    void Function()? onAdDismissed,
    void Function(String error)? onAdFailedToShow,
  }) async {
    if (_disposed) {
      return false;
    }

    if (_rewardedAd == null || !_isAdLoaded) {
      return false;
    }

    if (_isAdShowing) {
      return false;
    }

    // Store callbacks
    _onUserEarnedReward = onUserEarnedReward;
    _onAdDismissed = onAdDismissed;
    _onAdFailedToShow = onAdFailedToShow;

    try {
      // Reset the fullScreenContentCallback to ensure fresh callbacks
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isAdShowing = true;
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          _isAdShowing = false;
          _cleanupAd();
          _onAdFailedToShow?.call(error.message);
          _clearCallbacks();
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          _isAdShowing = false;
          _cleanupAd();
          _onAdDismissed?.call();
          _clearCallbacks();
        },
        onAdClicked: (ad) {
        },
        onAdImpression: (ad) {
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        _onUserEarnedReward?.call(reward.amount.toInt());
      });

      return true;
    } catch (e) {
      _isAdShowing = false;
      _cleanupAd();
      _clearCallbacks();
      return false;
    }
  }

  void _clearCallbacks() {
    _onUserEarnedReward = null;
    _onAdDismissed = null;
    _onAdFailedToShow = null;
  }

  void _cleanupAd() {
    // Only dispose if ad is not currently showing
    if (!_isAdShowing && _rewardedAd != null) {
      _rewardedAd?.dispose();
      _rewardedAd = null;
      _isAdLoaded = false;
    }
    _isLoading = false;
  }

  bool get isAdLoaded => _isAdLoaded && _rewardedAd != null;

  bool get isLoading => _isLoading;

  bool get isAdShowing => _isAdShowing;

  void dispose() {
    _disposed = true;
    _clearCallbacks();

    // Don't dispose immediately if ad is showing
    if (!_isAdShowing) {
      _cleanupAd();
    }

    _currentLoadCompleter?.complete(false);
    _currentLoadCompleter = null;
    _retryCount = 0;
  }
}