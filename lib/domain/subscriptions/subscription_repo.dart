import '../api_services/api_response.dart';
import '../base_repo/base.dart';

abstract class SubscriptionRepo extends Base {
  Future<ApiResponse> getSubscriptionPlans({bool enableLocalPersistence = false});
  Future<ApiResponse> subscribe(Map<String, dynamic> data, {bool enableLocalPersistence = false});
  Future<ApiResponse> startTrial(Map<String, dynamic> data, {bool enableLocalPersistence = false});
  Future<ApiResponse> cancelSubscription(Map<String, dynamic> data, {bool enableLocalPersistence = false});
  Future<ApiResponse> getCurrentSubscription(String userId, {bool enableLocalPersistence = false});
  Future<ApiResponse> checkGenerationLimits(String userId, String generationType, {bool enableLocalPersistence = false});
}