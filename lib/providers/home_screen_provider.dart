import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_models/users_creations_model.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';
import '../domain/api_services/api_response.dart';
import '../shared/app_persistance/app_local.dart';
import '../shared/constants/app_static_data.dart';
import '../shared/constants/user_data.dart';
import 'package:permission_handler/permission_handler.dart';

final homeScreenProvider =
    ChangeNotifierProvider<HomeScreenProvider>((ref) => HomeScreenProvider());

class HomeScreenProvider extends ChangeNotifier with BaseRepo {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  final notificationSettings =
      FirebaseMessaging.instance.requestPermission(provisional: true);
  List<Images?> _filteredCreations = [];
  List<Images?> get filteredCreations => _filteredCreations;
  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isDeletionLoading = false;
  bool get isDeletionLoading => _isDeletionLoading;
  bool _isRequestingPermission = false;
  List<String> _visibleImages = [];
  List<String> get visibleImages => _visibleImages;
  UsersCreations? _usersData;
  UsersCreations? get usersData => _usersData;
  final List<Images> _communityImagesList = [];
  List<Images> get communityImagesList => _communityImagesList;
  String? _selectedStyleTitle;
  String? get selectedStyleTitle => _selectedStyleTitle;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  set isLoadingMore(bool val) {
    _isLoadingMore = val;
    notifyListeners();
  }

  int _page = 0;
  int get page => _page;
  set page(int pageNo) {
    _page = pageNo;
    notifyListeners();
  }

  setVisibleImages(List<String> val) {
    _visibleImages = val;
    notifyListeners();
  }

  setDeletionLoading(bool val) {
    _isDeletionLoading = val;
    notifyListeners();
  }

  Future<void> loadMoreImages() async {
    _isLoadingMore = true;

    await getUserCreations(); // your next page function

    _isLoadingMore = false;
  }

  Future<void> requestPermission() async {
    requestPermissionForNotifications();
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;
    try {
      if (await Permission.storage.isGranted) {
        // Permission already granted
        return;
      }
      var result = await Permission.storage.request();
      if (result.isGranted) {
        // Permission granted, proceed with your functionality
      } else if (result.isDenied) {
        // Permission denied, you might want to show a dialog
      } else if (result.isPermanentlyDenied) {
        // Permission permanently denied, navigate to app settings
        openAppSettings();
      }
    } finally {
      _isRequestingPermission = false;
    }
  }

  Future<void> requestPermissionForNotifications() async {
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;
    try {
      if (await Permission.notification.isGranted) {
        // Permission already granted
        return;
      }
      var result = await Permission.notification.request();
      if (result.isGranted) {
        // Permission granted, proceed with your functionality
      } else if (result.isDenied) {
        // Permission denied, you might want to show a dialog
      } else if (result.isPermanentlyDenied) {
        // Permission permanently denied, navigate to app settings
        openAppSettings();
      }
    } catch (e) {
      print(e);
    }
  }

  getUserInfo() {
    var userid = AppLocal.ins.getUSerData(Hivekey.userId) ?? "";
    var userName = AppLocal.ins.getUSerData(Hivekey.userName) ?? "";
    var userProfilePicture =
        AppLocal.ins.getUSerData(Hivekey.userProfielPic) ?? AppAssets.artstyle1;
    var userEmail = AppLocal.ins.getUSerData(Hivekey.userEmail) ?? "";
    print(userProfilePicture);
    UserData.ins.setUserData(
        id: userid,
        name: userName,
        userprofilePicture: userProfilePicture ?? AppAssets.artstyle1,
        email: userEmail);
    notifyListeners();
  }

  getUserCreations() async {
    if (_page == 0) {
      _page = 1;
    } else {
      _page++;
    }
    ApiResponse response = await homeRepo.getUsersCreations(_page);
    print(response);
    print("dddddddddddddddd");
    print(response.message);
    print(response.data);
    _usersData = response.data;
    _communityImagesList.addAll(_usersData!.images);
    _filteredCreations = List.from(_communityImagesList);
    print(_usersData!.message);
    print("jjjjjjjjjjjjjjjjjj");
    notifyListeners();
  }

  List<Map<String, dynamic>> extractImagesFromData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> images = [];

    // Assuming 'userData' is the key for the array of maps where each map contains image details
    if (data.containsKey('userData') && data['userData'] is List) {
      List<dynamic> userData = data['userData'];

      // Iterate over each map in the userData array
      for (var userEntry in userData) {
        if (userEntry is Map<String, dynamic> &&
            userEntry.containsKey('imageUrl') &&
            userEntry['imageUrl'] is String) {
          // Add the imageUrl to the images list if it exists and is a string
          String imageUrl = userEntry['imageUrl'].toString();
          // Optional: Check if imageUrl is not empty
          if (imageUrl.isNotEmpty) {
            images.add({'imageUrl': imageUrl});
          }
        } else {
          // Log or handle the case where imageUrl is not found or is not a string
          print('Invalid or missing imageUrl in entry: $userEntry');
        }
      }
    } else {
      print('userData key not found or is not a list');
    }
    notifyListeners();
    return images;
  }

  Future<void> preloadImages(List<Map<String, dynamic>> images) async {
    List<Future<void>> preloadFutures = images.map((image) {
      // Assuming a smaller version or a cached version is available
      final String imageUrl = image['imageUrl'];
      String thumbnailUrl = imageUrl.replaceAll("fullsize",
          "thumbnail"); // Example: modify the URL for the thumbnail version

      final Completer<void> completer = Completer<void>();
      final ImageStream stream = CachedNetworkImageProvider(thumbnailUrl)
          .resolve(const ImageConfiguration());
      final listener = ImageStreamListener((_, __) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }, onError: (dynamic exception, StackTrace? stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(exception);
        }
      });
      stream.addListener(listener);
      return completer.future;
    }).toList();
    await Future.wait(preloadFutures);
  }

  visibilityInfo(VisibilityInfo info, String images) {
    if (info.visibleFraction > 0) {
      if (!visibleImages.contains(images)) {
        visibleImages.add(images);
      }
    } else {
      visibleImages.remove(images);
    }
    notifyListeners();
  }

  void addVisibleImage(String imageUrl) {
    if (!visibleImages.contains(imageUrl)) {
      _visibleImages = [...visibleImages, imageUrl];
      notifyListeners();
    }
  }

  void filteredListFtn(String modelName) {
    _selectedStyleTitle = modelName;
    final lowerCaseModel = modelName.toLowerCase();

    _filteredCreations = _communityImagesList.where((img) {
      final model = img.modelName.toLowerCase();
      return model == lowerCaseModel ||
          modelNameMatchAliases(model, lowerCaseModel);
    }).toList();

    notifyListeners();
  }

// 🔹 Helper method to match modelName against both Freepik and Leonardo style titles
  bool modelNameMatchAliases(String imageModel, String selectedModel) {
    // Normalize both for safe comparison
    final lowerImageModel = imageModel.toLowerCase();

    final allStyleTitles = [
      ...freePikStyles.map((e) => e["title"]!.toLowerCase()),
      ...textToImageStyles.map((e) => e["title"]!.toLowerCase())
    ];

    return allStyleTitles.contains(lowerImageModel) &&
        lowerImageModel == selectedModel;
  }

  void clearFilteredList() {
    _selectedStyleTitle = null;
    _filteredCreations = List.from(_communityImagesList);
    notifyListeners();
  }
}
