class UserData {
  static final UserData ins = UserData._internal();
  UserData._internal();
  String?   userId;
  String? userName;
  String? userProfilePic;
  String? userEmail;
  void setUserData(
      {required String id,
      required String name,
      required String userprofilePicture,
      required String email}) {
    userId = id;
    userName = name;
    userProfilePic = userprofilePicture;
    userEmail = email;
  }
}
