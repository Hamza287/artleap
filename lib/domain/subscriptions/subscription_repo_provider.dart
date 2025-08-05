import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_impl.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:dio/dio.dart';
import '../../providers/watermark_provider.dart';
import '../payment/payment_service.dart';

final subscriptionRepoProvider = Provider<SubscriptionRepoImpl>((ref) => SubscriptionRepoImpl());

final dioProvider = Provider<Dio>((ref) => Dio());

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final repo = ref.read(subscriptionRepoProvider);
  return SubscriptionService(repo);
});

final paymentServiceProvider = Provider.family<PaymentService, String>((ref, userId) {
  final subscriptionService = ref.read(subscriptionServiceProvider);
  final dio = ref.read(dioProvider);
  return PaymentService(subscriptionService, userId, dio);
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
    ref.read(watermarkProvider.notifier).initializeWatermarkState();
    return response.data;
  }
  return null;
});

final generationLimitsProvider = FutureProvider.family<GenerationLimitsModel, Map<String, String>>((ref, params) async {
  ref.read(watermarkProvider.notifier).initializeWatermarkState();
  final service = ref.read(subscriptionServiceProvider);
  final response = await service.checkGenerationLimits(params['userId']!, params['generationType']!);
  if (response.status == Status.completed) {
    return response.data as GenerationLimitsModel;
  }
  throw Exception(response.message);
});