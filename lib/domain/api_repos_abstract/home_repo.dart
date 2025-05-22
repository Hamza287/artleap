

import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class HomeRepo extends Base {
  // Future<DocumentSnapshot<Map<String, dynamic>>?> getUsersCreations();
  Future<ApiResponse> getUsersCreations(int pageNo);
}
