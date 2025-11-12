import 'package:Artleap.ai/remote_config/remote_config_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum UpdateStatus { upToDate, recommended, required }

class ForceUpdateState {
  final UpdateStatus status;
  final String currentVersion;
  final String latestVersion;
  final String minSupportedVersion;
  final String message;
  final String url;

  const ForceUpdateState({
    required this.status,
    required this.currentVersion,
    required this.latestVersion,
    required this.minSupportedVersion,
    required this.message,
    required this.url,
  });
}

final forceUpdateProvider = FutureProvider<ForceUpdateState>((ref) async {
  final rc = RemoteConfigService.instance;
  await rc.initialize();
  await rc.fetchAndActivate();

  final info = await PackageInfo.fromPlatform();
  final current = info.version;

  final latest = rc.latestVersion;
  final minSupported = rc.minSupportedVersion;
  final msg = rc.updateMessage;
  final url = rc.updateUrl;

  UpdateStatus status = UpdateStatus.upToDate;

  final isBehindMinSupported = _compareVersions(current, minSupported) < 0;
  final isBehindLatest = _compareVersions(current, latest) < 0;

  if (isBehindMinSupported) {
    status = UpdateStatus.required;
  } else if (isBehindLatest) {
    status = UpdateStatus.recommended;
  }

  final effectiveMessage = isBehindMinSupported ? msg : 'A new version is available!';

  return ForceUpdateState(
    status: status,
    currentVersion: current,
    latestVersion: latest,
    minSupportedVersion: minSupported,
    message: effectiveMessage,
    url: url,
  );
});

int _compareVersions(String versionA, String versionB) {
  try {
    final partsA = versionA.split('.').map((part) => int.parse(part)).toList();
    final partsB = versionB.split('.').map((part) => int.parse(part)).toList();

    for (var i = 0; i < partsA.length || i < partsB.length; i++) {
      final partA = i < partsA.length ? partsA[i] : 0;
      final partB = i < partsB.length ? partsB[i] : 0;

      if (partA < partB) return -1;
      if (partA > partB) return 1;
    }
    return 0;
  } catch (e) {
    return versionA.compareTo(versionB);
  }
}