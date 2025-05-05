import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:photoroomapp/domain/api_repos_abstract/generate_image_repo.dart';
import 'package:photoroomapp/domain/api_services/api_response.dart';
import '../../shared/console.dart';
import '../api_models/generate_high_q_model.dart';
import '../api_services/handling_response.dart';

class GenerateImageImpl extends GenerateImageRepo {
  @override
  Future<ApiResponse> generateHighQualityImage(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await textToHighQualityImageService.postJson("", data,
          enableLocalPersistence: enableLocalPersistence);
      print(res.data);
      ApiResponse result = HandlingResponse.returnResponse(res);
      console('REPO : ${result.status}');
      if (result.status == Status.processing) {
        print(result.data);
        print("eeeeeeeeeeeeeeeeeeeeee");
        return ApiResponse.processing("ssssssssssssssss");
      } else if (result.status == Status.completed) {
        print(result.data);
        GenerateHighQualityImageModel data = await Isolate.run(
            () => GenerateHighQualityImageModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
