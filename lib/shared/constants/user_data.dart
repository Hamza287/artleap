// class UserData {
//   static final UserData ins = UserData._internal();
//   UserData._internal();
//   String?   userId;
//   String? userName;
//   String? userProfilePic;
//   String? userEmail;
//   void setUserData(
//       {required String id,
//       required String name,
//       required String userprofilePicture,
//       required String email}) {
//     userId = id;
//     userName = name;
//     userProfilePic = userprofilePicture;
//     userEmail = email;
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class UserData {
  static final UserData ins = UserData._internal();
  UserData._internal();

  String? userId;
  String? userName;
  String? userProfilePic;
  String? userEmail;

  void setUserData({
    required String id,
    required String name,
    required String userprofilePicture,
    required String email,
  }) {
    userId = id;
    userName = name;
    userProfilePic = userprofilePicture;
    userEmail = email;
  }

  /// 💾 Save user data locally
  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId ?? '');
    await prefs.setString('userName', userName ?? '');
    await prefs.setString('userProfilePic', userProfilePic ?? '');
    await prefs.setString('userEmail', userEmail ?? '');
    debugPrint('💾 User data saved locally');
  }

  /// 🔄 Load user data if available
  Future<void> loadUserDataIfNeeded() async {
    if (userId != null) return; // Already loaded in memory

    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('userId');
    if (storedId != null && storedId.isNotEmpty) {
      userId = storedId;
      userName = prefs.getString('userName');
      userProfilePic = prefs.getString('userProfilePic');
      userEmail = prefs.getString('userEmail');
      debugPrint('🔄 Loaded saved user data: $userName ($userId)');
    } else {
      debugPrint('⚠️ No saved user data found');
    }
  }

  /// ❌ Clear user data (e.g., on logout)
  Future<void> clearUserData() async {
    userId = null;
    userName = null;
    userProfilePic = null;
    userEmail = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userProfilePic');
    await prefs.remove('userEmail');

    debugPrint('🧹 Cleared user data');
  }
}
