import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/base_repo/base.dart';

abstract class RewardedAdRepo extends Base {
  Future<ApiResponse> sendRewardToBackend(Map<String, dynamic> data);
  Future<ApiResponse<Map<String, dynamic>>> getUserCredits();
}