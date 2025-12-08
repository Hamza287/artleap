import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/base_repo/base_repo.dart';
import 'package:Artleap.ai/shared/route_export.dart';
import 'package:url_launcher/url_launcher.dart';

final userProfileProvider = ChangeNotifierProvider<UserProfileProvider>((ref) => UserProfileProvider());

class UserProfileProvider extends ChangeNotifier with BaseRepo {
  // lifecycle / state
  bool _disposed = false;

  // loader & data
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

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // ----- internal safe notify -----
  void safeNotify() {
    if (_disposed) return;

    try {
      notifyListeners();
    } catch (e) {
      debugPrint("❌ notifyListeners() failed after dispose: $e");
    }
  }


  // set loader safely
  void setLoader(bool value) {
    if (_disposed) return;
    _isLoading = value;
    safeNotify();
  }

  // -------------------------
  // API methods (all await calls check _disposed after returning)
  // -------------------------

  Future<void> followUnfollowUser(String uid, String followId) async {
    if (_disposed) return;

    setLoader(true);

    final data = {"userId": uid, "followId": followId};
    final response = await userFollowingRepo.followUnFollowUser(data);

    if (_disposed) return;

    if (response.status == Status.completed) {
      // await result of getUserProfileData as it already performs disposed checks
      await getUserProfileData(uid);
    } else {
      if (_disposed) return;
      appSnackBar("Error", response.message ?? "Failed to follow/unfollow user", backgroundColor: AppColors.redColor);
    }

    if (_disposed) return;
    setLoader(false);
  }

  Future<void> getUserProfileData(String uid) async {
    final id = uid.trim();
    if (id.isEmpty) {
      if (!_disposed) {
        appSnackBar("Error", "User ID is empty", backgroundColor: AppColors.redColor);
      }
      return;
    }

    if (_disposed) return;
    setLoader(true);

    final response = await userFollowingRepo.getUserProfileData(id);

    if (_disposed) return;

    if (response.status == Status.completed) {
      _userProfileData = response.data;
      _dailyCredits = _userProfileData?.user.totalCredits ?? 0;
    } else {
      if (!_disposed) {
        appSnackBar("Error", response.message ?? "Failed to fetch user profile", backgroundColor: AppColors.redColor);
        debugPrint('❌ Profile failed for "$id": ${response.message}');
      }
    }

    if (_disposed) return;
    setLoader(false);
  }

  Future<void> getProfilesForUserIds(List<String> ids) async {
    if (_disposed) return;

    for (final id in ids) {
      if (_disposed) return;
      if (_profilesCache.containsKey(id)) continue;

      final response = await userFollowingRepo.getOtherUserProfileData(id);

      if (_disposed) return;

      if (response.status == Status.completed) {
        if (response.data != null) {
          _profilesCache[id] = response.data!;
        }
      } else {
        // optional: handle failure per id if needed
      }
    }

    if (_disposed) return;
    safeNotify();
  }

  Future<void> getOtherUserProfileData(String uid) async {
    if (_disposed) return;
    setLoader(true);

    final response = await userFollowingRepo.getOtherUserProfileData(uid);

    if (_disposed) return;

    if (response.status == Status.completed) {
      _otherUserProfileData = response.data;
    } else {
      if (!_disposed) {
        appSnackBar("Error", response.message ?? "Failed to fetch other user profile", backgroundColor: AppColors.redColor);
      }
    }

    if (_disposed) return;
    setLoader(false);
  }

  Future<void> updateUserCredits() async {
    if (_disposed) return;

    setLoader(true);

    final data = {"userId": UserData.ins.userId};
    final response = await userFollowingRepo.updateUserCredits(data);

    if (_disposed) return;

    if (response.status == Status.completed) {
      await getUserProfileData(UserData.ins.userId ?? "");
    } else {
      if (!_disposed) {
        debugPrint("Failed to update credits: ${response.message}");
      }
    }

    if (_disposed) return;
    setLoader(false);
  }


  Future<void> deActivateAccount(String uid) async {
    if (_disposed) return;
    setLoader(true);

    final response = await userFollowingRepo.deleteAccount(uid);

    if (_disposed) return;

    if (response.status == Status.completed) {
      // clear local data and navigate — do navigation BEFORE any further notify
      AppLocal.ins.clearUSerData(Hivekey.userId);

      // navigate; navigation may dispose listeners synchronously
      Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);

      // show snackbar only if still alive (often navigation will dispose current screen quickly)
      if (!_disposed) {
        appSnackBar("Success", "Your account has been deleted successfully", backgroundColor: AppColors.green);
      }
      // after navigation, provider may be disposed; avoid further state updates
      setLoader(false);
      return;
    } else {
      if (!_disposed) {
        appSnackBar("Error", response.message ?? "Something went wrong, please try again", backgroundColor: AppColors.redColor);
      }
    }

    if (_disposed) return;
    setLoader(false);
  }

  Future<void> launchAnyUrl(String? url) async {
    if (url == null || _disposed) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      if (_disposed) return;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!_disposed) {
        appSnackBar("Error", "Could not launch $url", backgroundColor: AppColors.redColor);
      }
    }
  }
}
