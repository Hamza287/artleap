import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_service.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_api_paths.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_services/handling_response.dart';
import '../base_repo/base.dart';

class StripeService {
  final Base _base;

  StripeService(this._base);

  Future<ApiResponse<String?>> createPaymentIntent({
    required int amount,
    required String currency,
    required String userId,
    required String planId,
    bool enableLocalPersistence = false,
  }) async {
    try {
      final response = await _base.artleapApiService.postJson(
        AppApiPaths.createPaymentIntent,
        {
          'amount': amount,
          'currency': currency,
          'userId': userId,
          'planId': planId,
        },
        enableLocalPersistence: enableLocalPersistence,
      );
      print(response);
      return HandlingResponse.returnResponse<String?>(
        response,
        fromJson: (json) => (json as Map<String, dynamic>)['clientSecret'] as String?,
      );
    } on DioException catch (e) {
      return HandlingResponse.returnException<String?>(e);
    }
  }

  Future<ApiResponse> purchaseSubscription({
    required String planId,
    required int amount, // Amount in cents
    required String currency,
    required String userId,
    required SubscriptionService subscriptionService,
    required BuildContext context,
    required WidgetRef ref,
    bool enableLocalPersistence = false,
  }) async {
    try {
      // Create Payment Intent
      final clientSecretResponse = await createPaymentIntent(
        amount: amount,
        currency: currency,
        userId: userId,
        planId: planId,
        enableLocalPersistence: enableLocalPersistence,
      );
      print(clientSecretResponse);
      if (clientSecretResponse.status != Status.completed || clientSecretResponse.data == null) {
        appSnackBar('Error','Failed to initialize payment', Colors.red);
        return ApiResponse.error(clientSecretResponse.message ?? 'Failed to initialize payment');
      }

      final clientSecret = clientSecretResponse.data;

      // Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Artleap.ai',
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: false, // Set to false in production
          ),
          style: ThemeMode.system,
        ),
      );

      // Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // Extract paymentIntentId from clientSecret
      final paymentIntentId = clientSecret!.split('_secret_')[0];

      // Prepare verification data for backend
      final verificationData = {
        'paymentIntentId': paymentIntentId,
        'amount': amount / 100,
        'platform': 'stripe',
        'planId': planId,
      };

      // Call backend to verify and create subscription
      final response = await subscriptionService.subscribe(
        userId,
        planId,
        'stripe',
        verificationData: verificationData,
      );

      if (response.status == Status.completed) {
        appSnackBar('Success', 'Subscription purchased successfully', Colors.green);
      } else {
        appSnackBar('Error', 'Failed to create subscription', Colors.red);
      }

      return response;
    } on StripeException catch (e) {
      // ✅ Handle cancellation separately
      if (e.error.code == FailureCode.Canceled) {
        // appSnackBar('Info', 'Purchase was canceled', Colors.orange);
        return ApiResponse.error('User canceled the purchase');
      } else {
        appSnackBar('Error', 'Stripe error', Colors.red);
        return ApiResponse.error('Stripe error');
      }
    } catch (e) {
      appSnackBar('Error', 'Purchase error', Colors.red);
      return ApiResponse.error('Purchase error');
    }
  }

}