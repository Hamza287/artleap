import 'package:dio/dio.dart';
import '../../shared/constants/app_api_paths.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';
import '../base_repo/base.dart';

class ImagePrivacyRepository {
  final Base _base = Base();

  Future<ApiResponse> updatePrivacy({
    required String imageId,
    required String userId,
    required String privacy,
  }) async {
    try {
      Response res = await _base.artleapApiService.postJson(
        "${AppApiPaths.updateImagePrivacy}$imageId/privacy",
        {
          "userId": userId,
          "privacy": privacy,
        },
      );

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
