import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class UserProfileRepo extends Base {
  Future<ApiResponse> followUnFollowUser(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});

  Future<ApiResponse> getUserProfileData(String uid,
      {bool enableLocalPersistence = false});

  Future<ApiResponse> getOtherUserProfileData(String uid,
      {bool enableLocalPersistence = false});

  Future<ApiResponse> updateUserCredits(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});

  Future<ApiResponse> deductCredits(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});
  Future<ApiResponse> deleteAccount(String uid,
      {bool enableLocalPersistence = false});
}
