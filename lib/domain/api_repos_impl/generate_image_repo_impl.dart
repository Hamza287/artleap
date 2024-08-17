import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:photoroomapp/domain/api_models/generate_image_model.dart';
import 'package:photoroomapp/domain/api_repos_abstract/generate_image_repo.dart';
import 'package:photoroomapp/domain/api_services/api_response.dart';
import '../../shared/console.dart';
import '../api_services/handling_response.dart';

class GenerateImageImpl extends GenerateImageRepo {
  @override
  Future<ApiResponse> generateImage(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await textToImageService.postJson("", data,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      console('REPO : ${result.status}');
      if (result.status == Status.completed) {
        GenerateImageModel data =
            await Isolate.run(() => GenerateImageModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
