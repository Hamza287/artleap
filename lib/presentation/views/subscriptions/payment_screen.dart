import 'dart:async';
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
                Colors.red);
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
    final paymentMethod = ref.read(selectedPaymentMethodProvider);
    final userId = UserData.ins.userId;
    if (userId == null) {
      appSnackBar('Error', 'User not authenticated', Colors.red);
      ref.read(paymentLoadingProvider.notifier).state = false;
      return;
    }

    if (!_isInitialized && paymentMethod == 'google_play') {
      appSnackBar('Error', 'Payment service not initialized', Colors.red);
      ref.read(paymentLoadingProvider.notifier).state = false;
      return;
    }

    if (!ref.read(termsAcceptedProvider)) {
      appSnackBar('Error', 'Please accept the terms and conditions', Colors.red);
      ref.read(paymentLoadingProvider.notifier).state = false;
      return;
    }

    ref.read(paymentLoadingProvider.notifier).state = true;
    ref.read(selectedPlanProvider.notifier).state = widget.plan;

    try {
      final paymentService = ref.read(paymentServiceProvider(userId));
      if (paymentMethod == 'google_play') {
        final productId = widget.plan.googleProductId;
        final response = await paymentService.purchaseSubscription(
          widget.plan.id,
          productId,
          paymentMethod,
        );

        if (response.status != Status.processing && mounted) {
          appSnackBar('Error', response.message ?? 'Failed to initiate purchase', Colors.red);
          ref.read(paymentLoadingProvider.notifier).state = false;
        }
      } else if (paymentMethod == 'stripe') {
        final amount = (widget.plan.price * 100).toInt(); // Convert to cents
        final response = await paymentService.purchaseStripeSubscription(
          planId: widget.plan.id,
          amount: amount,
          currency: 'usd', // Adjust based on your app's currency
          context: context,
          ref: ref,
        );

        if (response.status == Status.completed && mounted) {
          appSnackBar('Success', 'Subscription created successfully', Colors.green);
          ref.refresh(currentSubscriptionProvider(userId));
          Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
        } else if (mounted) {
          appSnackBar('Error', response.message ?? 'Stripe purchase failed', Colors.red);
          ref.read(paymentLoadingProvider.notifier).state = false;
        }
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
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Confirm Your Subscription',
          style: AppTextstyle.interBold(fontSize: 22, color: AppColors.darkBlue),
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
                  fontSize: 18,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 16),
              // Google Pay tile
              GestureDetector(
                onTap: () {
                  ref.read(selectedPaymentMethodProvider.notifier).state = 'google_play';
                },
                child: Card(
                  elevation: selectedPaymentMethod == 'google_play' ? 8 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: selectedPaymentMethod == 'google_play'
                          ? AppColors.purple
                          : AppColors.darkBlue,
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
              const SizedBox(height: 12),
              // Stripe tile
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
                          ? AppColors.purple
                          : AppColors.darkBlue,
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
              const SizedBox(height: 24),
              // Terms and conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: ref.watch(termsAcceptedProvider),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(termsAcceptedProvider.notifier).state = value;
                      }
                    },
                    activeColor: AppColors.purple,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I agree to the ',
                        style: AppTextstyle.interRegular(
                          fontSize: 16,
                          color: AppColors.darkBlue,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: AppTextstyle.interMedium(
                              fontSize: 16,
                              color: AppColors.blue,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppTextstyle.interMedium(
                              fontSize: 16,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
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
                      : () async {
                    await _handleSubscription();
                  },
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
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}