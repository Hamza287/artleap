import 'dart:async';
import 'dart:convert';
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

    if (userId == null) {
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
    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        break;

      case PurchaseStatus.purchased:
        await _handleSuccessfulPurchase(purchaseDetails, basePlanId, paymentMethod, userId, true);
        break;

      case PurchaseStatus.restored:
        await _handleSuccessfulPurchase(purchaseDetails, basePlanId, paymentMethod, userId, false);
        break;

      case PurchaseStatus.error:
        appSnackBar('Error', 'Purchase failed: ${purchaseDetails.error?.message ?? "Unknown error"}', Colors.red);
        ref.read(paymentLoadingProvider.notifier).state = false;
        break;

      case PurchaseStatus.canceled:
        ref.read(paymentLoadingProvider.notifier).state = false;
        break;
    }
  }

  Future<void> _handleSuccessfulPurchase(
      PurchaseDetails purchaseDetails,
      String? basePlanId,
      String? paymentMethod,
      String userId,
      bool success) async {
    final subscriptionService = ref.read(subscriptionServiceProvider);

    try {
      String planId = '';
      if (!success) {
        planId = await _findPlanIdByProductId(purchaseDetails.productID) ?? '';
      } else {
        final selectedPlan = ref.read(selectedPlanProvider);
        planId = selectedPlan?.id ?? '';
      }

      if (planId.isEmpty) {
        appSnackBar('Error', 'Could not find subscription plan', Colors.red);
        ref.read(paymentLoadingProvider.notifier).state = false;
        await _completePurchase(purchaseDetails);
        return;
      }

      final selectedPlan = ref.read(selectedPlanProvider);
      final verificationData = _createVerificationData(
        purchaseDetails,
        basePlanId,
        paymentMethod,
        selectedPlan,
      );

      verificationData['success'] = success;

      final response = await subscriptionService.subscribe(
        userId,
        planId,
        paymentMethod ?? '',
        verificationData: verificationData,
      );

      if (response.status == Status.completed) {
        if (success) {
          appSnackBar('Success', 'Subscription created successfully', Colors.green);
          ref.read(paymentLoadingProvider.notifier).state = false;
          if (navigatorKey.currentState?.mounted == true) {
            navigatorKey.currentState?.pushReplacementNamed(BottomNavBar.routeName);
          }
        } else {
          appSnackBar('Success', 'Subscription restored successfully', Colors.green);
        }
        await _completePurchase(purchaseDetails);
        ref.refresh(currentSubscriptionProvider(userId));
      } else {
        appSnackBar('Error', 'Subscription failed: ${response.message}', Colors.red);
        ref.read(paymentLoadingProvider.notifier).state = false;
      }
    } catch (e) {
      appSnackBar('Error', 'Purchase processing failed', Colors.red);
      ref.read(paymentLoadingProvider.notifier).state = false;
      await _completePurchase(purchaseDetails);
    }
  }

  Future<String?> _findPlanIdByProductId(String productId) async {
    try {
      final subscriptionService = ref.read(subscriptionServiceProvider);
      final response = await subscriptionService.getSubscriptionPlans();

      if (response.status == Status.completed && response.data != null) {
        final plans = response.data as List<dynamic>;
        for (final plan in plans) {
          if (plan['appleProductId'] == productId || plan['googleProductId'] == productId) {
            return plan['id'];
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _createVerificationData(
      PurchaseDetails purchaseDetails,
      String? basePlanId,
      String? paymentMethod,
      selectedPlan,
      ) {
    if (paymentMethod == 'apple') {
      final receiptData = purchaseDetails.verificationData.serverVerificationData;
      Map<String, dynamic> appleData = {
        'productId': purchaseDetails.productID,
        'receiptData': receiptData,
        'platform': 'ios',
        'amount': selectedPlan?.price.toString() ?? '0',
      };

      try {
        final decodedReceipt = _decodeAppleReceipt(receiptData);
        if (decodedReceipt['originalTransactionId'] != null) {
          appleData['originalTransactionId'] = decodedReceipt['originalTransactionId'];
          appleData['transactionId'] = decodedReceipt['transactionId'];
        }
      } catch (e) {
        appleData['transactionId'] = purchaseDetails.purchaseID;
      }

      return appleData;
    } else {
      return {
        'productId': purchaseDetails.productID,
        'basePlanId': basePlanId,
        'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
        'transactionId': purchaseDetails.purchaseID ?? '',
        'platform': 'android',
        'amount': _extractAndroidPurchaseAmount(purchaseDetails),
      };
    }
  }

  Map<String, dynamic> _decodeAppleReceipt(String receiptData) {
    try {
      // For JWT format receipts (iOS 7+)
      if (receiptData.startsWith("eyJ")) {
        final parts = receiptData.split(".");
        if (parts.length == 3) {
          final payload = utf8.decode(base64.decode(parts[1]));
          final decoded = json.decode(payload);
          return {
            'transactionId': decoded['transactionId'],
            'originalTransactionId': decoded['originalTransactionId'],
          };
        }
      }
    } catch (e) {
      print('Error decoding Apple receipt: $e');
    }
    return {};
  }

  String _extractAndroidPurchaseAmount(PurchaseDetails purchaseDetails) {
    try {
      if (purchaseDetails.verificationData.localVerificationData.contains('price_amount_micros')) {
        return (int.parse(purchaseDetails
            .verificationData.localVerificationData
            .split('"price_amount_micros":')[1]
            .split(',')[0]) /
            1000000)
            .toString();
      }
    } catch (e) {
    }
    final selectedPlan = ref.read(selectedPlanProvider);
    return selectedPlan?.price.toString() ?? '0';
  }

  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    } catch (e) {
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }
}