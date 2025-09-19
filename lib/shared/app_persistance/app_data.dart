// class AppData {
//   static final AppData instance = AppData._internal();
//   AppData._internal();
//
//   String? _token;
//   String? get token => _token;
//
//   void setToken(String token) {
//     _token = token;
//   }
//
//   void clearToken() {
//     _token = null;
//   }
// }

class AppData {
  static final AppData instance = AppData._internal();
  AppData._internal();

  String? _token;
  String? _userId;
  String? _firebaseUid;

  String? get token => _token;
  void setToken(String? token) => _token = token;
  void clearToken() => _token = null;

  String? get userId => _userId;
  void setUserId(String? id) => _userId = id;
  void clearUserId() => _userId = null;

  String? get firebaseUid => _firebaseUid;
  void setFirebaseUid(String? id) => _firebaseUid = id;
  void clearFirebaseUid() => _firebaseUid = null;

  void clearAll() {
    _token = null;
    _userId = null;
    _firebaseUid = null;
  }
}
