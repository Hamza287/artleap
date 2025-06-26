import 'package:dio/dio.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/auth_repo.dart';
import 'package:Artleap.ai/shared/constants/app_constants.dart';

import '../../shared/console.dart';
import '../../shared/constants/app_api_paths.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<ApiResponse> login({required Map<String, dynamic> body}) async {
    try {
      Response res = await artleapApiService.postJson(AppApiPaths.login, body);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.completed) {
        return ApiResponse.completed(res.data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> signup({required Map<String, dynamic> body}) async {
    try {
      Response res = await artleapApiService.postJson(AppApiPaths.signup, body);
      print(AppConstants.artleapBaseUrl + AppApiPaths.signup);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.completed) {
        return ApiResponse.completed(res.data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> googleLogin({required Map<String, dynamic> body}) async {
    try {
      Response res =
          await artleapApiService.postJson(AppApiPaths.googleLogin, body);
      print(AppConstants.artleapBaseUrl + AppApiPaths.googleLogin);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.completed) {
        return ApiResponse.completed(res.data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> appleLogin({required Map<String, dynamic> body}) async {
    try {
      Response res =
          await artleapApiService.postJson(AppApiPaths.appleLogin, body);
      print(AppConstants.artleapBaseUrl + AppApiPaths.appleLogin);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.completed) {
        return ApiResponse.completed(res.data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
