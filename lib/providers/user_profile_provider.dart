import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/domain/base_repo/base_repo.dart';
import 'package:photoroomapp/shared/app_persistance/app_data.dart';
import 'package:photoroomapp/shared/constants/user_data.dart';
import 'package:uuid/uuid.dart';

final userProfileProvider =
    ChangeNotifierProvider<UserProfileProvider>((ref) => UserProfileProvider());

class UserProfileProvider extends ChangeNotifier with BaseRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _userCreations = [];
  List<Map<String, dynamic>> get usersCreations => _userCreations;
  List<Map<String, dynamic>> _userFollowingData = [];
  List<Map<String, dynamic>> get userFollowingData => _userFollowingData;
  List<Map<String, dynamic>> _userFollowerData = [];
  List<Map<String, dynamic>> get userFollowerData => _userFollowerData;
  Map<String, dynamic> _otherUserProfileData = {};
  Map<String, dynamic> get otherUserProfileData => _otherUserProfileData;
  Map<String, dynamic>? _otherUserPersonalInfo;
  Map<String, dynamic>? get otherUserPersonalInfo => _otherUserPersonalInfo;
  Map<String, dynamic>? _userPersonalData;
  Map<String, dynamic>? get userPersonalData => _userPersonalData;
  Map<String, dynamic> _userDailyCredits = {};
  Map<String, dynamic> get userDailyCredits => _userDailyCredits;

  // String? _userId;
  // String? get userId => _userId;
  // String? _userName;
  // String? get userName => _userName;
  var uuid = const Uuid().v1();
  bool _isloading = false;
  bool get isloading => _isloading;

  setLoading(bool val) {
    _isloading = val;
    notifyListeners();
  }

  // getUserInfo() {
  //   _userId = AppLocal.ins.getUSerData(Hivekey.userId);
  //   _userName = AppLocal.ins.getUSerData(Hivekey.userName);

  //   print(_userId);
  //   notifyListeners();
  // }

  getUserProfiledata() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('usersProfileData')
          .doc(UserData.ins.userId)
          .get();
      DocumentSnapshot<Map<String, dynamic>> userPersonalInfo =
          await firestore.collection('users').doc(UserData.ins.userId).get();
      // Map<String, dynamic>? userCredits = snapshot.data()?['credits'] ?? {};
      List<Map<String, dynamic>> userData =
          List<Map<String, dynamic>>.from(snapshot.data()?['userData'] ?? []);
      List<Map<String, dynamic>> userFollowingData =
          List<Map<String, dynamic>>.from(snapshot.data()?['following'] ?? []);
      List<Map<String, dynamic>> userFollowerData =
          List<Map<String, dynamic>>.from(snapshot.data()?['followers'] ?? []);
      print(userData);
      _userCreations = userData;
      _userFollowingData = userFollowingData;
      _userFollowerData = userFollowerData;
      _userPersonalData = userPersonalInfo.data() ?? {};
      _userDailyCredits = _userPersonalData!["credits"];

      print(_userPersonalData);
      print(_userDailyCredits);
    } catch (e) {
      print('Error retrieving data from Firestore: $e');
    }
    notifyListeners();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserProfileData() async {
    var data = await userProfileRepo.fetchUserProfileData(UserData.ins.userId!);
    print(data!.data());
    notifyListeners(); // Notify listeners to update UI
    return data;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserPersonalData(
      String? userid) async {
    var data = await userProfileRepo.fetchUserPersonalData(userid!);
    notifyListeners(); // Notify listeners to update UI
    return data;
  }

  getOtherUserProfiledata(String otherUserId) async {
    print(otherUserId);
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('usersProfileData').doc(otherUserId).get();
      DocumentSnapshot<Map<String, dynamic>> otherUserData =
          await firestore.collection('users').doc(otherUserId).get();
      _otherUserProfileData = snapshot.data() as Map<String, dynamic>;
      _otherUserPersonalInfo = otherUserData.data() as Map<String, dynamic>;
      print("ssssssssssssss");
      print(_otherUserProfileData);
    } catch (e) {
      print('Error retrieving data from Firestore: $e');
    }
    notifyListeners();
  }

  Future<void> userFollowRequest(String currentUserId, String followedUserId,
      String userName, String currentUserName) async {
    setLoading(true);
    try {
      await firestore.collection('usersProfileData').doc(currentUserId).set({
        'following': FieldValue.arrayUnion([
          {
            "user_name": userName,
            'userid': followedUserId,
          }
        ])
      }, SetOptions(merge: true));
      await firestore.collection('usersProfileData').doc(followedUserId).set({
        'followers': FieldValue.arrayUnion([
          {
            "user_name": currentUserName,
            "id": currentUserId,
          }
        ])
      }, SetOptions(merge: true));
      getUserProfiledata();
      getOtherUserProfiledata(followedUserId);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print('Error following user: $e');
    }
  }

  Future<void> userUnfollowRequest(String currentUserId, String followedUserId,
      String userName, String currentUserName) async {
    setLoading(true);

    try {
      await firestore.collection('usersProfileData').doc(currentUserId).set({
        'following': FieldValue.arrayRemove([
          {
            "user_name": userName,
            'userid': followedUserId,
          }
        ])
      }, SetOptions(merge: true));

      await firestore.collection('usersProfileData').doc(followedUserId).set({
        'followers': FieldValue.arrayRemove([
          {
            "user_name": currentUserName,
            "id": currentUserId,
          }
        ])
      }, SetOptions(merge: true));
      getUserProfiledata();
      getOtherUserProfiledata(followedUserId);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print('Error unfollowing user: $e');
    }
  }

  refreshFtn() async {
    await getUserProfiledata();
    await fetchUserProfileData();
    await fetchUserPersonalData(UserData.ins.userId);
  }
}
