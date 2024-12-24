import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:photoroomapp/domain/api_models/Image_to_Image_model.dart';
import 'package:photoroomapp/domain/api_models/generate_image_model.dart';
import 'package:photoroomapp/domain/api_repos_abstract/generate_image_repo.dart';
import 'package:photoroomapp/domain/api_repos_abstract/img2img_repo.dart';
import 'package:photoroomapp/domain/api_services/api_response.dart';
import '../../shared/console.dart';
import '../api_services/handling_response.dart';

class GenerateImg2ImgImpl extends GenerateImg2ImgRepo {
  @override
  Future<ApiResponse> generateImgToImg(
      Map<String, dynamic> data, List<File> images,
      {bool enableLocalPersistence = false}) async {
    print(data);
    print("dddddddddddd");
    try {
      Response res = await imgToimgService.postFormData("",
          data: data,
          imageFieldKey: "image",
          images: images,
          enableLocalPersistence: enableLocalPersistence);
      ApiResponse result = HandlingResponse.returnResponse(res);
      console('REPO : ${result.status}');
      print(res.data);
      if (result.status == Status.processing) {
        print("daaaaaaaaaaaaaa");
        return ApiResponse.processing(res.data);
      } else if (result.status == Status.completed) {
        print("jjjjjjjjjjjjjjjjj");
        ImageToImageModel data =
            await Isolate.run(() => ImageToImageModel.fromJson(res.data));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }
}
