import 'dart:isolate';

import 'package:dio/dio.dart';

import '../../shared/console.dart';
import '../../shared/constants/app_api_paths.dart';
import '../api_models/text_to_image_model.dart';
import '../api_repos_abstract/text_to_image_repo.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class FreepikAiGenImpl extends FreepikAiGenRepo {
  @override
  Future<ApiResponse> generateImage(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postJson(
          AppApiPaths.generateImage, data,
          enableLocalPersistence: enableLocalPersistence);
      print(res);
      ApiResponse result = HandlingResponse.returnResponse(res);
      print(result);
      console('REPO : ${result.status}');
      if (result.status == Status.completed) {
        TextToImageModel data =
            await Isolate.run(() => TextToImageModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
