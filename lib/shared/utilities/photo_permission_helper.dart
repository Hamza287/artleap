import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPermissionHelper {
  static Future<int> _androidSdkInt() async {
    if (!Platform.isAndroid) return -1;
    final info = await DeviceInfoPlugin().androidInfo;
    return info.version.sdkInt;
  }

  /// Returns:
  ///   true  -> photos available to pick now
  ///   false -> user still denied or restricted
  ///
  /// If it sends user to settings, it will return false immediately; you should
  /// re-check on app resume (see lifecycle section below).
  static Future<bool> ensurePhotosPermission() async {
    if (Platform.isAndroid) {
      final sdk = await _androidSdkInt();
      if (sdk >= 33) {
        // Android 13+ uses READ_MEDIA_IMAGES under the hood
        final status = await Permission.photos.status;
        if (status.isGranted) return true;

        final req = await Permission.photos.request();
        return req.isGranted;
      } else {
        // Android 12 and below use legacy storage permission
        final status = await Permission.storage.status;
        if (status.isGranted) return true;

        final req = await Permission.storage.request();
        return req.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;

      if (status.isGranted) return true;

      if (status.isLimited) {
        // iOS "Limited" = user gave access to selected photos. This is OK.
        // Most pickers (ImagePicker/PhotoKit) will work with the limited set.
        return true;
      }

      final req = await Permission.photos.request();

      if (req.isGranted || req.isLimited) return true;

      if (req.isPermanentlyDenied) {
        // Take user to settings; caller should recheck on resume.
        await openAppSettings();
        return false;
      }

      return false;
    } else {
      // Other platforms (web/desktop) — usually handled by the picker without runtime perms
      return true;
    }
  }
}
