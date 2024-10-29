import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

final inAppPurchaseProvider = ChangeNotifierProvider<InAppPurchaseProvider>(
    (ref) => InAppPurchaseProvider());

class InAppPurchaseProvider extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  // Ensure the product ID matches exactly with the one set in the store
  static const String _kProductId = 'premium_upgrade'; // Update if necessary
  final Set<String> _productIds = {_kProductId};

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  bool _purchasePending = false;
  bool get purchasePending => _purchasePending;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  InAppPurchaseProvider() {
    _initialize();
  }

  void _initialize() {
    print('Initializing InAppPurchaseProvider...');
    // Set up purchase update listener
    _subscription = _inAppPurchase.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) => print('Purchase Updated Error: $error'),
    );

    // Fetch products from the store
    _getProducts();
  }

  Future<void> _getProducts() async {
    print('Fetching products...');
    _isAvailable = await _inAppPurchase.isAvailable();
    print('In-app purchases available: $_isAvailable');
    if (!_isAvailable) {
      print('In-app purchases not available.');
      notifyListeners();
      return;
    }

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_productIds);
    if (response.error != null) {
      print('Error fetching product details: ${response.error}');
      notifyListeners();
      return;
    }

    if (response.productDetails.isEmpty) {
      print('No products found.');
      notifyListeners();
      return;
    }

    _products = response.productDetails;
    print('Products fetched: $_products');
    notifyListeners();
  }

  void buyProduct(ProductDetails productDetails) {
    print('Initiating purchase for: ${productDetails.title}');
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      print('Purchase update received: $purchaseDetails');
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchasePending = true;
        notifyListeners();
      } else {
        if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _verifyPurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          print('Purchase Error: ${purchaseDetails.error}');
        }

        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }

        _purchasePending = false;
        notifyListeners();
      }
    }
  }

  void _verifyPurchase(PurchaseDetails purchaseDetails) {
    print('Verifying purchase: ${purchaseDetails.productID}');
    if (purchaseDetails.productID == _kProductId) {
      _isPremium = true;
      notifyListeners();
      print('Purchase verified, premium features unlocked.');
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
