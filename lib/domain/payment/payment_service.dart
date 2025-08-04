import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_service.dart';

class PaymentService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final SubscriptionService _subscriptionService;
  final String userId;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  PaymentService(this._subscriptionService, this.userId);

  // Initialize the plugin
  Future<bool> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception('In-app purchases not available');
    }
    return available;
  }

  // Query available products
  Future<List<ProductDetails>> getProducts(List<String> productIds) async {
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds.toSet());
    print(response.productDetails);
    if (response.notFoundIDs.isNotEmpty) {
      throw Exception('Some products not found: ${response.notFoundIDs}');
    }
    return response.productDetails;
  }

  // Purchase a subscription
  Future<ApiResponse> purchaseSubscription(
      String planId,
      String productId,
      String paymentMethod,
      ) async {
    try {
      // 1. Query the product
      final products = await getProducts([productId]);
      if (products.isEmpty) {
        return ApiResponse.error('Product not found');
      }

      // 2. Set up purchase stream listener
      _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
            (List<PurchaseDetails> purchaseDetailsList) {
          _handlePurchaseUpdates(purchaseDetailsList, planId, paymentMethod);
        },
        onError: (error) {
          print('Purchase stream error: $error');
        },
      );

      // 3. Make the purchase
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: products.first,
        applicationUserName: userId,
      );

      // 4. Start the purchase flow
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
      return ApiResponse.error(e.toString());
    }
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList,
      String planId,
      String paymentMethod,
      ) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print('Purchase pending');
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          try {
            // Platform-specific verification
            if (Platform.isAndroid) {
              final InAppPurchaseAndroidPlatformAddition androidAddition =
              _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
              await androidAddition.consumePurchase(purchaseDetails);
            } else if (Platform.isIOS) {
              // For iOS, we use completePurchase which is available on PurchaseDetails
              if (purchaseDetails.pendingCompletePurchase) {
                await _inAppPurchase.completePurchase(purchaseDetails);
              }
            }

            // Prepare verification data
            final verificationData = {
              'userId': userId,
              'planId': planId,
              'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
              'productId': purchaseDetails.productID,
              'transactionId': purchaseDetails.purchaseID,
              'platform': Platform.operatingSystem,
              'paymentMethod': paymentMethod,
            };

            // Verify with backend and create subscription
            await _subscriptionService.subscribe(
              userId,
              planId,
              paymentMethod,
              verificationData: verificationData,
            );

          } catch (e) {
            print('Error handling purchased status: $e');
          }
          break;

        case PurchaseStatus.error:
          print('Purchase error: ${purchaseDetails.error}');
          break;

        case PurchaseStatus.canceled:
          print('Purchase canceled');
          break;
      }
    }
  }

  // Restore purchases
  Future<ApiResponse> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      return ApiResponse.completed('Purchases restored successfully');
    } catch (e) {
      return ApiResponse.error('Failed to restore purchases: $e');
    }
  }

  // Dispose resources
  void dispose() {
    _purchaseSubscription?.cancel();
  }
}