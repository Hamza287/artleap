import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class GenerateImageRepo extends Base {
  Future<ApiResponse> generateImage(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});
}
