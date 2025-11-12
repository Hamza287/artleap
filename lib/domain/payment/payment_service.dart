import 'dart:async';
import 'dart:io';
import 'package:Artleap.ai/domain/payment/stripe_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import '../../shared/theme/app_colors.dart';
import '../base_repo/base.dart';

class PaymentService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final SubscriptionService _subscriptionService;
  final Base _base;
  final String userId;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  PaymentService(this._subscriptionService, this._base, this.userId);

  Future<bool> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception('In-app purchases not available');
    }
    return available;
  }

  Future<List<ProductDetails>> getProducts(List<String> productIds) async {
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds.toSet());
    print(response.productDetails);
    if (response.notFoundIDs.isNotEmpty) {
      throw Exception('Some products not found: ${response.notFoundIDs}');
    }
    return response.productDetails;
  }

  Future<ApiResponse> purchaseSubscription(
      String planId,
      String productId,
      String paymentMethod,
      ) async {
    try {
      final products = await getProducts([productId]);
      if (products.isEmpty) {
        appSnackBar('Error', 'Product not found', backgroundColor:AppColors.red);
        return ApiResponse.error('Product not found');
      }

      _purchaseSubscription?.cancel();
      _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
            (List<PurchaseDetails> purchaseDetailsList) {
          _handlePurchaseUpdates(purchaseDetailsList, planId, paymentMethod);
        },
        onError: (error) {
          appSnackBar('Error', 'Purchase stream error: $error', backgroundColor:AppColors.red);
        },
      );

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: products.first,
        applicationUserName: userId,
      );

      if (Platform.isAndroid) {
        await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: true,
        );
      } else if (Platform.isIOS) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }

      return ApiResponse.processing('Purchase initiated');
    } catch (e) {
      _purchaseSubscription?.cancel();
      appSnackBar('Error', 'Purchase error', backgroundColor:AppColors.red);
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse> purchaseStripeSubscription({
    required String planId,
    required int amount,
    required String currency,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final stripeService = StripeService(_base);
    return await stripeService.purchaseSubscription(
      planId: planId,
      amount: amount,
      currency: currency,
      userId: userId,
      subscriptionService: _subscriptionService,
      context: context,
      ref: ref,
      enableLocalPersistence: false,
    );
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList,
      String planId,
      String paymentMethod,
      ) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          appSnackBar('Info', 'Purchase is pending', backgroundColor:AppColors.red);
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          try {
            if (Platform.isAndroid) {
              final InAppPurchaseAndroidPlatformAddition androidAddition =
              _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
              await androidAddition.consumePurchase(purchaseDetails);
            } else if (Platform.isIOS) {
              if (purchaseDetails.pendingCompletePurchase) {
                await _inAppPurchase.completePurchase(purchaseDetails);
              }
            }
            final verificationData = {
              'userId': userId,
              'planId': planId,
              'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
              'productId': purchaseDetails.productID,
              'transactionId': purchaseDetails.purchaseID,
              'platform': Platform.operatingSystem,
              'paymentMethod': paymentMethod,
            };
            final response = await _subscriptionService.subscribe(
              userId,
              planId,
              paymentMethod,
              verificationData: verificationData,
            );

            if (response.status == Status.completed) {
              appSnackBar('Success', 'Subscription purchased successfully', backgroundColor:AppColors.green);
            } else {
              appSnackBar('Error', 'Failed to create subscription', backgroundColor:AppColors.red);
            }
          } catch (e) {
            appSnackBar('Error', 'Error processing purchase', backgroundColor:AppColors.red);
          }
          break;

        case PurchaseStatus.error:
          appSnackBar('Error', 'Purchase error', backgroundColor:AppColors.red);
          break;

        case PurchaseStatus.canceled:
          break;
      }
    }
  }

  // Restore purchases
  Future<ApiResponse> restorePurchases(BuildContext context) async {
    try {
      await _inAppPurchase.restorePurchases();
      appSnackBar('Success', 'Purchases restored successfully', backgroundColor:AppColors.green);
      return ApiResponse.completed('Purchases restored successfully');
    } catch (e) {
      appSnackBar('Error', 'Failed to restore purchases', backgroundColor:AppColors.red);
      return ApiResponse.error('Failed to restore purchases: $e');
    }
  }

  void dispose() {
    _purchaseSubscription?.cancel();
  }
}