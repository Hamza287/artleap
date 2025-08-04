import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


final paymentLoadingProvider = StateProvider<bool>((ref) => false);
final termsAcceptedProvider = StateProvider<bool>((ref) => false);

class PaymentScreen extends ConsumerStatefulWidget {
  static const String routeName = "payment_screen";
  final SubscriptionPlanModel plan;

  const PaymentScreen({super.key, required this.plan});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isInitialized = false;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchase();
    _listenToPurchaseUpdates();
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeInAppPurchase() async {
    try {
      final bool available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        if (mounted) {
          appSnackBar('Error', 'In-app purchases not available', Colors.red);
        }
        return;
      }
      setState(() => _isInitialized = true);
    } catch (e) {
      if (mounted) {
        appSnackBar('Error', 'Failed to initialize payment service: $e', Colors.red);
      }
    }
  }

  void _listenToPurchaseUpdates() {
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
          (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onError: (error) {
        ref.read(paymentLoadingProvider.notifier).state = false;
        if (mounted) {
          appSnackBar('Error', 'Purchase error: $error', Colors.red);
        }
      },
    );
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
        // Purchase is pending - no action needed
          break;
        case PurchaseStatus.canceled:
          ref.read(paymentLoadingProvider.notifier).state = false;
          if (mounted) {
            appSnackBar('Info', 'Purchase was canceled', Colors.orange);
          }
          break;
        case PurchaseStatus.error:
          ref.read(paymentLoadingProvider.notifier).state = false;
          if (mounted) {
            appSnackBar(
                'Error',
                'Purchase error: ${purchaseDetails.error?.message ?? "Unknown error"}',
                Colors.red
            );
          }
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
        // Success case - handled by your main purchase stream
          break;
      }
    }
  }

  Future<void> _handleSubscription() async {
    if (!_isInitialized) {
      appSnackBar('Error', 'Payment service not initialized', Colors.red);
      return;
    }

    if (!ref.read(termsAcceptedProvider)) {
      appSnackBar('Error', 'Please accept the terms and conditions', Colors.red);
      return;
    }

    ref.read(paymentLoadingProvider.notifier).state = true;

    try {
      final productId = widget.plan.googleProductId;
      final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails({productId});

      if (response.notFoundIDs.isNotEmpty) {
        if (mounted) {
          appSnackBar('Error', 'Plan not available', Colors.red);
        }
        ref.read(paymentLoadingProvider.notifier).state = false;
        return;
      }

      if (response.productDetails.isEmpty) {
        if (mounted) {
          appSnackBar('Error', 'No product details found', Colors.red);
        }
        ref.read(paymentLoadingProvider.notifier).state = false;
        return;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      final bool purchaseInitiated = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

      if (!purchaseInitiated && mounted) {
        appSnackBar('Error', 'Failed to initiate purchase', Colors.red);
        ref.read(paymentLoadingProvider.notifier).state = false;
      }
    } catch (e) {
      if (mounted) {
        appSnackBar('Error', 'Purchase error: $e', Colors.red);
      }
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }

  String _getPlanPeriod(String type) {
    switch (type.toLowerCase()) {
      case 'basic':
        return 'week';
      case 'standard':
        return 'month';
      case 'premium':
        return 'year';
      case 'trial':
        return 'trial';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(paymentLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Purchase',
          style: AppTextstyle.interBold(fontSize: 20, color: AppColors.darkBlue),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan details container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.purple.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.plan.name,
                          style: AppTextstyle.interBold(
                            fontSize: 20,
                            color: AppColors.purple,
                          ),
                        ),
                        Text(
                          '\$${widget.plan.price.toStringAsFixed(2)}/${_getPlanPeriod(widget.plan.type)}',
                          style: AppTextstyle.interBold(
                            fontSize: 20,
                            color: AppColors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Product ID: ${widget.plan.googleProductId}',
                      style: AppTextstyle.interRegular(
                        fontSize: 14,
                        color: AppColors.darkBlue.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...widget.plan.features.take(3).map((feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check, size: 16, color: AppColors.purple),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextstyle.interRegular(
                                fontSize: 14,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Payment Method',
                style: AppTextstyle.interBold(
                  fontSize: 18,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 16),
              // Payment method tile
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.purple,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.android, size: 24, color: AppColors.purple),
                    const SizedBox(width: 16),
                    Text(
                      'Google Pay',
                      style: AppTextstyle.interMedium(
                        fontSize: 16,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Terms checkbox
              Row(
                children: [
                  Checkbox(
                    value: ref.watch(termsAcceptedProvider),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(termsAcceptedProvider.notifier).state = value;
                      }
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I agree to the ',
                        style: AppTextstyle.interRegular(
                          fontSize: 14,
                          color: AppColors.darkBlue,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: AppTextstyle.interMedium(
                              fontSize: 14,
                              color: AppColors.blue,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppTextstyle.interMedium(
                              fontSize: 14,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Subscribe button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (!_isInitialized || isLoading || !ref.read(termsAcceptedProvider))
                      ? null
                      : _handleSubscription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColors.purple.withOpacity(0.5),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Subscribe Now',
                    style: AppTextstyle.interBold(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}