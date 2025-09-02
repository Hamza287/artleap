import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:Artleap.ai/domain/api_models/models_list_model.dart';
import '../api_repos_abstract/load_models_list_repo.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class LoadModelsListImpl extends LoadModelsListRepo {
  @override
  Future<ApiResponse> getModelsListData(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await getModelsListApi.postJson("", data, enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.completed) {
        List<ModelsListModel> modelsList = await Isolate.run(() =>
            (res.data as List).map((model) => ModelsListModel.fromJson(model)).toList());
        return ApiResponse.completed(modelsList);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
