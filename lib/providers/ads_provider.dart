import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../domain/base_repo/base_repo.dart';

final adsProvider = ChangeNotifierProvider<AdsProvider>((ref) => AdsProvider());

class AdsProvider extends ChangeNotifier with BaseRepo {
  NativeAd? _nativeAd;
  NativeAd? get nativeAd => _nativeAd;
  InterstitialAd? _interstitialAd;
  InterstitialAd? get interstitialAd => _interstitialAd;
  BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd;
  bool _isBannerAdLoaded = false;
  bool get isBannerAdLoaded => _isBannerAdLoaded;
  bool _isNativeAdLoaded = false;
  bool get isNativeAdLoaded => _isNativeAdLoaded;

  void loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-9762893813732933/9286731994',
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _isNativeAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isNativeAdLoaded = false;
          notifyListeners();
          print('Native ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
    notifyListeners();
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-9762893813732933/9286731994', // Replace with your Interstitial Ad Unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial failed to load: $error');
        },
      ),
    );
    notifyListeners();
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (Ad ad) {
          ad.dispose();
          _interstitialAd = null;
          // Optionally load another ad
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
          print('Failed to show interstitial: $error');
          ad.dispose();
          _interstitialAd = null;
        },
      );
      _interstitialAd!.show();
    } else {
      print('Interstitial is not ready');
    }
    notifyListeners();
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner, // or AdSize.smartBanner
      adUnitId:
          'ca-app-pub-9762893813732933/1120159871', // Your banner ad unit ID
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isBannerAdLoaded = true;
          notifyListeners();
          print(_isBannerAdLoaded);
          print("fffffffffffffffffffffff");
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose of the ad here to free resources
          ad.dispose();
          print('Banner failed to load: $error');
          print("vvvvvvvvvvvvvv");
        },
      ),
      request: const AdRequest(),
    )..load();
    notifyListeners();
  }
}
