class AppData {
  static final AppData instance = AppData._internal();
  AppData._internal();

  String? _token;
  String? get token => _token;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }
}