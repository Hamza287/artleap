import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_models/users_creations_model.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../domain/api_services/api_response.dart';
import '../shared/app_persistance/app_local.dart';
import '../shared/constants/app_static_data.dart';
import '../shared/constants/user_data.dart';
import 'package:permission_handler/permission_handler.dart';

final homeScreenProvider = ChangeNotifierProvider<HomeScreenProvider>((ref) => HomeScreenProvider());

class HomeScreenProvider extends ChangeNotifier with BaseRepo {
  final notificationSettings = FirebaseMessaging.instance.requestPermission(provisional: true);
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
  String? _searchQuery;
  String? get searchQuery => _searchQuery;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  final List<Images> _searchResults = [];
  List<Images> get searchResults => _searchResults;
  final Random _random = Random();
  List<Images> _randomizedImages = [];
  bool _isInitialRandomizationDone = false;
  String? _previousFilter;

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

  void setSearchQuery(String? query) {
    _searchQuery = query;
    _isSearching = query != null && query.isNotEmpty;

    if (_isSearching) {
      _performSearch(query!);
    } else {
      _searchResults.clear();
    }
    notifyListeners();
  }

  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();
    _searchResults.clear();

    final sourceList = _selectedStyleTitle != null ? _filteredCreations.whereType<Images>().toList() : _randomizedImages;

    _searchResults.addAll(sourceList.where((image) {
      final promptMatch = image.prompt.toLowerCase().contains(lowerQuery);
      final userNameMatch = image.username.toLowerCase().contains(lowerQuery);
      final modelNameMatch = image.modelName.toLowerCase().contains(lowerQuery);

      return promptMatch || userNameMatch || modelNameMatch;
    }));
  }

  void clearSearch() {
    _searchQuery = null;
    _isSearching = false;
    _searchResults.clear();
    notifyListeners();
  }

  List<Images> getDisplayedImages() {
    if (_isSearching) {
      return _searchResults;
    } else if (_selectedStyleTitle != null) {
      return _filteredCreations.whereType<Images>().toList();
    } else {
      return _randomizedImages;
    }
  }

  void _randomizeImagesOnce() {
    if (!_isInitialRandomizationDone && _communityImagesList.isNotEmpty) {
      _randomizedImages = List.from(_communityImagesList);
      _randomizedImages.shuffle(_random);
      _isInitialRandomizationDone = true;
    }
  }

  Future<void> loadMoreImages() async {
    _isLoadingMore = true;
    notifyListeners();

    await getUserCreations();

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> requestPermission() async {
    requestPermissionForNotifications();
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;
    try {
      if (await Permission.storage.isGranted) {
        return;
      }
      var result = await Permission.storage.request();
      if (result.isGranted) {
      } else if (result.isDenied) {
      } else if (result.isPermanentlyDenied) {
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
        return;
      }
      var result = await Permission.notification.request();
      if (result.isGranted) {
      } else if (result.isDenied) {
      } else if (result.isPermanentlyDenied) {
        openAppSettings();
      }
    } catch (e) {
      print(e);
    }
  }

  getUserInfo() {
    var userid = AppLocal.ins.getUSerData(Hivekey.userId) ?? "";
    var userName = AppLocal.ins.getUSerData(Hivekey.userName) ?? "";
    var userProfilePicture = AppLocal.ins.getUSerData(Hivekey.userProfielPic) ?? AppAssets.artstyle1;
    var userEmail = AppLocal.ins.getUSerData(Hivekey.userEmail) ?? "";
    UserData.ins.setUserData(
        id: userid,
        name: userName,
        userprofilePicture: userProfilePicture ?? AppAssets.artstyle1,
        email: userEmail);
    notifyListeners();
  }

  Future<void> getUserCreations() async {
    if (_page == 0) {
      _page = 1;
    } else {
      _page++;
    }

    ApiResponse response = await homeRepo.getUsersCreations(_page);

    if (response.data == null) {
      notifyListeners();
      return;
    }

    _usersData = response.data;

    if (_usersData?.images != null) {
      _communityImagesList.addAll(_usersData!.images);
      _filteredCreations = List.from(_communityImagesList);
      _randomizeImagesOnce();
    }

    notifyListeners();
  }

  List<Map<String, dynamic>> extractImagesFromData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> images = [];
    if (data.containsKey('userData') && data['userData'] is List) {
      List<dynamic> userData = data['userData'];

      for (var userEntry in userData) {
        if (userEntry is Map<String, dynamic> &&
            userEntry.containsKey('imageUrl') &&
            userEntry['imageUrl'] is String) {
          String imageUrl = userEntry['imageUrl'].toString();
          if (imageUrl.isNotEmpty) {
            images.add({'imageUrl': imageUrl});
          }
        } else {
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
      final String imageUrl = image['imageUrl'];
      String thumbnailUrl = imageUrl.replaceAll("fullsize", "thumbnail");

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
    _previousFilter = _selectedStyleTitle;
    _selectedStyleTitle = modelName;
    final lowerCaseModel = modelName.toLowerCase();

    _filteredCreations = _communityImagesList.where((img) {
      final model = img.modelName.toLowerCase();
      return model == lowerCaseModel || modelNameMatchAliases(model, lowerCaseModel);
    }).toList();

    notifyListeners();
  }

  bool modelNameMatchAliases(String imageModel, String selectedModel) {
    final lowerImageModel = imageModel.toLowerCase();

    final allStyleTitles = [
      ...freePikStyles.map((e) => e["title"]!.toLowerCase()),
      ...textToImageStyles.map((e) => e["title"]!.toLowerCase())
    ];

    return allStyleTitles.contains(lowerImageModel) &&
        lowerImageModel == selectedModel;
  }

  void clearFilteredList() {
    _previousFilter = _selectedStyleTitle;
    selectAllStyles();
  }

  void selectAllStyles() {
    _selectedStyleTitle = null;
    _filteredCreations = List.from(_communityImagesList);
    notifyListeners();
  }

  Future<void> refreshUserCreations() async {
    _page = 0;
    _communityImagesList.clear();
    _filteredCreations.clear();
    _searchResults.clear();
    _searchQuery = null;
    _isSearching = false;
    _randomizedImages.clear();
    _isInitialRandomizationDone = false;
    _previousFilter = null;
    notifyListeners();
    await getUserCreations();
  }
}