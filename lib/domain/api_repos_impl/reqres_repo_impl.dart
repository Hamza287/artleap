import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:photoroomapp/domain/api_models/reqres_user_model.dart';
import 'package:photoroomapp/domain/api_repos_abstract/reqres_repo.dart';
import 'package:photoroomapp/domain/api_services/api_response.dart';

import '../../shared/console.dart';
import '../../shared/constants/app_api_paths.dart';
import '../api_services/handling_response.dart';

class ReqResRepoImpl extends ReqResRepo {
  @override
  Future<ApiResponse> getUserData({bool enableLocalPersistence = false}) async {
    try {
      Response res = await reqresApi.get(AppApiPaths.getReqResUsers,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      console('REPO : ${result.status}');
      if (result.status == Status.completed) {
        ReqResUsersModel data =
            await Isolate.run(() => ReqResUsersModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
