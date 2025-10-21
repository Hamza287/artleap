import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPermissionHelper {
  static Future<int> _androidSdkInt() async {
    if (!Platform.isAndroid) return -1;
    final info = await DeviceInfoPlugin().androidInfo;
    return info.version.sdkInt;
  }

  static Future<bool> requestPhotoPermission() async {
    if (Platform.isAndroid) {
      final sdk = await _androidSdkInt();
      if (sdk >= 33) {
        final status = await Permission.photos.status;
        if (status.isGranted) return true;
        final result = await Permission.photos.request();
        return result.isGranted;
      } else {
        final status = await Permission.storage.status;
        if (status.isGranted) return true;
        final result = await Permission.storage.request();
        return result.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;

      if (status.isGranted || status.isLimited) return true;

      final result = await Permission.photos.request();

      if (result.isGranted || result.isLimited) return true;

      if (result.isPermanentlyDenied) {
        await openAppSettings();
      }

      return false;
    } else {
      return true;
    }
  }

  static Future<bool> hasPhotoPermission() async {
    try {
      if (Platform.isAndroid) {
        final sdk = await _androidSdkInt();
        if (sdk >= 33) {
          final status = await Permission.photos.status;
          return status.isGranted;
        } else {
          final status = await Permission.storage.status;
          return status.isGranted;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.status;
        return status.isGranted || status.isLimited;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}