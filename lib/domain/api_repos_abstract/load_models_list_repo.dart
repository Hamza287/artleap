import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class LoadModelsListRepo extends Base {
  Future<ApiResponse> getModelsListData(Map<String, dynamic> data,
      {bool enableLocalPersistence = false});
}
