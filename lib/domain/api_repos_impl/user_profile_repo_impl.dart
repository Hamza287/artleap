import 'package:dio/dio.dart';
import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/shared/constants/app_api_paths.dart';
import '../api_services/handling_response.dart';
import '../api_repos_abstract/user_profile_repo.dart';
import '../subscriptions/subscription_model.dart';

class UserProfileRepoImpl extends UserProfileRepo {
  @override
  Future<ApiResponse> followUnFollowUser(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postJson(AppApiPaths.toggleFollow, data, enableLocalPersistence: enableLocalPersistence);
      return HandlingResponse.returnResponse(res);
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse<UserProfileModel>> getUserProfileData(String uid,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.get("${AppApiPaths.getUserProData}$uid", enableLocalPersistence: enableLocalPersistence);
      return HandlingResponse.returnResponse<UserProfileModel>(
        res,
        fromJson: (json) => UserProfileModel.fromJson(json),
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<UserProfileModel>(e);
    }
  }

  @override
  Future<ApiResponse<UserProfileModel>> getOtherUserProfileData(String uid,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.get("${AppApiPaths.getUserProData}$uid", enableLocalPersistence: enableLocalPersistence);
      return HandlingResponse.returnResponse<UserProfileModel>(
        res,
        fromJson: (json) => UserProfileModel.fromJson(json),
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<UserProfileModel>(e);
    }
  }

  @override
  Future<ApiResponse> updateUserCredits(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postJson(AppApiPaths.userCredits, data, enableLocalPersistence: enableLocalPersistence);
      return HandlingResponse.returnResponse(res);
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> deleteAccount(String uid,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.delete("${AppApiPaths.deleteAccount}$uid", enableLocalPersistence: enableLocalPersistence);
      return HandlingResponse.returnResponse(res);
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse<List<SubscriptionPlanModel>>> getSubscriptionPlans(
      {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.get(
        AppApiPaths.getSubscriptionPlans,
        enableLocalPersistence: enableLocalPersistence,
      );

      return HandlingResponse.returnResponse<List<SubscriptionPlanModel>>(
        response,
        fromJson: (json) => (json['data'] as List).map((e) => SubscriptionPlanModel.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> subscribe(
      Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.postJson(
        AppApiPaths.subscribe,
        data,
        enableLocalPersistence: enableLocalPersistence,
      );

      return HandlingResponse.returnResponse<Map<String, dynamic>>(
        response,
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<Map<String, dynamic>>(e);
    }
  }

  @override
  Future<ApiResponse<UserSubscriptionModel>> startTrial(
      Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.postJson(
        AppApiPaths.startTrial,
        data,
        enableLocalPersistence: enableLocalPersistence,
      );

      return HandlingResponse.returnResponse<UserSubscriptionModel>(
        response,
        fromJson: (json) => UserSubscriptionModel.fromJson(json['data']),
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<UserSubscriptionModel>(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> cancelSubscription(
      Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.postJson(
        AppApiPaths.cancelSubscription,
        data,
        enableLocalPersistence: enableLocalPersistence,
      );

      return HandlingResponse.returnResponse<Map<String, dynamic>>(
        response,
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<Map<String, dynamic>>(e);
    }
  }

  @override
  Future<ApiResponse<UserSubscriptionModel?>> getCurrentSubscription(
      String userId,
      {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.get(
        AppApiPaths.getCurrentSubscription,
        enableLocalPersistence: enableLocalPersistence,
      );

      return HandlingResponse.returnResponse<UserSubscriptionModel?>(
        response,
        fromJson: (json) => json['data'] != null
            ? UserSubscriptionModel.fromJson(json['data'])
            : null,
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<UserSubscriptionModel?>(e);
    }
  }

  // @override
  // Future<ApiResponse<UserProfileModel>> updateProfile({
  //   required String userId,
  //   String? username,
  //   String? email,
  //   String? password,
  //   XFile? profilePic,
  //   bool enableLocalPersistence = false,
  // }) async {
  //   try {
  //     FormData formData;
  //
  //     if (profilePic != null) {
  //       formData = FormData.fromMap({
  //         if (username != null) 'username': username,
  //         if (email != null) 'email': email,
  //         if (password != null) 'password': password,
  //         'profilePic': await MultipartFile.fromFile(
  //           profilePic.path,
  //           filename: profilePic.name,
  //         ),
  //       });
  //     } else {
  //       formData = FormData.fromMap({
  //         if (username != null) 'username': username,
  //         if (email != null) 'email': email,
  //         if (password != null) 'password': password,
  //       });
  //     }
  //
  //     final response = await artleapApiService.put(
  //       "${AppApiPaths.updateProfile}/$userId",
  //       formData,
  //       enableLocalPersistence: enableLocalPersistence,
  //     );
  //
  //     return HandlingResponse.returnResponse<UserProfileModel>(
  //       response,
  //       fromJson: (json) => UserProfileModel.fromJson(json),
  //     );
  //   } on DioException catch (e) {
  //     return HandlingResponse.returnException<UserProfileModel>(e);
  //   }
  // }

  // @override
  // Future<ApiResponse<Map<String, dynamic>>> checkCreditsAvailability(String userId, String generationType, {bool enableLocalPersistence = false}) async {
  //   try {
  //     final response = await artleapApiService.get(
  //       "${AppApiPaths.checkCreditsAvailability}/$userId/$generationType",
  //       enableLocalPersistence: enableLocalPersistence,
  //     );
  //
  //     return HandlingResponse.returnResponse<Map<String, dynamic>>(
  //       response,
  //       fromJson: (json) => json as Map<String, dynamic>,
  //     );
  //   } on DioException catch (e) {
  //     return HandlingResponse.returnException<Map<String, dynamic>>(e);
  //   }
  // }

}