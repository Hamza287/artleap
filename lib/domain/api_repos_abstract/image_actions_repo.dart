import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class ImageActionsRepo extends Base {
  Future<ApiResponse> deleteImage({
    required String imageId,
  });
  Future<ApiResponse> reportImage(
      {required Map<String, dynamic> body, required String imageId});
}
