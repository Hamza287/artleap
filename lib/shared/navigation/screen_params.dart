import 'dart:typed_data';

class SeePictureParams {
  String? imageId;
  final String? userId;
  final String? profileName;
  final String? image;
  final String? prompt;
  final String? modelName;
  final String? creatorEmail;
  final String? createdDate;
  final String privacy;
  final Uint8List? uint8ListImage;
  final int? index;

  SeePictureParams(
      {required this.imageId,
      this.userId,
      this.profileName,
      this.creatorEmail,
      this.image,
      this.prompt,
      this.modelName,
      this.createdDate,
      this.uint8ListImage,
      required this.privacy,
      this.index});
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
