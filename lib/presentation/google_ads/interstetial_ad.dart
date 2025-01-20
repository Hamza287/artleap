import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  // Singleton: one instance throughout the app
  static final InterstitialAdManager _instance =
      InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal(); // Private constructor
  static InterstitialAdManager get instance => _instance;
  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-9762893813732933/9510811519', // Replace with your Interstitial Ad Unit ID
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
  }
}
