import 'package:Artleap.ai/shared/route_export.dart';

class BannerAdManager {
  BannerAd? _bannerAd;
  bool _isLoading = false;
  bool _isDisposed = false;

  Future<void> loadBannerAd({
    required WidgetRef ref,
    required AdSize adSize,
    required void Function(AdError) onAdFailedToLoad,
  }) async {
    if (_isDisposed) return;

    if (!AdService.instance.isInitialized) {
      await AdService.instance.initialize();
    }

    final showBannerAds = ref.read(bannerAdsEnabledProvider);
    if (!showBannerAds) {
      return;
    }

    if (_bannerAd != null || _isLoading) return;

    _isLoading = true;

    final adUnitId = ref.read(remoteConfigProvider).bannerAdUnit;

    _bannerAd = BannerAd(
      size: adSize,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isLoading = false;
        },
        onAdFailedToLoad: (Ad ad, AdError error) {
          _isLoading = false;
          _bannerAd = null;
          onAdFailedToLoad(error);
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
      request: const AdRequest(),
    );

    await _bannerAd!.load();
  }

  Widget getBannerWidget(WidgetRef ref) {
    final showBannerAds = ref.read(bannerAdsEnabledProvider);

    if (_bannerAd == null || !showBannerAds) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  void dispose() {
    _isDisposed = true;
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoading = false;
  }
}