import 'dart:isolate';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo.dart';
import 'package:dio/dio.dart';
import '../../shared/constants/app_api_paths.dart';
import '../api_services/api_response.dart';
import '../api_services/handling_response.dart';

class SubscriptionRepoImpl extends SubscriptionRepo {
  @override
  Future<ApiResponse> getSubscriptionPlans({bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.get(
        AppApiPaths.getSubscriptionPlans,
        enableLocalPersistence: enableLocalPersistence,
      );
      print('response of the plans data ${response}' );
      final result = HandlingResponse.returnResponse(response);
      if (result.status == Status.processing) {
        return ApiResponse.processing("Fetching plans...");
      } else if (result.status == Status.completed) {
        final data = await Isolate.run(() => (response.data['data'] as List)
            .map((e) => SubscriptionPlanModel.fromJson(e))
            .toList());
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> subscribe(Map<String, dynamic> data, {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.postJson(
        AppApiPaths.subscribe,
        data,
        enableLocalPersistence: enableLocalPersistence,
      );
      final result = HandlingResponse.returnResponse(response);
      if (result.status == Status.processing) {
        return ApiResponse.processing("Subscribing...");
      } else if (result.status == Status.completed) {
        final data = await Isolate.run(() => UserSubscriptionModel.fromJson(response.data['data']));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> startTrial(Map<String, dynamic> data, {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.postJson(
        AppApiPaths.startTrial,
        data,
        enableLocalPersistence: enableLocalPersistence,
      );
      final result = HandlingResponse.returnResponse(response);
      if (result.status == Status.processing) {
        return ApiResponse.processing("Starting trial...");
      } else if (result.status == Status.completed) {
        final data = await Isolate.run(() => UserSubscriptionModel.fromJson(response.data['data']));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> cancelSubscription(Map<String, dynamic> data, {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.postJson(
        AppApiPaths.cancelSubscription,
        data,
        enableLocalPersistence: enableLocalPersistence,
      );
      final result = HandlingResponse.returnResponse(response);
      if (result.status == Status.processing) {
        return ApiResponse.processing("Canceling subscription...");
      } else if (result.status == Status.completed) {
        final data = await Isolate.run(() => UserSubscriptionModel.fromJson(response.data['data']));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> getCurrentSubscription(String userId, {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.get(
        '${AppApiPaths.getCurrentSubscription}?userId=$userId',
        enableLocalPersistence: enableLocalPersistence,
      );
      final result = HandlingResponse.returnResponse(response);
      if (result.status == Status.processing) {
        return ApiResponse.processing("Fetching subscription...");
      } else if (result.status == Status.completed) {
        if (response.data['data'] != null) {
          final data = await Isolate.run(() => UserSubscriptionModel.fromJson(response.data['data']));
          return ApiResponse.completed(data);
        } else {
          return ApiResponse.completed(response.data['message'] ?? "No active subscription");
        }
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }

  @override
  Future<ApiResponse> checkGenerationLimits(String userId, String generationType, {bool enableLocalPersistence = false}) async {
    try {
      final response = await artleapApiService.get(
        '${AppApiPaths.checkGenerationLimits}?userId=$userId&generationType=$generationType',
        enableLocalPersistence: enableLocalPersistence,
      );
      final result = HandlingResponse.returnResponse(response);
      if (result.status == Status.processing) {
        return ApiResponse.processing("Checking limits...");
      } else if (result.status == Status.completed) {
        final data = await Isolate.run(() => GenerationLimitsModel.fromJson(response.data['data']));
        return ApiResponse.completed(data);
      } else {
        return result;
      }
    } on DioException catch (e) {
      return HandlingResponse.returnException(e);
    }
  }
}