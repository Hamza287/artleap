import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';
import 'package:photoroomapp/shared/app_snack_bar.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../shared/constants/user_data.dart';

final favouriteProvider =
    ChangeNotifierProvider<FavouriteProvider>((ref) => FavouriteProvider());

class FavouriteProvider extends ChangeNotifier with BaseRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var uuid = const Uuid().v1();
  List<Map<String, dynamic>> _userFavourites = [];
  List<Map<String, dynamic>> get usersFavourites => _userFavourites;
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  setDownloadingLoader(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  Future<bool> addImageToFavourite(String creatorName, String prompt,
      String modelName, bool isRecentGeneratedImage,
      {String? imageUrl, Uint8List? imagesBytes}) async {
    String uploadedImage = "";

    if (isRecentGeneratedImage == true) {
      uploadedImage =
          (await favouriteRepo.uploadRecenetImageOfUint8list(imagesBytes!))!;
    }
    var imageAdded = await favouriteRepo.addImageToFavourite(
        creatorName,
        isRecentGeneratedImage == true ? uploadedImage : imageUrl!,
        prompt,
        modelName,
        isRecentGeneratedImage);
    return imageAdded;
  }

  Future<bool> removeImageFromFavourite(
    String creatorName,
    String imageUrl,
    String prompt,
    String modelName,
  ) async {
    var removeImage = await favouriteRepo.removeImageFromFavourite(
        creatorName, imageUrl, prompt, modelName);
    if (removeImage == true) {
      fetchUserFavourites();
    }
    return removeImage;
  }

  // Future<bool> removeImageFromFavourite(String creatorName, String imageUrl,
  //     String prompt, String modelName) async {
  //   try {
  //     await firestore
  //         .collection('userFavourites')
  //         .doc(UserData.ins.userId)
  //         .set({
  //       'favourites': FieldValue.arrayRemove([
  //         {
  //           "creator_name": creatorName,
  //           "imageUrl": imageUrl,
  //           'userid': UserData.ins.userId,
  //           'prompt': prompt,
  //           'model_name': modelName
  //         }
  //       ])
  //     }, SetOptions(merge: true));
  //     fetchUserFavourites();
  //     return true;
  //   } catch (e) {
  //     print('Error saving image URL to Firestore: $e');
  //     return false;
  //   }
  // }

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserFavourites() async {
    var data = await favouriteRepo.fetchUserFavourites(UserData.ins.userId!);
    Map<String, dynamic> docData = data!.data() ?? {};

    // Ensure 'favourites' is a list and assign it to _userFavourites
    _userFavourites = List<Map<String, dynamic>>.from(
      docData['favourites'] ?? [],
    );
    notifyListeners(); // Notify listeners to update UI
    return data;
  }

  // getUserFavourites() async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
  //         .collection('userFavourites')
  //         .doc(UserData.ins.userId)
  //         .get();
  //     List<Map<String, dynamic>> userfav =
  //         List<Map<String, dynamic>>.from(snapshot.data()?['favourites'] ?? []);
  //     print(userfav);
  //     print("dddddddddddddddddaaaaaaaaassssss");
  //     _userFavourites = userfav;
  //   } catch (e) {
  //     print('Error retrieving data from Firestore: $e');
  //   }
  //   notifyListeners();
  // }

  Future<void> downloadImage(String imageUrl) async {
    setDownloadingLoader(true);
    print(_isDownloading);
    String? uploadedImage;
    try {
      if (isBase64UrlValid(imageUrl)) {
        Uint8List uint8Object = base64Decode(imageUrl);
        uploadedImage =
            (await favouriteRepo.uploadRecenetImageOfUint8list(uint8Object))!;
      }
      // Create a temporary directory
      var tempDir = await getTemporaryDirectory();
      String savePath = '${tempDir.path}/temp_image.jpg';

      // Download the image to the savePath
      await Dio().download(uploadedImage ?? imageUrl, savePath);

      // Save the file to the gallery
      final result = await ImageGallerySaver.saveFile(savePath);
      print('Image saved to gallery: $result');
      appSnackBar("Success", "Image saved to gallery", AppColors.blue);
      setDownloadingLoader(false);

      // Optionally delete the temp file
      // File(savePath).deleteSync();
    } catch (e) {
      setDownloadingLoader(false);

      print('Error downloading and saving image: $e');
    }
    notifyListeners();
  }

  bool isBase64UrlValid(String str) {
    try {
      base64Url.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }
  // Future<String?> uploadGeneratedImageToFirebase(String imageUrl) async {
  //   try {
  //     print("Starting image upload to Firebase Storage...");
  //     // Download the image data from the URL
  //     final http.Response response = await http.get(Uri.parse(imageUrl));
  //     if (response.statusCode == 200) {
  //       Uint8List imageBytes = response.bodyBytes;
  //       // Determine the file extension
  //       String fileExtension = imageUrl.split('.').last.split('?').first;
  //       if (fileExtension != 'png' &&
  //           fileExtension != 'jpg' &&
  //           fileExtension != 'jpeg') {
  //         fileExtension = 'png'; // Default to png if extension is unknown
  //       }
  //       // Create a reference to Firebase Storage
  //       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //       Reference ref = _storage.ref().child('images/$fileName.$fileExtension');
  //       // Upload the image data
  //       UploadTask uploadTask = ref.putData(
  //         imageBytes,
  //         SettableMetadata(contentType: 'image/$fileExtension'),
  //       );
  //       // Wait for the upload to complete
  //       await uploadTask;
  //       // Get the download URL
  //       String downloadURL = await ref.getDownloadURL();
  //       print("Image uploaded successfully. Download URL: $downloadURL");
  //       return downloadURL;
  //     } else {
  //       print('Failed to download image from URL: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e, stackTrace) {
  //     print('Failed to upload image: $e');
  //     print('Stack trace: $stackTrace');
  //     return null;
  //   }
  // }
}
