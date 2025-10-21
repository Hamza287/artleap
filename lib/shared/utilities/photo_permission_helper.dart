import 'package:permission_handler/permission_handler.dart';

class PhotoPermissionHelper {
  static Future<bool> requestPhotoPermission() async {
    try {
      final status = await Permission.photos.status;

      if (status.isGranted || status.isLimited) return true;

      final result = await Permission.photos.request();
      return result.isGranted || result.isLimited;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasPhotoPermission() async {
    try {
      final status = await Permission.photos.status;
      return status.isGranted || status.isLimited;
    } catch (e) {
      return false;
    }
  }
}