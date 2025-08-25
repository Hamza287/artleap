import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_provider.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';

import '../../presentation/views/subscriptions/payment_screen.dart';
import '../api_services/api_response.dart';

// Provider for Apple payment service
final applePaymentServiceProvider = Provider.family<ApplePaymentService, String>((ref, userId) {
  return ApplePaymentService(ref, userId);
});

class ApplePaymentService {
  final Ref ref;
  final String userId;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  ApplePaymentService(this.ref, this.userId);

  Future<bool> initialize() async {
    try {
      final bool available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        appSnackBar('Error', 'In-app purchases not available on iOS', Colors.red);
        return false;
      }
      return true;
    } catch (e) {
      appSnackBar('Error', 'Failed to initialize App Store payment service: $e', Colors.red);
      return false;
    }
  }

  Future<bool> purchaseSubscription(SubscriptionPlanModel plan, BuildContext context) async {
    try {
      if (userId.isEmpty) {
        appSnackBar('Error', 'User not authenticated', Colors.red);
        return false;
      }

      if (plan.appleProductId.isEmpty) {
        appSnackBar('Error', 'Invalid App Store product ID', Colors.red);
        return false;
      }

      final ProductDetailsResponse response =
      await InAppPurchase.instance.queryProductDetails({plan.appleProductId});

// Debugging logs
      debugPrint("🔍 IAP Debugging:");
      debugPrint("  Requested ID: ${plan.appleProductId}");
      debugPrint("  Not found IDs: ${response.notFoundIDs}");
      debugPrint("  Product details count: ${response.productDetails.length}");
      for (final product in response.productDetails) {
        debugPrint("  ✅ Found product: "
            "id=${product.id}, "
            "title=${product.title}, "
            "price=${product.price}, "
            "currency=${product.currencyCode}");
      }

      if (response.error != null) {
        debugPrint("  ❌ StoreKit error: ${response.error!.message} "
            "(code: ${response.error!.code})");
      }

      if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
        appSnackBar('Error', 'Plan not available on App Store', Colors.red);
        return false;
      }


      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      final bool purchaseInitiated = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

      if (!purchaseInitiated) {
        appSnackBar('Error', 'Failed to initiate App Store purchase', Colors.red);
        return false;
      }

      return true;
    } catch (e) {
      appSnackBar('Error', 'App Store purchase error: $e', Colors.red);
      return false;
    }
  }

  void listenToPurchaseUpdates(BuildContext context, SubscriptionPlanModel plan) {
    _purchaseSubscription?.cancel();
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
          (purchaseDetailsList) async {
        for (final purchaseDetails in purchaseDetailsList) {
          switch (purchaseDetails.status) {
            case PurchaseStatus.pending:
              appSnackBar('Info', 'App Store purchase is pending', Colors.yellow);
              break;
            case PurchaseStatus.purchased:
            case PurchaseStatus.restored:
              await _handlePurchaseSuccess(purchaseDetails, plan, context);
              break;
            case PurchaseStatus.error:
              ref.read(paymentLoadingProvider.notifier).state = false;
              appSnackBar(
                'Error',
                'App Store purchase error: ${purchaseDetails.error?.message ?? "Unknown error"}',
                Colors.red,
              );
              await InAppPurchase.instance.completePurchase(purchaseDetails);
              break;
            case PurchaseStatus.canceled:
              ref.read(paymentLoadingProvider.notifier).state = false;
              appSnackBar('Info', 'App Store purchase canceled', Colors.yellow);
              await InAppPurchase.instance.completePurchase(purchaseDetails);
              break;
          }
        }
      },
      onError: (error) {
        ref.read(paymentLoadingProvider.notifier).state = false;
        appSnackBar('Error', 'App Store purchase stream error: $error', Colors.red);
      },
    );
  }

  Future<void> _handlePurchaseSuccess(
      PurchaseDetails purchaseDetails, SubscriptionPlanModel plan, BuildContext context) async {
    try {
      final subscriptionService = ref.read(subscriptionServiceProvider);
      final response = await subscriptionService.subscribe(
        userId,
        plan.id,
        'apple',
        verificationData: {
          'productId': purchaseDetails.productID,
          'receiptData': purchaseDetails.verificationData.serverVerificationData,
          'transactionId': purchaseDetails.purchaseID ?? '',
          'platform': 'ios',
          'amount': plan.price.toString(),
        },
      );

      if (response.status == Status.completed) {
        appSnackBar('Success', 'Subscription created successfully', Colors.green);
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        ref.refresh(currentSubscriptionProvider(userId));
        ref.read(paymentLoadingProvider.notifier).state = false;
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
        }
      } else {
        appSnackBar('Error', response.message ?? 'App Store subscription failed', Colors.red);
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        ref.read(paymentLoadingProvider.notifier).state = false;
      }
    } catch (e) {
      appSnackBar('Error', 'Error processing App Store purchase: $e', Colors.red);
      await InAppPurchase.instance.completePurchase(purchaseDetails);
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }

  void dispose() {
    _purchaseSubscription?.cancel();
  }
}