import 'dart:async';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_provider.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../domain/api_services/api_response.dart';
import '../domain/subscriptions/plan_provider.dart';
import '../presentation/views/subscriptions/google_payment_screen.dart';

class PurchaseHandler {
  final WidgetRef ref;

  PurchaseHandler(this.ref);

  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    final selectedPlan = ref.read(selectedPlanProvider);
    final basePlanId = selectedPlan?.basePlanId;
    final paymentMethod = ref.read(selectedPaymentMethodProvider);
    final userId = UserData.ins.userId;

    debugPrint('[PurchaseHandler] handlePurchaseUpdates started');
    debugPrint('[PurchaseHandler] User ID: $userId');
    debugPrint('[PurchaseHandler] Selected Plan: ${selectedPlan?.id}');
    debugPrint('[PurchaseHandler] Base Plan ID: $basePlanId');
    debugPrint('[PurchaseHandler] Payment Method: $paymentMethod');

    if (userId == null) {
      debugPrint('[PurchaseHandler] User ID not found');
      appSnackBar('Error', 'User not authenticated', Colors.red);
      for (final purchaseDetails in purchaseDetailsList) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
      return;
    }

    for (final purchaseDetails in purchaseDetailsList) {
      await _processPurchase(purchaseDetails, basePlanId, paymentMethod, userId);
    }
  }

  Future<void> _processPurchase(
      PurchaseDetails purchaseDetails,
      String? basePlanId,
      String? paymentMethod,
      String userId,
      ) async {
    debugPrint('[PurchaseHandler] _processPurchase started for product: ${purchaseDetails.productID}');
    debugPrint('[PurchaseHandler] Purchase status: ${purchaseDetails.status}');

    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        debugPrint('[PurchaseHandler] Purchase pending: ${purchaseDetails.productID}');
        break;

      case PurchaseStatus.purchased:
        debugPrint('[PurchaseHandler] Purchase successful: ${purchaseDetails.productID}');
        await _handleSuccessfulPurchase(purchaseDetails, basePlanId, paymentMethod, userId, success: true);
        break;

      case PurchaseStatus.restored:
        debugPrint('[PurchaseHandler] Purchase restored: ${purchaseDetails.productID}');
        await _handleSuccessfulPurchase(purchaseDetails, basePlanId, paymentMethod, userId, success: false);
        break;

      case PurchaseStatus.error:
        debugPrint('[PurchaseHandler] Purchase error: ${purchaseDetails.error?.message}');
        appSnackBar('Error', 'Purchase failed: ${purchaseDetails.error?.message ?? "Unknown error"}', Colors.red);
        ref.read(paymentLoadingProvider.notifier).state = false;
        break;

      case PurchaseStatus.canceled:
        debugPrint('[PurchaseHandler] Purchase canceled: ${purchaseDetails.productID}');
        ref.read(paymentLoadingProvider.notifier).state = false;
        break;
    }
  }

  Future<void> _handleSuccessfulPurchase(
      PurchaseDetails purchaseDetails,
      String? basePlanId,
      String? paymentMethod,
      String userId,
      {required bool success}
      ) async {
    final subscriptionService = ref.read(subscriptionServiceProvider);

    try {
      debugPrint('[PurchaseHandler] Creating verification data');
      final verificationData = _createVerificationData(
        purchaseDetails,
        basePlanId,
        paymentMethod,
      );

      verificationData['success'] = success;

      debugPrint('[PurchaseHandler] Verification data: $verificationData');
      debugPrint('[PurchaseHandler] Plan ID being sent: ${ref.read(selectedPlanProvider)?.id}');

      final response = await subscriptionService.subscribe(
        userId,
        ref.read(selectedPlanProvider)?.id ?? '',
        paymentMethod ?? '',
        verificationData: verificationData,
      );

      debugPrint('[PurchaseHandler] Subscription API response status: ${response.status}');
      debugPrint('[PurchaseHandler] Subscription API response message: ${response.message}');

      if (response.status == Status.completed && success) {
        debugPrint('[PurchaseHandler] Subscription created successfully');
        appSnackBar('Success', 'Subscription created successfully', Colors.green);
        await _completePurchase(purchaseDetails);
        ref.refresh(currentSubscriptionProvider(userId));
        ref.read(paymentLoadingProvider.notifier).state = false;
        navigatorKey.currentState?.pushReplacementNamed(BottomNavBar.routeName);
      } else {
        debugPrint('[PurchaseHandler] Subscription failed or already active');
        if (!success) {
          appSnackBar('Info', 'Subscription already active (restored)', Colors.blue);
        } else {
          appSnackBar('Error', 'Subscription failed: ${response.message}', Colors.red);
          await _reversePayment(purchaseDetails, paymentMethod);
        }
        ref.read(paymentLoadingProvider.notifier).state = false;
      }
    } catch (e) {
      debugPrint('[PurchaseHandler] Exception in _handleSuccessfulPurchase: $e');
      appSnackBar('Error', 'Purchase error: $e', Colors.red);
      await _reversePayment(purchaseDetails, paymentMethod);
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _reversePayment(PurchaseDetails purchaseDetails, String? paymentMethod) async {
    try {
      debugPrint('[PurchaseHandler] Attempting to reverse payment for: ${purchaseDetails.productID}');

      if (paymentMethod == 'apple') {
        await _reverseApplePayment(purchaseDetails);
      } else {
        await _reverseGooglePayment(purchaseDetails);
      }

      debugPrint('[PurchaseHandler] Payment reversal completed');
    } catch (e) {
      debugPrint('[PurchaseHandler] Error reversing payment: $e');
      appSnackBar('Error', 'Failed to reverse payment. Please contact support.', Colors.red);
    }
  }

  Future<void> _reverseApplePayment(PurchaseDetails purchaseDetails) async {
    try {
      debugPrint('[PurchaseHandler] Reversing Apple payment');
      final iapConnection = InAppPurchase.instance;

      if (purchaseDetails.pendingCompletePurchase) {
        await iapConnection.completePurchase(purchaseDetails);
      }

    } catch (e) {
      debugPrint('[PurchaseHandler] Error reversing Apple payment: $e');
      rethrow;
    }
  }

  Future<void> _reverseGooglePayment(PurchaseDetails purchaseDetails) async {
    try {
      debugPrint('[PurchaseHandler] Reversing Google payment');
      final iapConnection = InAppPurchase.instance;

      if (purchaseDetails.pendingCompletePurchase) {
        await iapConnection.completePurchase(purchaseDetails);
      }

    } catch (e) {
      debugPrint('[PurchaseHandler] Error reversing Google payment: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _createVerificationData(
      PurchaseDetails purchaseDetails,
      String? basePlanId,
      String? paymentMethod,
      ) {
    debugPrint('[PurchaseHandler] _createVerificationData for payment method: $paymentMethod');

    if (paymentMethod == 'apple') {
      final data = {
        'productId': purchaseDetails.productID,
        'receiptData': purchaseDetails.verificationData.serverVerificationData,
        'platform': 'ios',
        'amount': ref.read(selectedPlanProvider)?.price.toString() ?? '0',
      };
      debugPrint('[PurchaseHandler] Apple verification data created: $data');
      return data;
    } else {
      final data = {
        'productId': purchaseDetails.productID,
        'basePlanId': basePlanId,
        'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
        'transactionId': purchaseDetails.purchaseID ?? '',
        'platform': 'android',
        'amount': _extractAndroidPurchaseAmount(purchaseDetails),
      };
      debugPrint('[PurchaseHandler] Google verification data created: $data');
      return data;
    }
  }

  String _extractAndroidPurchaseAmount(PurchaseDetails purchaseDetails) {
    try {
      debugPrint('[PurchaseHandler] Extracting Android purchase amount');
      if (purchaseDetails.verificationData.localVerificationData.contains('price_amount_micros')) {
        final amount = (int.parse(purchaseDetails
            .verificationData.localVerificationData
            .split('"price_amount_micros":')[1]
            .split(',')[0]) /
            1000000)
            .toString();
        debugPrint('[PurchaseHandler] Extracted Android amount: $amount');
        return amount;
      }
    } catch (e) {
      debugPrint('[PurchaseHandler] Error extracting Android purchase amount: $e');
    }
    debugPrint('[PurchaseHandler] Using default Android amount: 0');
    return '0';
  }

  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      debugPrint('[PurchaseHandler] Completing purchase: ${purchaseDetails.productID}');
      await InAppPurchase.instance.completePurchase(purchaseDetails);
      debugPrint('[PurchaseHandler] Purchase completed successfully');
    } catch (e) {
      debugPrint("[PurchaseHandler] Error completing purchase: $e");
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }
}