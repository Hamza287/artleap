import 'package:Artleap.ai/domain/base_repo/base.dart';

import '../api_services/api_response.dart';

abstract class ReqResRepo extends Base {
  Future<ApiResponse> getUserData({bool enableLocalPersistence = false});
}
