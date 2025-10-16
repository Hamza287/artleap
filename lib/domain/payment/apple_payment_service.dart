import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_provider.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';

import '../../presentation/views/subscriptions/google_payment_screen.dart';
import '../api_services/api_response.dart';

// Provider for Apple payment service
final applePaymentServiceProvider = Provider.family<ApplePaymentService, String>((ref, userId) {
  return ApplePaymentService(ref, userId);
});

class ApplePaymentService {
  final Ref ref;
  final String userId;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Completer<bool>? _purchaseCompleter;
  SubscriptionPlanModel? _currentPlan;
  BuildContext? _currentContext;

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

      // Initialize purchase completer
      _purchaseCompleter = Completer<bool>();
      _currentPlan = plan;
      _currentContext = context;

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
        _purchaseCompleter?.complete(false);
        _cleanup();
        return false;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

      // Start listening to purchase updates before initiating purchase
      _listenToPurchaseUpdates();

      final bool purchaseInitiated = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

      if (!purchaseInitiated) {
        // appSnackBar('Error', 'Failed to initiate App Store purchase', Colors.red);
        _purchaseCompleter?.complete(false);
        _cleanup();
        return false;
      }

      // Wait for the purchase to complete (success or failure)
      final bool success = await _purchaseCompleter!.future;
      return success;
    } catch (e) {
      // appSnackBar('Error', 'App Store purchase error: $e', Colors.red);
      _purchaseCompleter?.complete(false);
      _cleanup();
      return false;
    }
  }

  void _listenToPurchaseUpdates() {
    _purchaseSubscription?.cancel();
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
          (purchaseDetailsList) async {
        for (final purchaseDetails in purchaseDetailsList) {
          if (_currentPlan != null && purchaseDetails.productID == _currentPlan!.appleProductId) {
            await _handlePurchaseUpdate(purchaseDetails);
          }
        }
      },
      onError: (error) {
        ref.read(paymentLoadingProvider.notifier).state = false;
        // appSnackBar('Error', 'App Store purchase stream error: $error', Colors.red);
        _purchaseCompleter?.complete(false);
        _cleanup();
      },
    );
  }

  Future<void> _handlePurchaseUpdate(PurchaseDetails purchaseDetails) async {
    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        appSnackBar('Info', 'App Store purchase is pending', Colors.yellow);
        break;

      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        await _handlePurchaseSuccess(purchaseDetails);
        break;

      case PurchaseStatus.error:
        ref.read(paymentLoadingProvider.notifier).state = false;
        // appSnackBar(
        //   'Error',
        //   'App Store purchase error: ${purchaseDetails.error?.message ?? "Unknown error"}',
        //   Colors.red,
        // );
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        _purchaseCompleter?.complete(false);
        _cleanup();
        break;

      case PurchaseStatus.canceled:
        ref.read(paymentLoadingProvider.notifier).state = false;
        // appSnackBar('Info', 'App Store purchase canceled', Colors.yellow);
        final subscriptionService = ref.read(subscriptionServiceProvider);
        await subscriptionService.subscribe(
          userId,
          _currentPlan?.id ?? '',
          'apple',
          verificationData: {
            'platform': 'ios',
            'success': false,
          },
        );

        await InAppPurchase.instance.completePurchase(purchaseDetails);
        _purchaseCompleter?.complete(false);
        _cleanup();
        break;
    }
  }

  Future<void> _handlePurchaseSuccess(PurchaseDetails purchaseDetails) async {
    try {
      if (_currentPlan == null || _currentContext == null) {
        debugPrint('Error: Current plan or context is null');
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        _purchaseCompleter?.complete(false);
        _cleanup();
        return;
      }

      final subscriptionService = ref.read(subscriptionServiceProvider);
      final response = await subscriptionService.subscribe(
        userId,
        _currentPlan!.id,
        'apple',
        verificationData: {
          'productId': purchaseDetails.productID,
          'receiptData': purchaseDetails.verificationData.serverVerificationData,
          'platform': 'ios',
          'amount': _currentPlan!.price.toString(),
          'success': true,
        },
      );

      if (response.status == Status.completed) {
        appSnackBar('Success', 'Subscription created successfully', Colors.green);
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        ref.refresh(currentSubscriptionProvider(userId));
        ref.read(paymentLoadingProvider.notifier).state = false;

        _purchaseCompleter?.complete(true);

        if (_currentContext!.mounted) {
          Navigator.pushReplacementNamed(_currentContext!, BottomNavBar.routeName);
        }
      } else {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        ref.read(paymentLoadingProvider.notifier).state = false;
        _purchaseCompleter?.complete(false);
      }
    } catch (e) {
      appSnackBar('Error', 'Error processing App Store purchase: $e', Colors.red);
      await InAppPurchase.instance.completePurchase(purchaseDetails);
      ref.read(paymentLoadingProvider.notifier).state = false;
      _purchaseCompleter?.complete(false);
    } finally {
      _cleanup();
    }
  }


  void _cleanup() {
    _purchaseSubscription?.cancel();
    _purchaseCompleter = null;
    _currentPlan = null;
    _currentContext = null;
  }

  void cancelPurchase() {
    ref.read(paymentLoadingProvider.notifier).state = false;
    _purchaseCompleter?.complete(false);
    _cleanup();
  }

  void dispose() {
    _cleanup();
  }
}