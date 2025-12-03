import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  late FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      final defaults = {
        'ads_enabled': true,
        'show_banner_ads': true,
        'show_interstitial_ads': true,
        'show_rewarded_ads': true,
        'show_native_ads': true,
        'show_app_open_ads': true,
        'interstitial_interval_seconds': 120,
        'max_ad_retry_count': 3,

        'banner_ad_unit': 'ca-app-pub-3940256099942544/6300978111',
        'interstitial_ad_unit': 'ca-app-pub-3940256099942544/1033173712',
        'rewarded_ad_unit': 'ca-app-pub-9762893813732933/8800431270',
        'native_ad_unit': 'ca-app-pub-3940256099942544/2247696110',
        'app_open_ad_unit': 'ca-app-pub-9762893813732933/8062172478',

        'android_latest_version': '1.0.0',
        'android_min_supported_version': '1.0.0',
        'android_update_url': '',
        'ios_latest_version': '1.0.0',
        'ios_min_supported_version': '1.0.0',
        'ios_update_url': '',
        'force_update_required': false,
        'update_message': 'A new version is available!',
      };

      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.fetchAndActivate();
      _initialized = true;
    } catch (e) {
      print('RemoteConfig init error: $e');
    }
  }

  Future<void> fetchAndActivate() async {
    if (!_initialized) await initialize();
    try {
      print('RemoteConfig: Fetching and activating...');
      await _remoteConfig.fetchAndActivate();
      print('RemoteConfig: Fetch successful');
      print('RemoteConfig: ads_enabled = ${_remoteConfig.getBool('ads_enabled')}');
      print('RemoteConfig: show_app_open_ads = ${_remoteConfig.getBool('show_app_open_ads')}');
      print('RemoteConfig: app_open_ad_unit = ${_remoteConfig.getString('app_open_ad_unit')}');
    } catch (e) {
      print('RemoteConfig fetch error: $e');
    }
  }

  bool get adsEnabled => _remoteConfig.getBool('ads_enabled');
  bool get showBannerAds => adsEnabled && _remoteConfig.getBool('show_banner_ads');
  bool get showInterstitialAds => adsEnabled && _remoteConfig.getBool('show_interstitial_ads');
  bool get showRewardedAds => adsEnabled && _remoteConfig.getBool('show_rewarded_ads');
  bool get showNativeAds => adsEnabled && _remoteConfig.getBool('show_native_ads');
  bool get showAppOpenAds => adsEnabled && _remoteConfig.getBool('show_app_open_ads');
  int get interstitialInterval => _remoteConfig.getInt('interstitial_interval_seconds');
  int get maxAdRetryCount => _remoteConfig.getInt('max_ad_retry_count');

  String get bannerAdUnit => _remoteConfig.getString('banner_ad_unit');
  String get interstitialAdUnit => _remoteConfig.getString('interstitial_ad_unit');
  String get rewardedAdUnit => _remoteConfig.getString('rewarded_ad_unit');
  String get nativeAdUnit => _remoteConfig.getString('native_ad_unit');
  String get appOpenAdUnit => _remoteConfig.getString('app_open_ad_unit');

  bool get forceUpdateRequired => _remoteConfig.getBool('force_update_required');
  String get updateMessage => _remoteConfig.getString('update_message');

  String get latestVersion {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _remoteConfig.getString('ios_latest_version');
    } else {
      return _remoteConfig.getString('android_latest_version');
    }
  }

  String get minSupportedVersion {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _remoteConfig.getString('ios_min_supported_version');
    } else {
      return _remoteConfig.getString('android_min_supported_version');
    }
  }

  String get updateUrl {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _remoteConfig.getString('ios_update_url');
    } else {
      return _remoteConfig.getString('android_update_url');
    }
  }
}