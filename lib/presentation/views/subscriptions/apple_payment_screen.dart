import 'package:Artleap.ai/presentation/views/subscriptions/payment_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/domain/payment/apple_payment_service.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_provider.dart';
import '../../../domain/api_services/api_response.dart';

class ApplePaymentScreen extends ConsumerStatefulWidget {
  static const String routeName = "apple_payment_screen";
  final SubscriptionPlanModel plan;

  const ApplePaymentScreen({super.key, required this.plan});

  @override
  ConsumerState<ApplePaymentScreen> createState() => _ApplePaymentScreenState();
}

class _ApplePaymentScreenState extends ConsumerState<ApplePaymentScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApplePayment();
  }

  Future<void> _initializeApplePayment() async {
    final userId = UserData.ins.userId;
    if (userId == null) {
      appSnackBar('Error', 'User not authenticated', Colors.red);
      return;
    }
    final applePaymentService = ref.read(applePaymentServiceProvider(userId));
    final initialized = await applePaymentService.initialize();
    if (initialized) {
      applePaymentService.listenToPurchaseUpdates(context, widget.plan);
      ref.read(inAppPurchaseInitializedProvider.notifier).state = true;
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

    if (paymentMethod == 'apple' && !ref.read(inAppPurchaseInitializedProvider)) {
      appSnackBar('Error', 'App Store payment service not initialized', Colors.red);
      ref.read(paymentLoadingProvider.notifier).state = false;
      return;
    }

    if (!ref.read(termsAcceptedProvider)) {
      appSnackBar('Error', 'Please accept the terms and conditions', Colors.red);
      ref.read(paymentLoadingProvider.notifier).state = false;
      return;
    }

    ref.read(paymentLoadingProvider.notifier).state = true;
    final paymentService = ref.read(paymentServiceProvider(userId));
    
    if (paymentMethod == 'apple') {
      final applePaymentService = ref.read(applePaymentServiceProvider(userId));
      final success = await applePaymentService.purchaseSubscription(widget.plan, context);

      // Stop loader if purchase initiation fails
      if (!success) {
        ref.read(paymentLoadingProvider.notifier).state = false;
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
        // ref.refresh(currentSubscriptionProvider(userId));
        ref.read(paymentLoadingProvider.notifier).state = false;
        Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
      } else if (mounted) {
        ref.read(paymentLoadingProvider.notifier).state = false;
        appSnackBar('Error', 'Stripe purchase failed', Colors.red);
      }
    }else {
      ref.read(paymentLoadingProvider.notifier).state = false;
      appSnackBar('Error', 'Select Payment Method First', Colors.red);
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
                  fontSize: 18,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 16),
              // Payment method options
              Column(
                children: [
                  // App Store option
                  if (isInitialized)
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedPaymentMethodProvider.notifier).state = 'apple';
                      },
                      child: Card(
                        elevation: selectedPaymentMethod == 'apple' ? 8 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: selectedPaymentMethod == 'apple'
                                ? AppColors.darkBlue
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedPaymentMethod == 'apple'
                                ? AppColors.purple.withOpacity(0.1)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.apple,
                                size: 28,
                                color: selectedPaymentMethod == 'apple'
                                    ? AppColors.purple
                                    : AppColors.darkBlue,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'App Store',
                                style: AppTextstyle.interMedium(
                                  fontSize: 18,
                                  color: selectedPaymentMethod == 'apple'
                                      ? AppColors.purple
                                      : AppColors.darkBlue,
                                ),
                              ),
                              const Spacer(),
                              if (selectedPaymentMethod == 'apple')
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
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushNamed(context, '/privacy-policy');
                            },
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppTextstyle.interMedium(
                              fontSize: 16,
                              color: AppColors.blue,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushNamed(context, '/privacy-policy');
                            },
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