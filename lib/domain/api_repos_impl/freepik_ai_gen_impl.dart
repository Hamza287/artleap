import 'dart:isolate';

import 'package:dio/dio.dart';

import '../../shared/console.dart';
import '../api_models/freepik_image_gen_model.dart';
import '../api_repos_abstract/freepik_ai_gen_repo.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class FreepikAiGenImpl extends FreepikAiGenRepo {
  @override
  Future<ApiResponse> generateImage(String data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await postFreePikGen.postJson("", data,
          enableLocalPersistence: enableLocalPersistence);
      print(res);
      ApiResponse result = HandlingResponse.returnResponse(res);
      print(result);
      console('REPO : ${result.status}');
      if (result.status == Status.completed) {
        FreePikAIGenModel data =
            await Isolate.run(() => FreePikAIGenModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
