import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_impl.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';

final subscriptionRepoProvider = Provider<SubscriptionRepoImpl>((ref) => SubscriptionRepoImpl());

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final repo = ref.read(subscriptionRepoProvider);
  return SubscriptionService(repo);
});

final subscriptionPlansProvider = FutureProvider<List<SubscriptionPlanModel>>((ref) async {
  final service = ref.read(subscriptionServiceProvider);
  final response = await service.getSubscriptionPlans();
  if (response.status == Status.completed) {
    return response.data as List<SubscriptionPlanModel>;
  }
  throw Exception(response.message);
});

final currentSubscriptionProvider = FutureProvider.family<UserSubscriptionModel?, String>((ref, userId) async {
  final service = ref.read(subscriptionServiceProvider);
  final response = await service.getCurrentSubscription(userId);
  if (response.status == Status.completed) {
    return response.data;
  }
  return null; // Handle no active subscription
});

final generationLimitsProvider = FutureProvider.family<GenerationLimitsModel, Map<String, String>>((ref, params) async {
  final service = ref.read(subscriptionServiceProvider);
  final response = await service.checkGenerationLimits(params['userId']!, params['generationType']!);
  if (response.status == Status.completed) {
    return response.data as GenerationLimitsModel;
  }
  throw Exception(response.message);
});