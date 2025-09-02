import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:Artleap.ai/domain/api_models/Image_to_Image_model.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/img2img_repo.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/shared/constants/app_api_paths.dart';
import '../api_services/handling_response.dart';

class GenerateImg2ImgImpl extends GenerateImg2ImgRepo {
  @override
  Future<ApiResponse> generateImgToImg(
      Map<String, dynamic> data, List<File> images,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postFormData(
          AppApiPaths.img2imgPath,
          data: data,
          imageFieldKey: "image",
          images: images,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.processing) {
        return ApiResponse.processing(res.data);
      } else if (result.status == Status.completed) {
        ImageToImageModel data = await Isolate.run(() => ImageToImageModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
