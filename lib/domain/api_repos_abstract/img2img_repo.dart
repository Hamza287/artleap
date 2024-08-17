import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class GenerateImg2ImgRepo extends Base {
  Future<ApiResponse> generateImgToImg(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});
}
