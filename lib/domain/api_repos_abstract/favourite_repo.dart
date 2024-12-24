import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../base_repo/base.dart';

abstract class FavouritRepo extends Base {
  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserFavourites(
      String userId);
  Future<bool> addImageToFavourite(
    String creatorName,
    String imageUrl,
    String? uid,
    String prompt,
    String modelName,
    bool isRecentGeneratedImage,
  );
  Future<bool> removeImageFromFavourite(String creatorName, String imageUrl,
      String? uid, String prompt, String modelName);
  Future<String?> uploadGeneratedImageToFirebase(String imageurl);
  Future<String?> uploadRecenetImageOfUint8list(Uint8List imageurl);
}
