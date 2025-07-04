import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/shared/constants/app_api_paths.dart';
import '../api_repos_abstract/user_profile_repo.dart';
import '../api_services/handling_response.dart';

class UserProfileRepoImpl extends UserProfileRepo {
  @override
  Future<ApiResponse> followUnFollowUser(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postJson(
          AppApiPaths.toggleFollow, data,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.processing) {
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        // print(result.data);
        var data = await Isolate.run(() => res.data);
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> getUserProfileData(String uid,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.get(
          AppApiPaths.getUserProData + uid,
          enableLocalPersistence: enableLocalPersistence);

      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.processing) {
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        UserProfileModel data =
            await Isolate.run(() => UserProfileModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> getOtherUserProfileData(String uid,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.get(
          AppApiPaths.getUserProData + uid,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.processing) {
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        UserProfileModel data =
            await Isolate.run(() => UserProfileModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> updateUserCredits(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postJson(
          AppApiPaths.userCredits, data,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.processing) {
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        var data = await Isolate.run(() => res.data);
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> deductCredits(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postJson(
          AppApiPaths.deductCredits, data,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.processing) {
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        print(result.data);
        var data = await Isolate.run(() => res.data);
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> deleteAccount(String uid,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.delete(
          AppApiPaths.deleteAccount + uid,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.processing) {
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        var data = await Isolate.run(() => res.data);
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
