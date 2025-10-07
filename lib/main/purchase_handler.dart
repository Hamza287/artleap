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
import '../presentation/views/subscriptions/payment_screen.dart';


class PurchaseHandler {
  final WidgetRef ref;

  PurchaseHandler(this.ref);

  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    final selectedPlan = ref.read(selectedPlanProvider);
    final basePlanId = selectedPlan?.basePlanId;
    final paymentMethod = ref.read(selectedPaymentMethodProvider);
    final userId = UserData.ins.userId;

    if (userId == null) {
      debugPrint('User ID not found');
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
    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        debugPrint('Purchase pending: ${purchaseDetails.productID}');
        // appSnackBar('Info', 'Purchase is pending', Colors.yellow);
        break;

      case PurchaseStatus.purchased:
        await _handleSuccessfulPurchase(purchaseDetails, basePlanId, paymentMethod, userId, success: true);
        break;

      case PurchaseStatus.restored:
        debugPrint('Purchase restored: ${purchaseDetails.productID}');
        await _handleSuccessfulPurchase(purchaseDetails, basePlanId, paymentMethod, userId, success: false);
        break;

      case PurchaseStatus.error:
        appSnackBar('Error', 'Purchase failed: ${purchaseDetails.error?.message ?? "Unknown error"}', Colors.red);
        ref.read(paymentLoadingProvider.notifier).state = false;
        break;

      case PurchaseStatus.canceled:
        // appSnackBar('Info', 'Purchase canceled', Colors.yellow);
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
      final verificationData = _createVerificationData(
        purchaseDetails,
        basePlanId,
        paymentMethod,
      );

      verificationData['success'] = success;

      final response = await subscriptionService.subscribe(
        userId,
        ref.read(selectedPlanProvider)?.id ?? '',
        paymentMethod ?? '',
        verificationData: verificationData,
      );

      if (response.status == Status.completed && success) {
        appSnackBar('Success', 'Subscription created successfully', Colors.green);
        await _completePurchase(purchaseDetails);
        ref.refresh(currentSubscriptionProvider(userId));
        ref.read(paymentLoadingProvider.notifier).state = false;
        navigatorKey.currentState?.pushReplacementNamed(BottomNavBar.routeName);
      } else {
        if (!success) {
          appSnackBar('Info', 'Subscription already active (restored)', Colors.blue);
        } else {
          appSnackBar('Error', 'Subscription failed', Colors.red);
        }
        ref.read(paymentLoadingProvider.notifier).state = false;
      }
    } catch (e) {
      appSnackBar('Error', 'Purchase error', Colors.red);
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }


  Map<String, dynamic> _createVerificationData(
      PurchaseDetails purchaseDetails,
      String? basePlanId,
      String? paymentMethod,
      ) {
    if (paymentMethod == 'apple') {
      return {
        'productId': purchaseDetails.productID,
        'receiptData': purchaseDetails.verificationData.serverVerificationData,
        'platform': 'ios',
        'amount': ref.read(selectedPlanProvider)?.price.toString() ?? '0',
      };
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
      debugPrint('Error extracting Android purchase amount: $e');
    }
    return '0';
  }

  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    } catch (e) {
      debugPrint("Error completing purchase");
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }
}