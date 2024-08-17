import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/domain/api_models/generate_image_model.dart';
import 'package:photoroomapp/domain/api_services/api_response.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';
import 'package:photoroomapp/shared/constants/app_constants.dart';

import '../domain/api_models/Image_to_Image_model.dart';
import '../shared/utilities/pickers.dart';

final generateImageProvider = ChangeNotifierProvider<GenerateImageProvider>(
    (ref) => GenerateImageProvider());

class GenerateImageProvider extends ChangeNotifier with BaseRepo {
  final TextEditingController _promptTextController = TextEditingController();
  TextEditingController get promptTextController => _promptTextController;

  GenerateImageModel? generatedData;
  ImageToImageModel? generatedImage;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  generateImage() async {
    Map<String, dynamic> data = {
      "key": AppConstants.stableDefKey,
      "prompt": _promptTextController.text,
      "negative_prompt": "bad quality",
      "width": "1080",
      "height": "1080",
      "safety_checker": false,
      "seed": null,
      "samples": 2,
      "base64": false,
      "webhook": null,
      "track_id": null
    };

    ApiResponse generateImageRes = await generateImageRepo.generateImage(data);
    if (generateImageRes.status == Status.completed) {
      generatedImage == null;
      generatedData = generateImageRes.data as GenerateImageModel;
      print(generatedData!.output);
    } else {
      print(generateImageRes.status);
    }

    notifyListeners();
  }

  Future<void> pickImage() async {
    // Pick an image using your existing picker class
    String? imagePath = await Pickers.ins.pickImage();

    if (imagePath != null && imagePath.isNotEmpty) {
      // Upload the image to Firebase and get the URL
      String? imageUrl = await uploadImageToFirebase(imagePath);
      if (imageUrl != null) {
        generateImgToImg(imageUrl);
      } else {
        print("Failed to upload image to Firebase.");
      }
    } else {
      print("No image selected or path is invalid.");
    }
  }

  Future<String?> uploadImageToFirebase(String filePath) async {
    try {
      String fileExtension = filePath.split('.').last;
      Reference ref = _storage.ref().child(
          "images/${DateTime.now().millisecondsSinceEpoch}.$fileExtension");
      UploadTask uploadTask = ref.putFile(File(filePath));
      await uploadTask;
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> generateImgToImg(String imageUrl) async {
    Map<String, dynamic> data = {
      "key": AppConstants.stableDefKey,
      "prompt": _promptTextController.text,
      "negative_prompt": "bad quality",
      "init_image": imageUrl,
      "width": "1080",
      "height": "1080",
      "samples": "1",
      "temp": false,
      "safety_checker": false,
      "strength": 0.7,
      "seed": null,
      "webhook": null,
      "track_id": null
    };
    print(data);
    print("Sending request to API...");
    ApiResponse generateImageRes =
        await generateImgToImgRepo.generateImgToImg(data);
    if (generateImageRes.status == Status.completed) {
      generatedData == null;
      generatedImage = generateImageRes.data as ImageToImageModel;
      print(generatedImage!.output);
    } else {
      print(generateImageRes.status);
    }
    notifyListeners();
  }
}
