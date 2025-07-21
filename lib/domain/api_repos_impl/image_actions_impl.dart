import 'package:dio/dio.dart';
import 'package:Artleap.ai/domain/api_repos_abstract/image_actions_repo.dart';
import '../../shared/constants/app_api_paths.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class ImageActionsImpl extends ImageActionsRepo {
  @override
  Future<ApiResponse> deleteImage({required String? imageId}) async {
    try {
      Response res =
          await artleapApiService.delete(AppApiPaths.deleteImage + imageId!);
      ApiResponse result = HandlingResponse.returnResponse(res);
      if (result.status == Status.completed) {
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
      // print(
      //   "${AppConstants.artleapBaseUrl}${AppApiPaths.reportImage}$imageId/report",
      // );
      ApiResponse result = HandlingResponse.returnResponse(res);
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
