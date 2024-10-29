import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class FreepikAiGenRepo extends Base {
  Future<ApiResponse> generateImage(String data,
      {bool enableLocalPersistence = false});
}
