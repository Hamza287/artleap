import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/domain/api_models/user_profile_model.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';

import '../domain/api_services/api_response.dart';
import '../shared/constants/user_data.dart';

final userProfileProvider =
    ChangeNotifierProvider<UserProfileProvider>((ref) => UserProfileProvider());

class UserProfileProvider extends ChangeNotifier with BaseRepo {
  bool _isloading = false;
  bool get isloading => _isloading;
  UserProfileModel? _userProfileData;
  UserProfileModel? get userProfileData => _userProfileData;
  UserProfileModel? _otherUserProfileData;
  UserProfileModel? get otherUserProfileData => _otherUserProfileData;
  // List<UserModel> userFollowing;
  // List<UserModel>

  setLoader(bool value) {
    _isloading = value;
    notifyListeners();
  }

  Future<void> followUnfollowUser(String uid, String followId) async {
    setLoader(true);
    Map<String, dynamic> data = {"userId": uid, "followId": followId};
    print(data);
    print("Sending request to API...");
    ApiResponse generateImageRes = await userFollowingRepo.followUnFollowUser(
      data,
    );
    // var generatedData = generateImageRes.data as ImgToImg.ImageToImageModel;
    if (generateImageRes.status == Status.completed) {
      getUserProfileData(uid);
      setLoader(false);
    } else {
      print(generateImageRes.status);

      setLoader(false);
    }
    notifyListeners();
  }

  Future<void> getUserProfileData(String uid) async {
    setLoader(true);
    print(uid);
    print("Sending request to API...");
    ApiResponse userProfileDataRes =
        await userFollowingRepo.getUserProfileData(uid);
    if (userProfileDataRes.status == Status.completed) {
      print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
      _userProfileData = userProfileDataRes.data as UserProfileModel;
      print(_userProfileData!.user.email);
      setLoader(false);
    } else {
      print(userProfileDataRes.status);

      setLoader(false);
    }
    notifyListeners();
  }

  Future<void> getOtherUserProfileData(String uid) async {
    print("Sending request to API...");
    ApiResponse userProfileDataRes =
        await userFollowingRepo.getUserProfileData(uid);
    if (userProfileDataRes.status == Status.completed) {
      _otherUserProfileData = userProfileDataRes.data as UserProfileModel;
      print("dddddddddddddddddddddddddddddddddddddddd");
      print(_otherUserProfileData!.user.username);

      print(_userProfileData!.user.email);
    } else {
      print(userProfileDataRes.status);
    }
    notifyListeners();
  }

  Future<void> updateUserCredits() async {
    Map<String, dynamic> mapdata = {
      "userId": UserData.ins.userId,
    };
    // var data = jsonEncode(mapdata);
    // print(data);
    ApiResponse generateImageRes =
        await userFollowingRepo.updateUserCredits(mapdata);
    if (generateImageRes.status == Status.completed) {
      print("ddddddddddddddddd");
    } else {
      print(generateImageRes.status);
    }
    notifyListeners();
  }

  Future<void> deductUserCredits() async {
    print("00000000000000000000");
    Map<String, dynamic> mapdata = {
      "userId": UserData.ins.userId,
      "creditsToDeduct": 25
    };
    print(mapdata);
    ApiResponse response = await userFollowingRepo.deductCredits(mapdata);
    if (response.status == Status.completed) {
      getUserProfileData(UserData.ins.userId ?? "");
      print(response.data);
      print(response.message);
      print("11111111111111111111svvvvssssssssssss11");
    } else {
      print(response.status);
    }
    notifyListeners();
  }
}
