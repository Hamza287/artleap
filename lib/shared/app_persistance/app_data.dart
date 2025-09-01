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

  // ---- Token ----
  String? get token => _token;
  void setToken(String? token) => _token = token;
  void clearToken() => _token = null;

  // ---- UserId (backend user ID) ----
  String? get userId => _userId;
  void setUserId(String? id) => _userId = id;
  void clearUserId() => _userId = null;

  // ---- Firebase UID (optional, can help with debugging / some APIs) ----
  String? get firebaseUid => _firebaseUid;
  void setFirebaseUid(String? id) => _firebaseUid = id;
  void clearFirebaseUid() => _firebaseUid = null;

  // ---- Convenience ----
  void clearAll() {
    _token = null;
    _userId = null;
    _firebaseUid = null;
  }
}
