class UserData {
  static final UserData ins = UserData._internal();
  UserData._internal();
  String? userId;
  String? userName;
  String? userProfilePic;
  void setUserData(
      {required String id,
      required String name,
      required String userprofilePicture}) {
    userId = id;
    userName = name;
    userProfilePic = userprofilePicture;
  }
}
