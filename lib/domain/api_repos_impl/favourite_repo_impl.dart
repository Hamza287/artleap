import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photoroomapp/domain/api_repos_abstract/favourite_repo.dart';
import 'package:http/http.dart' as http;
import '../../shared/constants/user_data.dart';

class FavouriteRepoImpl extends FavouritRepo {
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserFavourites(
      String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection('userFavourites').doc(userId).get();
      return documentSnapshot;
    } catch (e) {
      print('Error fetching images: $e');
      return null; // Handle this in the calling function
    }
  }

  @override
  Future<bool> removeImageFromFavourite(String creatorName, String imageUrl,
      String? uid, String prompt, String modelName) async {
    try {
      await firestore
          .collection('userFavourites')
          .doc(UserData.ins.userId)
          .set({
        'favourites': FieldValue.arrayRemove([
          {
            "creator_name": creatorName,
            "imageUrl": imageUrl,
            'userid': uid,
            'prompt': prompt,
            'model_name': modelName
          }
        ])
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error saving image URL to Firestore: $e');
      return false;
    }
  }

  @override
  Future<bool> addImageToFavourite(
      String creatorName,
      String imageUrl,
      String? uid,
      String prompt,
      String modelName,
      bool isRecentGeneratedImage) async {
    String? uploadedImage;
    print(isRecentGeneratedImage);
    try {
      if (isRecentGeneratedImage == true) {
        uploadedImage = await uploadGeneratedImageToFirebase(imageUrl);
      }
      await firestore
          .collection('userFavourites')
          .doc(UserData.ins.userId)
          .set({
        'favourites': FieldValue.arrayUnion([
          {
            "creator_name": creatorName,
            "imageUrl":
                isRecentGeneratedImage == true ? uploadedImage : imageUrl,
            'userid': uid,
            'prompt': prompt,
            'model_name': modelName
          }
        ])
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error saving image URL to Firestore: $e');
      return false;
    }
  }

  @override
  Future<String?> uploadGeneratedImageToFirebase(String imageUrl) async {
    try {
      print("Starting image upload to Firebase Storage...");
      // Download the image data from the URL
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List imageBytes = response.bodyBytes;
        // Determine the file extension
        String fileExtension = imageUrl.split('.').last.split('?').first;
        if (fileExtension != 'png' &&
            fileExtension != 'jpg' &&
            fileExtension != 'jpeg') {
          fileExtension = 'png'; // Default to png if extension is unknown
        }
        // Create a reference to Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = storage.ref().child('images/$fileName.$fileExtension');
        // Upload the image data
        UploadTask uploadTask = ref.putData(
          imageBytes,
          SettableMetadata(contentType: 'image/$fileExtension'),
        );
        // Wait for the upload to complete
        await uploadTask;
        // Get the download URL
        String downloadURL = await ref.getDownloadURL();
        print("Image uploaded successfully. Download URL: $downloadURL");
        return downloadURL;
      } else {
        print('Failed to download image from URL: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Failed to upload image: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  Future<String?> uploadRecenetImageOfUint8list(Uint8List imageBytes) async {
    try {
      print("Starting image upload to Firebase Storage...");

      // Determine MIME type and file extension
      String mimeType = 'image/png'; // Adjust if needed
      String fileExtension = 'png'; // Adjust if needed

      // Create a reference to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('images/$fileName.$fileExtension');

      // Upload the image data
      UploadTask uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: mimeType),
      );

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      String downloadURL = await ref.getDownloadURL();
      print("Image uploaded successfully. Download URL: $downloadURL");
      return downloadURL;
    } catch (e, stackTrace) {
      print('Failed to upload image: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
