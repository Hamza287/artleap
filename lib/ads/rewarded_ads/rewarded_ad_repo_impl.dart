import 'package:Artleap.ai/ads/rewarded_ads/rewarded_ad_repo.dart';
import 'package:Artleap.ai/domain/api_services/handling_response.dart';
import 'package:dio/dio.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/shared/constants/app_api_paths.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class RewardedAdRepoImpl extends RewardedAdRepo {
  @override
  Future<ApiResponse> sendRewardToBackend(Map<String, dynamic> data,
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.postJson(
        AppApiPaths.addRewardedCredits, // Changed to new endpoint
        data,
        enableLocalPersistence: enableLocalPersistence,
      );
      return HandlingResponse.returnResponse(res);
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getUserCredits(
      {bool enableLocalPersistence = false}) async {
    try {
      Response res = await artleapApiService.get(
        AppApiPaths.userCredits,
        enableLocalPersistence: enableLocalPersistence,
      );
      return HandlingResponse.returnResponse<Map<String, dynamic>>(
        res,
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<Map<String, dynamic>>(e);
    }
  }

  // New method to get user credits status for ad eligibility
  Future<ApiResponse<Map<String, dynamic>>> getUserCreditsStatus(
      {bool enableLocalPersistence = false}) async {
    try {
      final userId = UserData.ins.userId;
      if (userId == null) {
        return ApiResponse.error('User not logged in');
      }

      Response res = await artleapApiService.get(
        '${AppApiPaths.getRewardedCredits}/$userId',
        enableLocalPersistence: enableLocalPersistence,
      );
      return HandlingResponse.returnResponse<Map<String, dynamic>>(
        res,
        fromJson: (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<Map<String, dynamic>>(e);
    }
  }
}