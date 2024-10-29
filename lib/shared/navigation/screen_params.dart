import 'dart:typed_data';

class DummyScreenArgs {
  final String? firstName;
  final String? lastName;
  DummyScreenArgs({this.firstName, this.lastName});
}

class SeePictureParams {
  final String? userId;
  final String? profileName;
  final String? image;
  final String? prompt;
  final String? modelName;
  final Uint8List? uint8ListImage;
  bool isHomeScreenNavigation = false;
  bool isRecentGeneration = false;

  SeePictureParams(
      {this.userId,
      this.profileName,
      this.image,
      this.prompt,
      this.modelName,
      this.uint8ListImage,
      required this.isHomeScreenNavigation,
      required this.isRecentGeneration});
}

class OtherUserProfileParams {
  final String? userId;
  final String? profileName;
  final String? profileimage;

  OtherUserProfileParams({
    this.userId,
    this.profileName,
    this.profileimage,
  });
}

class EditProfileSreenParams {
  final String? profileImage;
  final String? userName;
  final String? userEmail;
  EditProfileSreenParams({this.profileImage, this.userEmail, this.userName});
}

class FullImageScreenParams {
  final String? Image;
  final Uint8List? uint8list;
  FullImageScreenParams({this.Image, this.uint8list});
}
