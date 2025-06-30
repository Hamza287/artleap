import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_models/generate_high_q_model.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
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

  bool _isGenerateImageLoading = false;
  bool get isGenerateImageLoading => _isGenerateImageLoading;
  bool _isImageReferenceLoading = false;
  bool get isImageReferenceLoading => _isImageReferenceLoading;

  ModelsListModel? _selectedModelName;
  ModelsListModel? get selectedModeldata => _selectedModelName; // Getter
  int? _selectedItem = 1;
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

  String? _aspectRatio = "social_story_9_16";
  String? get aspectRatio => _aspectRatio;

  set aspectRatio(String? value) {
    _aspectRatio = value;
    notifyListeners();
  }

  set selectedStyle(String? value) {
    _selectedStyle = value;
    notifyListeners();
  }

  final Ref reference;

  GenerateImageProvider(this.reference) {
    if (freePikStyles.isNotEmpty) {
      _selectedStyle = freePikStyles[13]['title'];
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
      "prompt": _promptTextController.text,
      "userId": UserData.ins.userId,
      "username": UserData.ins.userName,
      "creatorEmail": UserData.ins.userEmail,
      "presetStyle": _selectedStyle,
      "num_images": _selectedItem,
      "aspectRatio": _aspectRatio,
    };
    ApiResponse generateImageRes = await freePikRepo.generateImage(mapdata);
    if (generateImageRes.status == Status.completed) {
      var generatedData = generateImageRes.data as txtToImg.TextToImageModel;
      _generatedTextToImageData.addAll(generatedData.images);
      reference.read(userProfileProvider).deductUserCredits();
      setGenerateImageLoader(false);
    } else {
      setGenerateImageLoader(false);
    }
    notifyListeners();
  }

  Future<void> pickImage() async {
    String? imagePath = await Pickers.ins.pickImage();

    // 🛑 Exit if no image selected
    if (imagePath == null) return;

    File imageData = File(imagePath);

    // 🔁 Clear previous images and add new one
    images = [imageData];

    // ✅ Set default style to ANIME for image-to-image
    _selectedStyle = textToImageStyles.firstWhere(
      (style) => style['title'] == 'ANIME',
      orElse: () => textToImageStyles[0],
    )['title'];

    notifyListeners();
  }

  Future<void> generateImgToImg() async {
    setGenerateImageLoader(true);
    // print(images);
    Map<String, dynamic> data = {
      "prompt": promptTextController.text,
      "userId": UserData.ins.userId,
      "username": UserData.ins.userName,
      "creatorEmail": UserData.ins.userEmail,
      "presetStyle": selectedStyle,
      "num_images": selectedImageNumber,
    };
    // print(data);
    // print("Sending request to API...");
    ApiResponse generateImageRes =
        await generateImgToImgRepo.generateImgToImg(data, images);
    var generatedData = generateImageRes.data as ImgToImg.ImageToImageModel;
    if (generateImageRes.status == Status.completed) {
      // clearVarData();
      _generatedImage.addAll(generatedData.images);

      setGenerateImageLoader(false);
      selectedStyle = null;

      images = [];
    } else {
      // print(generateImageRes.status);
      images = [];

      setGenerateImageLoader(false);
    }
    notifyListeners();
  }

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
