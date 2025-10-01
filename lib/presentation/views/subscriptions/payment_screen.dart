import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/domain/subscriptions/plan_provider.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../domain/api_services/api_response.dart';

final paymentLoadingProvider = StateProvider<bool>((ref) => false);
final termsAcceptedProvider = StateProvider<bool>((ref) => false);
final selectedPaymentMethodProvider = StateProvider<String>((ref) => 'google_play');
final inAppPurchaseInitializedProvider = StateProvider<bool>((ref) => false);

class PaymentScreen extends ConsumerStatefulWidget {
  static const String routeName = "payment_screen";
  final SubscriptionPlanModel plan;

  const PaymentScreen({super.key, required this.plan});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
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
      ref.read(inAppPurchaseInitializedProvider.notifier).state = true;
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

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;

        case PurchaseStatus.canceled:
          ref.read(paymentLoadingProvider.notifier).state = false;
          if (mounted) print('Purchased Cancelled');
          // if (mounted) appSnackBar('Info', 'Purchase was canceled', Colors.orange);
          break;

        case PurchaseStatus.error:
          ref.read(paymentLoadingProvider.notifier).state = false;
          if (mounted) {
            appSnackBar(
              'Error',
              'Purchase error: ${purchaseDetails.error?.message ?? "Unknown error"}',
              Colors.red,
            );
          }
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          ref.read(paymentLoadingProvider.notifier).state = true;
          try {
            final userId = UserData.ins.userId;
            if (userId != null) {
              await ref.read(currentSubscriptionProvider(userId).future);
            }

            if (mounted) {
              ref.read(paymentLoadingProvider.notifier).state = false;
              appSnackBar('Success', 'Subscription activated', Colors.green);
              // Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
            }
          } catch (e) {
            if (mounted) {
              ref.read(paymentLoadingProvider.notifier).state = false;
              appSnackBar('Error', 'Failed to verify subscription', Colors.red);
            }
          }
          break;
      }
    }
  }

  Future<void> _handleSubscription() async {
    final paymentMethod = ref.read(selectedPaymentMethodProvider);
    final userId = UserData.ins.userId;

    if (userId == null) {
      appSnackBar('Error', 'User not authenticated', Colors.red);
      return;
    }

    if (paymentMethod == 'google_play' &&
        !ref.read(inAppPurchaseInitializedProvider)) {
      appSnackBar('Error', 'Payment service not initialized', Colors.red);
      return;
    }

    if (!ref.read(termsAcceptedProvider)) {
      appSnackBar('Error', 'Please accept the terms and conditions', Colors.red);
      return;
    }

    ref.read(paymentLoadingProvider.notifier).state = true;
    ref.read(selectedPlanProvider.notifier).state = widget.plan;

    try {
      final paymentService = ref.read(paymentServiceProvider(userId));

      if (paymentMethod == 'google_play') {
        final productId = widget.plan.googleProductId;
        final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails({productId});

        if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
          appSnackBar('Error', 'Plan not available', Colors.red);
          return;
        }

        final ProductDetails productDetails = response.productDetails.first;
        final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
        final bool purchaseInitiated = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

        if (!purchaseInitiated && mounted) {
          appSnackBar('Error', 'Failed to initiate purchase', Colors.red);
        }
      } else if (paymentMethod == 'stripe') {
        final amount = (widget.plan.price * 100).toInt(); // Convert to cents
        final response = await paymentService.purchaseStripeSubscription(
          planId: widget.plan.id,
          amount: amount,
          currency: 'usd',
          context: context,
          ref: ref,
        );

        if (response.status == Status.completed && mounted) {
          appSnackBar('Success', 'Subscription created successfully', Colors.green);
          ref.refresh(currentSubscriptionProvider(userId));
          ref.read(paymentLoadingProvider.notifier).state = false;
          Navigator.pushReplacementNamed(context, BottomNavBar.routeName);

        } else if (response.status == Status.canceled && mounted) {
          ref.read(paymentLoadingProvider.notifier).state = false;
          // appSnackBar('Cancelled', 'Payment was cancelled by the user', Colors.orange);

        } else if (mounted) {
          ref.read(paymentLoadingProvider.notifier).state = false;
          // appSnackBar('Cancelled', 'Payment was cancelled by the user', Colors.orange);
        }
      }
    } catch (e) {
      if (mounted) {
        ref.read(paymentLoadingProvider.notifier).state = false;
        appSnackBar('Error', 'Purchase error', Colors.red);
      }
    } finally {
      if (paymentMethod == 'stripe') {
        ref.read(paymentLoadingProvider.notifier).state = false;
      }
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
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);
    final isInitialized = ref.watch(inAppPurchaseInitializedProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Confirm Your Subscription',
          style: AppTextstyle.interBold(fontSize: 15, color: AppColors.darkBlue),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan details card
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
                    _featureRow('Up to ${(widget.plan.imageGenerationCredits / 24).toInt()} Image-to-Image Generations'),
                    _featureRow('Up to ${(widget.plan.promptGenerationCredits / 2).toInt()} Text-to-Image Generations'),
                    _featureRow('Total Credits: ${widget.plan.totalCredits.toInt()}'),
                    const SizedBox(height: 10),
                    ...widget.plan.features.take(3).map((feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check,
                              size: 16, color: AppColors.purple),
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
                  fontSize: 16,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  if (isInitialized)
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedPaymentMethodProvider.notifier).state = 'google_play';
                      },
                      child: Card(
                        elevation: selectedPaymentMethod == 'google_play' ? 5 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: selectedPaymentMethod == 'google_play'
                                ? AppColors.darkBlue
                                : Colors.grey.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedPaymentMethod == 'google_play'
                                ? AppColors.purple.withOpacity(0.1)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.android,
                                size: 28,
                                color: selectedPaymentMethod == 'google_play'
                                    ? AppColors.purple
                                    : AppColors.darkBlue,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Google Pay',
                                style: AppTextstyle.interMedium(
                                  fontSize: 18,
                                  color: selectedPaymentMethod == 'google_play'
                                      ? AppColors.purple
                                      : AppColors.darkBlue,
                                ),
                              ),
                              const Spacer(),
                              if (selectedPaymentMethod == 'google_play')
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.purple,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (isInitialized) const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      ref.read(selectedPaymentMethodProvider.notifier).state = 'stripe';
                    },
                    child: Card(
                      elevation: selectedPaymentMethod == 'stripe' ? 8 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selectedPaymentMethod == 'stripe'
                              ? AppColors.darkBlue
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selectedPaymentMethod == 'stripe'
                              ? AppColors.purple.withOpacity(0.1)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 28,
                              color: selectedPaymentMethod == 'stripe'
                                  ? AppColors.purple
                                  : AppColors.darkBlue,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Credit/Debit Card',
                              style: AppTextstyle.interMedium(
                                fontSize: 18,
                                color: selectedPaymentMethod == 'stripe'
                                    ? AppColors.purple
                                    : AppColors.darkBlue,
                              ),
                            ),
                            const Spacer(),
                            if (selectedPaymentMethod == 'stripe')
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.purple,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Terms and conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: ref.watch(termsAcceptedProvider),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(termsAcceptedProvider.notifier).state = value;
                      }
                    },
                    activeColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Optionally handle tap on whole text if needed
                      },
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: AppTextstyle.interRegular(
                            fontSize: 14,
                            color: AppColors.darkBlue,
                          ),
                          children: [
                            const TextSpan(text: "I have read and agree to the "),
                            TextSpan(
                              text: "Terms of Service",
                              style: AppTextstyle.interMedium(
                                fontSize: 14,
                                color: AppColors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigate to Terms of Service page
                                },
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: AppTextstyle.interMedium(
                                fontSize: 14,
                                color: AppColors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigate to Privacy Policy page
                                },
                            ),
                            const TextSpan(text: "."),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Subscribe button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (isLoading || !ref.read(termsAcceptedProvider))
                      ? null
                      : _handleSubscription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    disabledBackgroundColor: AppColors.purple.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
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

  Widget _featureRow(String title, [bool check = true]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            check ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: AppColors.darkBlue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}