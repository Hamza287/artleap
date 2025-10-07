import '../api_services/api_response.dart';
import '../base_repo/base.dart';
import '../api_models/user_profile_model.dart';
import '../subscriptions/subscription_model.dart';

abstract class UserProfileRepo extends Base {
  Future<ApiResponse> followUnFollowUser(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});

  Future<ApiResponse<UserProfileModel>> getUserProfileData(String uid,
      {bool enableLocalPersistence = false});

  Future<ApiResponse<UserProfileModel>> getOtherUserProfileData(String uid,
      {bool enableLocalPersistence = false});

  Future<ApiResponse> updateUserCredits(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});

  Future<ApiResponse> deleteAccount(String uid,
      {bool enableLocalPersistence = false});

  Future<ApiResponse<List<SubscriptionPlanModel>>> getSubscriptionPlans(
      {bool enableLocalPersistence = false});

  Future<ApiResponse<Map<String, dynamic>>> subscribe(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});

  Future<ApiResponse<UserSubscriptionModel>> startTrial(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});

  Future<ApiResponse<Map<String, dynamic>>> cancelSubscription(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});

  Future<ApiResponse<UserSubscriptionModel?>> getCurrentSubscription(String userId,
      {bool enableLocalPersistence = false});

}