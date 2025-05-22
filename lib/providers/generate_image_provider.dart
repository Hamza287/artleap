import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/domain/api_models/generate_high_q_model.dart';
import 'package:photoroomapp/domain/api_services/api_response.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';
import 'package:photoroomapp/providers/user_profile_provider.dart';
import 'package:uuid/uuid.dart';
import '../domain/api_models/models_list_model.dart';
import '../shared/constants/app_static_data.dart';
import '../shared/constants/user_data.dart';
import '../shared/utilities/pickers.dart';
import '../domain/api_models/text_to_image_model.dart' as txtToImg;
import '../domain/api_models/Image_to_Image_model.dart' as ImgToImg;

final generateImageProvider = ChangeNotifierProvider<GenerateImageProvider>(
    (ref) => GenerateImageProvider(ref));

class GenerateImageProvider extends ChangeNotifier with BaseRepo {
  final TextEditingController _promptTextController = TextEditingController();
  TextEditingController get promptTextController => _promptTextController;
  final List<ImgToImg.Images?> _generatedImage = [];
  List<ImgToImg.Images?> get generatedImage => _generatedImage;
  GenerateHighQualityImageModel? _generatedHighQualityImage;
  GenerateHighQualityImageModel? get generatedHighQualityImage =>
      _generatedHighQualityImage;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isGenerateImageLoading = false;
  bool get isGenerateImageLoading => _isGenerateImageLoading;
  bool _isImageReferenceLoading = false;
  bool get isImageReferenceLoading => _isImageReferenceLoading;

  ModelsListModel? _selectedModelName;
  ModelsListModel? get selectedModeldata => _selectedModelName; // Getter
  int? _selectedItem;
  int? get selectedImageNumber => _selectedItem;
  final List<int> _dropdownItems = [1, 2, 3, 4];
  List<int> get imageNumber => _dropdownItems;

  var uuid = const Uuid().v1();
  final List<txtToImg.Images?> _generatedTextToImageData = [];
  List<txtToImg.Images?> get generatedTextToImageData =>
      _generatedTextToImageData;
  List<Uint8List> listOfImagesBytes = [];
  List<File> images = [];

  String? _selectedStyle;
  String? get selectedStyle => _selectedStyle;

  bool _containsSexualWords = false;
  bool get containsSexualWords => _containsSexualWords;

  set selectedStyle(String? value) {
    _selectedStyle = value;
    notifyListeners();
  }

  final Ref reference;

  GenerateImageProvider(this.reference) {
    if (freePikStyles.isNotEmpty) {
      _selectedStyle = freePikStyles[0]['title'];
    }
  }
  set selectedImageNumber(int? value) {
    _selectedItem = value;
    notifyListeners();
  }

  set selectedModeldata(ModelsListModel? value) {
    _selectedModelName = value;
    notifyListeners();
  }

  setGenerateImageLoader(bool value) {
    _isGenerateImageLoading = value;
    notifyListeners();
  }

  setImageRefLoader(bool value) {
    _isImageReferenceLoading = value;
    notifyListeners();
  }

  clearVarData() {
    _selectedModelName = null;
    _selectedItem = null;
    notifyListeners();
  }

  clearImagesList() {
    images = [];
    notifyListeners();
  }

  String? dataUrl;
  generateTextToImage() async {
    setGenerateImageLoader(true);
    Map<String, dynamic> mapdata = {
      "prompt": promptTextController.text,
      "userId": UserData.ins.userId,
      "username": UserData.ins.userName,
      "creatorEmail": UserData.ins.userEmail,
      "presetStyle": selectedStyle,
      "num_images": selectedImageNumber,
      "aspectRatio": "widescreen_16_9",
      // "width": 1024,
      // "height": 1024
    };
    // var data = jsonEncode(mapdata);
    print(mapdata);
    print("Sending request to API...01010101001010101010101010101010");
    ApiResponse generateImageRes = await freePikRepo.generateImage(mapdata);
    if (generateImageRes.status == Status.completed) {
      var generatedData = generateImageRes.data as txtToImg.TextToImageModel;
      _generatedTextToImageData.addAll(generatedData.images);
      reference.read(userProfileProvider).deductUserCredits();
      setGenerateImageLoader(false);
      print(_generatedTextToImageData);
      print("ddddddddddddddddd");
    } else {
      setGenerateImageLoader(false);
      print(generateImageRes.status);
    }
    notifyListeners();
  }

  Future<void> pickImage() async {
    String? imagePath = await Pickers.ins.pickImage();
    File imageData = File(imagePath!);
    print(imageData);
    print("ddddddddddd");
    if (images.isNotEmpty) {
      images = [];
    }
    images.add(imageData);
    notifyListeners();
  }

  // Future<String?> uploadImageToFirebase(String filePath) async {
  //   try {
  //     String fileExtension = filePath.split('.').last;
  //     Reference ref = _storage.ref().child(
  //         "images/${DateTime.now().millisecondsSinceEpoch}.$fileExtension");
  //     UploadTask uploadTask = ref.putFile(File(filePath));
  //     await uploadTask;
  //     String downloadURL = await ref.getDownloadURL();
  //     return downloadURL;
  //   } catch (e) {
  //     print('Failed to upload image: $e');
  //     return null;
  //   }
  // }

  Future<void> generateImgToImg() async {
    setGenerateImageLoader(true);
    print(images);
    Map<String, dynamic> data = {
      "prompt": promptTextController.text,
      "userId": UserData.ins.userId,
      "username": UserData.ins.userName,
      "creatorEmail": UserData.ins.userEmail,
      "presetStyle": selectedStyle,
      "num_images": selectedImageNumber,
    };
    print(data);
    print("Sending request to API...");
    ApiResponse generateImageRes =
        await generateImgToImgRepo.generateImgToImg(data, images);
    var generatedData = generateImageRes.data as ImgToImg.ImageToImageModel;
    if (generateImageRes.status == Status.completed) {
      // clearVarData();
      _generatedImage.addAll(generatedData.images);

      setGenerateImageLoader(false);
      images = [];
    } else {
      print(generateImageRes.status);
      images = [];

      setGenerateImageLoader(false);
    }
    notifyListeners();
  }

  // uploadImageToCommunityCreations(
  //   String imageUrl,
  //   String prompt,
  //   String modelName,
  // ) async {
  //   try {
  //     await firestore
  //         .collection('CommunityCreations')
  //         .doc("usersCreations")
  //         .set({
  //       'userData': FieldValue.arrayUnion([
  //         {
  //           "id": uuid,
  //           'creator_name': UserData.ins.userName,
  //           'creator_email': UserData.ins.userEmail,
  //           "imageUrl": imageUrl,
  //           'timestamp': DateTime.now(),
  //           'userid': UserData.ins.userId,
  //           'prompt': prompt,
  //           'model_name': modelName
  //         }
  //       ])
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     print('Error saving image URL to Firestore: $e');
  //   }
  // }

  // userCreationsForProfile(
  //     String imageUrl, String prompt, String modelName) async {
  //   try {
  //     await firestore
  //         .collection('usersProfileData')
  //         .doc(UserData.ins.userId)
  //         .set({
  //       'userData': FieldValue.arrayUnion([
  //         {
  //           "creator_name": UserData.ins.userName,
  //           "id": uuid,
  //           "imageUrl": imageUrl,
  //           'timestamp': DateTime.now(),
  //           'userid': UserData.ins.userId,
  //           'prompt': prompt,
  //           'model_name': modelName
  //         }
  //       ])
  //     }, SetOptions(merge: true));
  //     clearVarData();
  //   } catch (e) {
  //     print('Error saving image URL to Firestore: $e');
  //   }
  // }

  // Future<String?> uploadGeneratedImageToFirebase(String base64Image) async {
  //   try {
  //     print("Starting image upload to Firebase Storage...");

  //     // Default MIME type and file extension
  //     String mimeType = 'image/png';
  //     String fileExtension = 'png';

  //     // Remove data URI prefix if present and extract MIME type
  //     if (base64Image.contains(',')) {
  //       final RegExp dataUriRegex = RegExp(r'data:(.*?);base64,(.*)');
  //       final Match? match = dataUriRegex.firstMatch(base64Image);

  //       if (match != null) {
  //         mimeType = match.group(1) ?? 'image/png';
  //         base64Image = match.group(2) ?? '';

  //         // Determine the file extension from MIME type
  //         if (mimeType.contains('/')) {
  //           fileExtension = mimeType.split('/').last;
  //         }
  //       } else {
  //         // Remove any prefix before the comma
  //         base64Image = base64Image.substring(base64Image.indexOf(',') + 1);
  //       }
  //     }

  //     // Decode the Base64 string into bytes
  //     Uint8List imageBytes = base64Decode(base64Image);

  //     // Create a reference to Firebase Storage
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference ref = _storage.ref().child('images/$fileName.$fileExtension');

  //     // Upload the image data
  //     UploadTask uploadTask = ref.putData(
  //       imageBytes,
  //       SettableMetadata(contentType: mimeType),
  //     );

  //     // Wait for the upload to complete
  //     TaskSnapshot snapshot = await uploadTask;

  //     // Get the download URL
  //     String downloadURL = await snapshot.ref.getDownloadURL();
  //     print("Image uploaded successfully. Download URL: $downloadURL");

  //     return downloadURL;
  //   } catch (e, stackTrace) {
  //     print('Failed to upload image: $e');
  //     print('Stack trace: $stackTrace');
  //     return null;
  //   }
  // }

// Helper function to check if a string is a valid URL
  bool isValidUrl(String url) {
    try {
      Uri uri = Uri.parse(url);
      return uri.isAbsolute &&
          (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
    } catch (e) {
      return false;
    }
  }

  void checkSexualWords(String input) {
    final lowerInput = input.toLowerCase();
    bool found = sexualWordsList.any((word) => lowerInput.contains(word));
    _containsSexualWords = found;
    notifyListeners();
  }
}
