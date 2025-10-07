import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/subscriptions/subscription_model.dart';

final userProfileProvider = ChangeNotifierProvider<UserProfileProvider>((ref) => UserProfileProvider());

class UserProfileProvider extends ChangeNotifier with BaseRepo {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  UserProfileModel? _userProfileData;
  UserProfileModel? get userProfileData => _userProfileData;
  UserProfileModel? _otherUserProfileData;
  UserProfileModel? get otherUserProfileData => _otherUserProfileData;
  List<SubscriptionPlanModel>? _subscriptionPlans;
  List<SubscriptionPlanModel>? get subscriptionPlans => _subscriptionPlans;
  UserSubscriptionModel? _currentSubscription;
  UserSubscriptionModel? get currentSubscription => _currentSubscription;
  int _remainingImageCredits = 0;
  int get remainingImageCredits => _remainingImageCredits;
  int _remainingPromptCredits = 0;
  int get remainingPromptCredits => _remainingPromptCredits;
  int _dailyCredits = 0;
  int get dailyCredits => _dailyCredits;

  final Map<String, UserProfileModel> _profilesCache = {};
  Map<String, UserProfileModel> get profilesCache => _profilesCache;
  UserProfileModel? getProfileById(String id) => _profilesCache[id];

  void setLoader(bool value) {
    _isLoading = value;
    if (hasListeners) {
      notifyListeners();
    }
  }

  Future<void> followUnfollowUser(String uid, String followId) async {
    setLoader(true);
    final data = {"userId": uid, "followId": followId};
    final response = await userFollowingRepo.followUnFollowUser(data);
    if (response.status == Status.completed) {
      await getUserProfileData(uid);
    } else {
      appSnackBar("Error", response.message ?? "Failed to follow/unfollow user", AppColors.redColor);
    }
    setLoader(false);
    notifyListeners();
  }

  Future<void> getUserProfileData(String uid) async {
    final id = uid.trim();
    if (id.isEmpty) {
      appSnackBar("Error", "User ID is empty", AppColors.redColor);
      return;
    }

    setLoader(true);

    final response = await userFollowingRepo.getUserProfileData(id);

    if (response.status == Status.completed) {
      _userProfileData = response.data;
      _dailyCredits = _userProfileData?.user.totalCredits ?? 0;
    } else {
      appSnackBar("Error", response.message ?? "Failed to fetch user profile", AppColors.redColor);
      debugPrint('❌ Profile failed for "$id": ${response.message}');
    }
    setLoader(false);
    if (hasListeners) notifyListeners();
  }

  Future<void> getProfilesForUserIds(List<String> ids) async {
    for (final id in ids) {
      if (_profilesCache.containsKey(id)) continue; // skip if already fetched
      final response = await userFollowingRepo.getOtherUserProfileData(id);
      if (response.status == Status.completed) {
        _profilesCache[id] = response.data!;
      } else {
        debugPrint("❌ Failed to load profile for $id: ${response.message}");
      }
    }
    notifyListeners();
  }


  Future<void> getOtherUserProfileData(String uid) async {
    setLoader(true);
    final response = await userFollowingRepo.getOtherUserProfileData(uid);
    if (response.status == Status.completed) {
      _otherUserProfileData = response.data;
    } else {
      appSnackBar("Error", response.message ?? "Failed to fetch other user profile", AppColors.redColor);
    }
    setLoader(false);
    if (hasListeners) {
      notifyListeners();
    }
  }

  Future<void> updateUserCredits() async {
    setLoader(true);
    final data = {"userId": UserData.ins.userId};
    final response = await userFollowingRepo.updateUserCredits(data);
    if (response.status == Status.completed) {
      await getUserProfileData(UserData.ins.userId ?? "");
    } else {
      appSnackBar("Error", "Failed to update credits", AppColors.redColor);
    }
    setLoader(false);
    if (hasListeners) {
      notifyListeners();
    }
  }

  Future<void> deActivateAccount(String uid) async {
    setLoader(true);
    final response = await userFollowingRepo.deleteAccount(uid);
    if (response.status == Status.completed) {
      AppLocal.ins.clearUSerData(Hivekey.userId);
      Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
      appSnackBar("Success", "Your account has been deleted successfully", AppColors.green);
    } else {
      appSnackBar("Error", response.message ?? "Something went wrong, please try again", AppColors.redColor);
    }
    setLoader(false);
    if (hasListeners) {
      notifyListeners();
    }
  }

  // Future<void> getSubscriptionPlans() async {
  //   setLoader(true);
  //   final response = await userFollowingRepo.getSubscriptionPlans();
  //   if (response.status == Status.completed) {
  //     _subscriptionPlans = response.data ?? [];
  //   } else {
  //     appSnackBar("Error", response.message ?? "Failed to fetch subscription plans", AppColors.redColor);
  //   }
  //   setLoader(false);
  //   if (hasListeners) { // Check before notifying
  //     notifyListeners();
  //   }
  // }
  //
  // Future<void> subscribe(String planId, String paymentMethod) async {
  //   setLoader(true);
  //   final data = {
  //     "userId": UserData.ins.userId,
  //     "planId": planId,
  //     "paymentMethod": paymentMethod,
  //   };
  //   final response = await userFollowingRepo.subscribe(data);
  //   if (response.status == Status.completed) {
  //     await getCurrentSubscription();
  //     await getUserProfileData(UserData.ins.userId ?? "");
  //     appSnackBar("Success", response.data?['message'] ?? "Subscription created successfully", AppColors.green);
  //   } else {
  //     appSnackBar("Error", response.message ?? "Failed to subscribe", AppColors.redColor);
  //   }
  //   setLoader(false);
  //   if (hasListeners) { // Check before notifying
  //     notifyListeners();
  //   }
  // }
  //
  // Future<void> startTrial(String planId) async {
  //   setLoader(true);
  //   final data = {
  //     "userId": UserData.ins.userId,
  //     "planId": planId,
  //   };
  //   final response = await userFollowingRepo.startTrial(data);
  //   if (response.status == Status.completed) {
  //     await getCurrentSubscription();
  //     await getUserProfileData(UserData.ins.userId ?? "");
  //     appSnackBar("Success", "Trial started successfully", AppColors.green);
  //   } else {
  //     appSnackBar("Error", response.message ?? "Failed to start trial", AppColors.redColor);
  //   }
  //   setLoader(false);
  //   if (hasListeners) {
  //     notifyListeners();
  //   }
  // }
  //
  // Future<void> cancelSubscription({required bool immediate}) async {
  //   setLoader(true);
  //   final data = {
  //     "userId": UserData.ins.userId,
  //     "immediate": immediate,
  //   };
  //   final response = await userFollowingRepo.cancelSubscription(data);
  //   if (response.status == Status.completed) {
  //     await getCurrentSubscription();
  //     await getUserProfileData(UserData.ins.userId ?? "");
  //     appSnackBar(
  //       "Success",
  //       response.data?['message'] ?? (immediate ? "Subscription cancelled immediately" : "Subscription will not renew"),
  //       AppColors.green,
  //     );
  //   } else {
  //     appSnackBar("Error", response.message ?? "Failed to cancel subscription", AppColors.redColor);
  //   }
  //   setLoader(false);
  //   if (hasListeners) {
  //     notifyListeners();
  //   }
  // }
  //
  // Future<void> getCurrentSubscription() async {
  //   setLoader(true);
  //   final response = await userFollowingRepo.getCurrentSubscription(UserData.ins.userId ?? "");
  //   if (response.status == Status.completed) {
  //     _currentSubscription = response.data;
  //   } else {
  //     _currentSubscription = null;
  //     appSnackBar("Error", response.message ?? "Failed to fetch current subscription", AppColors.redColor);
  //   }
  //   setLoader(false);
  //   if (hasListeners) { // Check before notifying
  //     notifyListeners();
  //   }
  // }

  // Future<void> updateProfile({String? username, String? email, String? password, XFile? profilePic,}) async {
  //   setLoader(true);
  //   try {
  //     final response = await userFollowingRepo.updateProfile(
  //       userId: UserData.ins.userId ?? "",
  //       username: username,
  //       email: email,
  //       password: password,
  //       profilePic: profilePic,
  //     );
  //
  //     if (response.status == Status.completed) {
  //       await getUserProfileData(UserData.ins.userId ?? "");
  //       appSnackBar("Success", "Profile updated successfully", AppColors.green);
  //     } else {
  //       appSnackBar("Error", response.message ?? "Failed to update profile", AppColors.redColor);
  //     }
  //   } catch (e) {
  //     appSnackBar("Error", "An error occurred while updating profile", AppColors.redColor);
  //   } finally {
  //     setLoader(false);
  //     notifyListeners();
  //   }
  // }

  Future<void> launchAnyUrl(String? url) async {
    if (url == null) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      appSnackBar("Error", "Could not launch $url", AppColors.redColor);
    }
  }
}