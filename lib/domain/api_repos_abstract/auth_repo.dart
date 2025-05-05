import 'package:photoroomapp/domain/base_repo/base.dart';

import '../api_services/api_response.dart';

abstract class AuthRepo extends Base {
  Future<ApiResponse> login({required Map<String, dynamic> body});
  Future<ApiResponse> signup({required Map<String, dynamic> body});
  Future<ApiResponse> googleLogin({required Map<String, dynamic> body});
}
