import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_service.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_api_paths.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_services/handling_response.dart';

class StripeService {
  static Future<String?> createPaymentIntent({
    required int amount,
    required String currency,
    required String userId,
    required String planId,
    required Dio dio,
  }) async {
    try {
      final response = await dio.post(
        AppApiPaths.createPaymentIntent,
        data: {
          'amount': amount,
          'currency': currency,
          'userId': userId,
          'planId': planId,
        },
      );

      return HandlingResponse.returnResponse<Map<String, dynamic>>(
        response,
        fromJson: (json) => json as Map<String, dynamic>,
      ).data?['clientSecret'];
    } on DioException catch (e) {
      print('Error creating Payment Intent: ${e.message}');
      return null;
    }
  }

  // Process a Stripe payment
  static Future<ApiResponse> purchaseSubscription({
    required String planId,
    required int amount, // Amount in cents
    required String currency,
    required String userId,
    required SubscriptionService subscriptionService,
    required BuildContext context,
    required WidgetRef ref,
    required Dio dio,
  }) async {
    try {
      // Create Payment Intent
      final clientSecret = await createPaymentIntent(
        amount: amount,
        currency: currency,
        userId: userId,
        planId: planId,
        dio: dio,
      );

      if (clientSecret == null) {
        appSnackBar('Error', 'Failed to initialize payment', Colors.red);
        return ApiResponse.error('Failed to initialize payment');
      }

      // Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Artleap.ai',
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true, // Set to false in production
          ),
          style: ThemeMode.system,
        ),
      );

      // Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // Extract paymentIntentId from clientSecret
      final paymentIntentId = clientSecret.split('_secret_')[0];

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

      return response;
    } catch (e) {
      print('Stripe purchase error: $e');
      appSnackBar('Error', 'Purchase error: $e', Colors.red);
      return ApiResponse.error('Purchase error: $e');
    }
  }
}