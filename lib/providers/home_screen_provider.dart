import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';
import '../shared/app_persistance/app_local.dart';
import '../shared/constants/user_data.dart';
import 'package:permission_handler/permission_handler.dart';

final homeScreenProvider =
    ChangeNotifierProvider<HomeScreenProvider>((ref) => HomeScreenProvider());

class HomeScreenProvider extends ChangeNotifier with BaseRepo {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  final notificationSettings =
      FirebaseMessaging.instance.requestPermission(provisional: true);
  final List<Map<String, dynamic>> _filteredCreations = [];
  List<Map<String, dynamic>> get filteredCreations => _filteredCreations;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isDeletionLoading = false;
  bool get isDeletionLoading => _isDeletionLoading;
  bool _isRequestingPermission = false;
  List<String> _visibleImages = [];
  List<String> get visibleImages => _visibleImages;

  setVisibleImages(List<String> val) {
    _visibleImages = val;
    notifyListeners();
  }

  setDeletionLoading(bool val) {
    _isDeletionLoading = val;
    notifyListeners();
  }

  getDeviceTokekn() async {
    FirebaseMessaging.instance.getInitialMessage();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    print(fcmToken);
    print("llllllllllllllllllllllllll");
    notifyListeners();
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
    var userid = AppLocal.ins.getUSerData(Hivekey.userId);
    var userName = AppLocal.ins.getUSerData(Hivekey.userName) ?? "";
    var userProfilePicture = AppLocal.ins.getUSerData(Hivekey.userProfielPic);
    var userEmail = AppLocal.ins.getUSerData(Hivekey.userEmail);
    print(userProfilePicture);
    print("dddddddddddddddddd");
    UserData.ins.setUserData(
        id: userid,
        name: userName,
        userprofilePicture: userProfilePicture ?? AppAssets.artstyle1,
        email: userEmail);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserCreations() async {
    var data = await homeRepo.getUsersCreations();

    if (data != null && data.data() != null) {
      // Extract image data
      List<Map<String, dynamic>> images = extractImagesFromData(data.data()!);

      // Preload only the first N images (e.g., N = 10)
      int preloadCount = 5;
      List<Map<String, dynamic>> initialBatch =
          images.take(preloadCount).toList();

      // Preload the initial batch of images
      await preloadImages(initialBatch);
    }
    notifyListeners();
    return data;
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

  filteredListFtn(String modelName) async {
    _filteredCreations.clear();
    DocumentSnapshot<Map<String, dynamic>>? data = await getUserCreations();
    if (data != null && data.data() != null) {
      Map<String, dynamic> dataMap = data.data()!;
      // Access the 'userData' key
      List<dynamic>? creationsList = dataMap['userData'];
      if (creationsList != null) {
        List<Map<String, dynamic>> creations = [];
        for (var item in creationsList) {
          if (item is Map<String, dynamic>) {
            creations.add(item);
          } else {
            print('Invalid creation item: $item');
          }
        }

        // Filter the creations based on modelName
        var filtered =
            creations.where((creation) => creation['model_name'] == modelName);

        _filteredCreations.addAll(filtered);
        print(_filteredCreations);
        notifyListeners();
      } else {
        print('userData is null or not a list.');
      }
    } else {
      print('Data is null or data.data() is null.');
    }
  }

  searchByPrompt(String query) async {
    _isLoading = true;
    notifyListeners();

    _filteredCreations.clear();
    DocumentSnapshot<Map<String, dynamic>>? data = await getUserCreations();

    if (data != null && data.data() != null) {
      Map<String, dynamic> dataMap = data.data()!;

      // Access the 'userData' key
      List<dynamic>? creationsList = dataMap['userData'];

      if (creationsList != null) {
        List<Map<String, dynamic>> creations = [];

        for (var item in creationsList) {
          if (item is Map<String, dynamic>) {
            creations.add(item);
          } else {
            print('Invalid creation item: $item');
          }
        }

        // If query is empty, show all creations
        if (query.isEmpty) {
          _filteredCreations.addAll(creations);
        } else {
          // Filter the creations based on 'prompt' (case-insensitive)
          var filtered = creations.where((creation) {
            String prompt = creation['prompt'] ?? '';
            return prompt.toLowerCase().contains(query.toLowerCase());
          });

          _filteredCreations.addAll(filtered);
        }

        _isLoading = false;
        notifyListeners();
      } else {
        print('userData is null or not a list.');
        _isLoading = false;
        notifyListeners();
      }
    } else {
      print('Data is null or data.data() is null.');
      _isLoading = false;
      notifyListeners();
    }
  }

  clearFilteredList() {
    filteredCreations.clear();
    notifyListeners();
  }

  Future<void> deleteImageIfPresent({
    required String userId,
    required String imageUrl, // The image URL to identify which image to delete
  }) async {
    setDeletionLoading(true);

    // Define the data field and image URL key for each collection
    List<Map<String, dynamic>> collections = [
      {
        'collectionName': 'CommunityCreations',
        'documentId': 'usersCreations',
        'dataField': 'userData',
        'imageUrlKey': 'imageUrl',
      },
      {
        'collectionName': 'usersProfileData',
        'documentId': userId,
        'dataField': 'userData',
        'imageUrlKey': 'imageUrl',
      },
      {
        'collectionName': 'userFavourites',
        'documentId': userId,
        'dataField': 'favourites', // Updated field name
        'imageUrlKey': 'imageUrl', // Adjust if the key is different
      },
    ];

    // Run deletion checks concurrently across collections
    List<Future<void>> deleteOperations = collections.map((collection) async {
      final String collectionName = collection['collectionName'];
      final String documentId = collection['documentId'];
      final String dataField = collection['dataField'];
      final String imageUrlKey = collection['imageUrlKey'];

      try {
        DocumentReference<Map<String, dynamic>> documentRef =
            firestore.collection(collectionName).doc(documentId);

        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await documentRef.get();

        if (snapshot.exists && snapshot.data() != null) {
          List<dynamic> userData = List.from(snapshot.data()?[dataField] ?? []);

          // Find the index of the image by checking its 'imageUrl'
          int indexToDelete =
              userData.indexWhere((item) => item[imageUrlKey] == imageUrl);

          if (indexToDelete != -1) {
            // Remove the item if it's found
            userData.removeAt(indexToDelete);
            // Update the document with the modified array
            await documentRef.update({dataField: userData});
            print('Image deleted from $collectionName.');
          } else {
            print('Image not found in $collectionName.');
          }
        } else {
          print('$collectionName document does not exist or has no data.');
        }
      } catch (e, stackTrace) {
        setDeletionLoading(false);
        print('Error in $collectionName: $e');
        print('StackTrace: $stackTrace');
      }
    }).toList();
    await Future.wait(deleteOperations);
    print("Deletion completed where image was found.");
    setDeletionLoading(false);
    Navigation.pop();
  }
}
