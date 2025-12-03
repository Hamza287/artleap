import 'package:Artleap.ai/shared/route_export.dart';

class NativeAdManager {
  NativeAd? _nativeAd;
  bool _isLoading = false;
  int _retryCount = 0;

  Future<void> loadNativeAd({
    required NativeAdController controller,
  }) async {
    if (!AdService.instance.isInitialized) {
      await AdService.instance.initialize();
    }

    if (!RemoteConfigService.instance.showNativeAds) {
      return;
    }

    if (_nativeAd != null || _isLoading) return;

    if (_retryCount >= RemoteConfigService.instance.maxAdRetryCount) {
      _retryCount = 0;
      return;
    }

    _isLoading = true;

    final adUnitId = RemoteConfigService.instance.nativeAdUnit;

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          controller.adLoaded = true;
          _isLoading = false;
          _retryCount = 0;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _isLoading = false;
          _nativeAd = null;
          _retryCount++;
        },
        onAdClicked: (Ad ad) {},
        onAdImpression: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdOpened: (Ad ad) {},
        onAdWillDismissScreen: (Ad ad) {},
      ),
    );

    await _nativeAd!.load();
  }

  Widget getNativeAdWidget(NativeAdController controller) {
    if (_nativeAd == null || !controller.adLoaded || !RemoteConfigService.instance.showNativeAds) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 330,
      child: AdWidget(ad: _nativeAd!),
    );
  }

  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _isLoading = false;
  }
}

class NativeAdController {
  bool adLoaded = false;

  void reset() {
    adLoaded = false;
  }
}