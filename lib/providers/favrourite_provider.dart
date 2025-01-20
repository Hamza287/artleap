import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';
import 'package:photoroomapp/shared/app_snack_bar.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../shared/constants/user_data.dart';

final favouriteProvider =
    ChangeNotifierProvider<FavouriteProvider>((ref) => FavouriteProvider());

class FavouriteProvider extends ChangeNotifier with BaseRepo {
  List<Map<String, dynamic>> _userFavourites = [];
  List<Map<String, dynamic>> get usersFavourites => _userFavourites;
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  setDownloadingLoader(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  Future<bool> addImageToFavourite(String creatorName, String prompt,
      String modelName, bool isRecentGeneratedImage, String? uid,
      {String? imageUrl, Uint8List? imagesBytes}) async {
    String uploadedImage = "";

    if (isRecentGeneratedImage == true) {
      uploadedImage =
          (await favouriteRepo.uploadRecenetImageOfUint8list(imagesBytes!))!;
    }
    var imageAdded = await favouriteRepo.addImageToFavourite(
        creatorName,
        isRecentGeneratedImage == true ? uploadedImage : imageUrl!,
        uid,
        prompt,
        modelName,
        isRecentGeneratedImage);
    return imageAdded;
  }

  Future<bool> removeImageFromFavourite(
    String creatorName,
    String imageUrl,
    String uid,
    String prompt,
    String modelName,
  ) async {
    var removeImage = await favouriteRepo.removeImageFromFavourite(
        creatorName, imageUrl, uid, prompt, modelName);
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

    if (data != null && data.data() != null) {
      // Extract 'favourites' from the data
      List<Map<String, dynamic>> favourites =
          extractFavouritesFromData(data.data()!);

      // Preload images associated with favourites
      // await preloadFavouritesImages(favourites);

      // Assign to _userFavourites
      _userFavourites = favourites;
      print(_userFavourites);

      // notifyListeners(); // Notify listeners to update UI
    }
    notifyListeners();
    return data;
  }

  List<Map<String, dynamic>> extractFavouritesFromData(
      Map<String, dynamic> data) {
    List<Map<String, dynamic>> images = [];

    // Assuming 'favourites' is a list of maps each containing 'imageUrl'
    if (data.containsKey('favourites') && data['favourites'] is List) {
      List<dynamic> favourites = data['favourites'];
      for (var fav in favourites) {
        if (fav.containsKey('imageUrl')) {
          images.add({'imageUrl': fav['imageUrl'].toString()});
        }
      }
    }

    return images;
  }

// // Helper function to preload images
//   Future<void> preloadFavouritesImages(
//       List<Map<String, dynamic>> favourites) async {
//     List<Future<void>> preloadFutures = favourites.map((image) {
//       final Completer<void> completer = Completer<void>();
//       final ImageStream stream = CachedNetworkImageProvider(image['imageUrl'])
//           .resolve(const ImageConfiguration());
//       final listener = ImageStreamListener((_, __) {
//         if (!completer.isCompleted) {
//           completer.complete();
//         }
//       }, onError: (dynamic exception, StackTrace? stackTrace) {
//         if (!completer.isCompleted) {
//           completer.completeError(exception);
//         }
//       });
//       stream.addListener(listener);
//       return completer.future;
//     }).toList();

//     await Future.wait(preloadFutures);

//     notifyListeners();
//   }

  Future<void> downloadImage(String imageUrl,
      {Uint8List? uint8ListObject}) async {
    setDownloadingLoader(true);
    print(_isDownloading);
    String? uploadedImage;
    try {
      if (uint8ListObject != null) {
        uploadedImage =
            await favouriteRepo.uploadRecenetImageOfUint8list(uint8ListObject);
      }

      // Create a temporary directory
      var tempDir = await getTemporaryDirectory();
      String savePath = '${tempDir.path}/temp_image.jpg';

      // Download the image to the savePath
      await Dio().download(uploadedImage ?? imageUrl, savePath);

      // **Read the image file as bytes**
      Uint8List uint8List = await File(savePath).readAsBytes();

      // Save the file to the gallery
      final result = await SaverGallery.saveImage(
        uint8List,
        quality: 60,
        fileName: "artleap.jpg", // Use correct file extension
        androidRelativePath: "DCIM/artleapImages",
        skipIfExists: false,
        extension: "jpg", // Specify the extension
      );
      print('Image saved to gallery: $result');
      appSnackBar("Success", "Image saved to gallery", AppColors.blue);
      setDownloadingLoader(false);
      // Optionally delete the temp file
      // await File(savePath).delete();
    } catch (e) {
      setDownloadingLoader(false);
      print('Error downloading and saving image: $e');
      appSnackBar("Error", "Error downloading image: $e", AppColors.redColor);
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
