import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';

import '../shared/app_persistance/app_local.dart';
import '../shared/constants/user_data.dart';
import 'package:permission_handler/permission_handler.dart';

final homeScreenProvider =
    ChangeNotifierProvider<HomeScreenProvider>((ref) => HomeScreenProvider());

class HomeScreenProvider extends ChangeNotifier with BaseRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _filteredCreations = [];
  List<Map<String, dynamic>> get filteredCreations => _filteredCreations;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  requestPermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      var result = await Permission.storage.request();
      return result.isGranted;
    }
  }

  getUserInfo() {
    var userid = AppLocal.ins.getUSerData(Hivekey.userId);
    var userName = AppLocal.ins.getUSerData(Hivekey.userName);
    var userProfilePicture = AppLocal.ins.getUSerData(Hivekey.userProfielPic);
    print(userProfilePicture);
    print("dddddddddddddddddd");

    UserData.ins.setUserData(
        id: userid,
        name: userName,
        userprofilePicture: userProfilePicture ?? AppAssets.artstyle1);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserCreations() async {
    var data = await homeRepo.getUsersCreations();
    if (data != null && data.data() != null) {
      // Extract image URLs from the data
      List<Map<String, dynamic>> images = extractImagesFromData(data.data()!);
      // Preload images
      await preloadImages(images);
    }
    return data;
  }

  List<Map<String, dynamic>> extractImagesFromData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> images = [];

    // Assuming your data has an 'imageUrls' field that's a list of URLs
    if (data.containsKey('imageUrls') && data['imageUrls'] is List) {
      List<dynamic> imageUrls = data['imageUrls'];
      for (var url in imageUrls) {
        images.add({'url': url.toString()});
      }
    }

    return images;
  }

  Future<void> preloadImages(List<Map<String, dynamic>> images) async {
    List<Future<void>> preloadFutures = images.map((image) {
      final Completer<void> completer = Completer<void>();
      final ImageStream stream = CachedNetworkImageProvider(image['imageUrl'])
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

    notifyListeners();
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
}
