import 'package:dio/dio.dart';
import 'package:photoroomapp/domain/api_repos_abstract/image_actions_repo.dart';

import '../../shared/constants/app_api_paths.dart';
import '../../shared/constants/app_constants.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class ImageActionsImpl extends ImageActionsRepo {
  @override
  Future<ApiResponse> deleteImage({required String? imageId}) async {
    try {
      Response res =
          await artleapApiService.delete(AppApiPaths.deleteImage + imageId!);
      print(AppConstants.artleapBaseUrl + AppApiPaths.deleteImage + imageId);
      ApiResponse result = HandlingResponse.returnResponse(res);
      print(res);
      // console('REPO : ${result.status}');
      if (result.status == Status.completed) {
        // DummyModel data =
        //     await Isolate.run(() => DummyModel.fromJson(res.data));
        return ApiResponse.completed(res.data);
      } else {
        return result;
      }
    } on DioException catch (w) {
      return HandlingResponse.returnException(w);
    }
  }

  @override
  Future<ApiResponse> reportImage(
      {required Map<String, dynamic> body, required String imageId}) async {
    try {
      Response res = await artleapApiService.postJson(
          "${AppApiPaths.reportImage}$imageId/report", body);
      print(
        "${AppConstants.artleapBaseUrl}${AppApiPaths.reportImage}$imageId/report",
      );
      ApiResponse result = HandlingResponse.returnResponse(res);
      print(res);
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
