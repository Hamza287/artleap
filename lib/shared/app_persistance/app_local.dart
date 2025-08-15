import 'package:hive_flutter/adapters.dart';

class AppLocal {
  static final AppLocal ins = AppLocal._internal();
  AppLocal._internal();

  Future initStorage() async {
    await Hive.initFlutter();
    final boxNames = [_appBoxName, _userBoxName, _dataBoxName];
    for (var box in boxNames) {
      await Hive.openBox(box);
    }
  }

  // Box names
  final String _appBoxName = "APP_BOX";
  final String _userBoxName = "USER_BOX";
  final String _dataBoxName = "DATA_BOX";

  //Getter for Boxes
  Box get appBox => Hive.box(_appBoxName);
  Box get userBox => Hive.box(_userBoxName);
  Box get dataBox => Hive.box(_dataBoxName);

  //methods for userdata
  setUserData(String key, var value) => userBox.put(key, value);
  getUSerData(String key) => userBox.get(key);
  clearUSerData(String key) => userBox.delete(key);

  Future<void> clearUserData() async {
    await setUserData(Hivekey.userId, null);
    await setUserData(Hivekey.userName, null);
    await setUserData(Hivekey.userEmail, null);
    await setUserData(Hivekey.userProfielPic, null);
  }
}

class Hivekey {
  static const userId = "USER_ID";
  static const userName = 'USER_NAME';
  static const userProfielPic = 'USER_PROFILE_IMAGE';
  static const userEmail = 'USER_EMAIL';
}
