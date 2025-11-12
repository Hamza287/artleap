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
          minimumFetchInterval: const Duration(seconds: 0),
        ),
      );

      final defaults = {
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
      _initialized = true;
    } catch (e) {

    }
  }

  Future<void> fetchAndActivate() async {
    if (!_initialized) {
      await initialize();
    }

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {

    }
  }

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