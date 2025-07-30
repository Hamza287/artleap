import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo.dart';

class SubscriptionService {
  final SubscriptionRepo _subscriptionRepo;

  SubscriptionService(this._subscriptionRepo);

  Future<ApiResponse> getSubscriptionPlans() async {
    return await _subscriptionRepo.getSubscriptionPlans();
  }

  Future<ApiResponse> subscribe(String userId, String planId, String paymentMethod) async {
    final data = {
      'userId': userId,
      'planId': planId,
      'paymentMethod': paymentMethod,
    };
    print('data sending for subscribe $data');
    return await _subscriptionRepo.subscribe(data);
  }

  Future<ApiResponse> startTrial(String userId, String paymentMethod) async {
    final data = {
      'userId': userId,
      'paymentMethod': paymentMethod,
    };
    return await _subscriptionRepo.startTrial(data);
  }

  Future<ApiResponse> cancelSubscription(String userId, bool immediate) async {
    final data = {
      'userId': userId,
      'immediate': immediate,
    };
    return await _subscriptionRepo.cancelSubscription(data);
  }

  Future<ApiResponse> getCurrentSubscription(String userId) async {
    return await _subscriptionRepo.getCurrentSubscription(userId);
  }

  Future<ApiResponse> checkGenerationLimits(String userId, String generationType) async {
    return await _subscriptionRepo.checkGenerationLimits(userId, generationType);
  }
}