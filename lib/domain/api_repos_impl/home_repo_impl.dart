import 'dart:isolate';


import 'package:dio/dio.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/home_repo.dart';

import '../../shared/constants/app_api_paths.dart';
import '../../shared/constants/app_constants.dart';
import '../api_models/users_creations_model.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class HomeRepoImpl extends HomeRepo {
  @override
  Future<ApiResponse> getUsersCreations(int pageNo) async {
    try {
      Response res = await artleapApiService.get(AppConstants.artleapBaseUrl + AppApiPaths.getUsersCreations +
          pageNo.toString());
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.completed) {
        UsersCreations data = await Isolate.run(() => UsersCreations.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
