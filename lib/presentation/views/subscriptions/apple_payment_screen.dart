import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_provider.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';
import '../../../domain/payment/apple_payment_service.dart';
import 'google_payment_screen.dart';
import 'payment_components/cancel_purchase_button.dart';
import 'payment_components/payment_method_card.dart';
import 'payment_components/subscribe_button.dart';
import 'payment_components/subscription_plan_card.dart';
import 'payment_components/terms_condition_text.dart';

class ApplePaymentScreen extends ConsumerStatefulWidget {
  static const String routeName = "apple_payment_screen";
  final SubscriptionPlanModel plan;

  const ApplePaymentScreen({super.key, required this.plan});

  @override
  ConsumerState<ApplePaymentScreen> createState() => _ApplePaymentScreenState();
}

class _ApplePaymentScreenState extends ConsumerState<ApplePaymentScreen> {
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initializeApplePayment();
  }

  @override
  void dispose() {
    _isMounted = false;
    _cleanupApplePayment();
    super.dispose();
  }

  // Safe state update method
  void _safeStateUpdate(VoidCallback callback) {
    if (_isMounted) {
      callback();
    }
  }

  Future<void> _initializeApplePayment() async {
    final userId = UserData.ins.userId;
    if (userId == null) {
      _safeStateUpdate(() {
        appSnackBar('Error', 'User not authenticated', Colors.red);
      });
      return;
    }
    final applePaymentService = ref.read(applePaymentServiceProvider(userId));
    final initialized = await applePaymentService.initialize();
    if (initialized && _isMounted) {
      ref.read(inAppPurchaseInitializedProvider.notifier).state = true;
    }
  }

  void _cleanupApplePayment() {
    final userId = UserData.ins.userId;
    if (userId != null) {
      final applePaymentService = ref.read(applePaymentServiceProvider(userId));
      applePaymentService.dispose();
    }
  }

  Future<void> _handleSubscription() async {
    final paymentMethod = ref.read(selectedPaymentMethodProvider);
    final userId = UserData.ins.userId;

    if (userId == null) {
      appSnackBar('Error', 'User not authenticated', Colors.red);
      _safeStateUpdate(() {
        ref.read(paymentLoadingProvider.notifier).state = false;
      });
      return;
    }

    if (paymentMethod == 'apple' && !ref.read(inAppPurchaseInitializedProvider)) {
      appSnackBar('Error', 'App Store payment service not initialized', Colors.red);
      _safeStateUpdate(() {
        ref.read(paymentLoadingProvider.notifier).state = false;
      });
      return;
    }

    if (!ref.read(termsAcceptedProvider)) {
      appSnackBar('Error', 'Please accept the terms and conditions', Colors.red);
      _safeStateUpdate(() {
        ref.read(paymentLoadingProvider.notifier).state = false;
      });
      return;
    }

    ref.read(paymentLoadingProvider.notifier).state = true;
    final paymentService = ref.read(paymentServiceProvider(userId));

    if (paymentMethod == 'apple') {
      final applePaymentService = ref.read(applePaymentServiceProvider(userId));
      final success = await applePaymentService.purchaseSubscription(widget.plan, context);

      if (!success) {
        _safeStateUpdate(() {
          ref.read(paymentLoadingProvider.notifier).state = false;
        });
      }
    } else if (paymentMethod == 'stripe') {
      final amount = (widget.plan.price * 100).toInt();
      final response = await paymentService.purchaseStripeSubscription(
        planId: widget.plan.id,
        amount: amount,
        currency: 'usd',
        context: context,
        ref: ref,
      );

      if (response.status == Status.completed) {
        _safeStateUpdate(() {
          appSnackBar('Success', 'Subscription created successfully', Colors.green);
          ref.read(paymentLoadingProvider.notifier).state = false;
          Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
        });
      } else {
        _safeStateUpdate(() {
          ref.read(paymentLoadingProvider.notifier).state = false;
          appSnackBar('Error', response.message ?? 'Stripe purchase failed', Colors.red);
        });
      }
    } else {
      _safeStateUpdate(() {
        ref.read(paymentLoadingProvider.notifier).state = false;
        appSnackBar('Error', 'Select Payment Method First', Colors.red);
      });
    }
  }

  Future<bool> _onWillPop() async {
    final userId = UserData.ins.userId;
    if (userId != null) {
      final applePaymentService = ref.read(applePaymentServiceProvider(userId));
      applePaymentService.cancelPurchase();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(paymentLoadingProvider);
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);
    final isInitialized = ref.watch(inAppPurchaseInitializedProvider);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubscriptionPlanCard(plan: widget.plan),
                const SizedBox(height: 30),
                _buildPaymentMethodSection(isInitialized, selectedPaymentMethod),
                const SizedBox(height: 24),
                TermsAndConditions(
                  onTermsChanged: (value) {
                    if (value != null && _isMounted) {
                      ref.read(termsAcceptedProvider.notifier).state = value;
                    }
                  },
                  isAccepted: ref.watch(termsAcceptedProvider),
                ),
                const SizedBox(height: 32),
                SubscribeButton(
                  isLoading: isLoading,
                  isEnabled: ref.read(termsAcceptedProvider),
                  onPressed: _handleSubscription,
                ),
                const SizedBox(height: 16),
                if (isLoading && selectedPaymentMethod == 'apple')
                  CancelPurchaseButton(
                    onCancel: () {
                      final userId = UserData.ins.userId;
                      if (userId != null) {
                        final applePaymentService = ref.read(applePaymentServiceProvider(userId));
                        applePaymentService.cancelPurchase();
                        _safeStateUpdate(() {
                          ref.read(paymentLoadingProvider.notifier).state = false;
                          appSnackBar('Info', 'Purchase canceled', Colors.yellow);
                        });
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Confirm Your Subscription',
        style: AppTextstyle.interBold(fontSize: 16, color: AppColors.darkBlue),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.background,
      iconTheme: const IconThemeData(color: AppColors.darkBlue),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        onPressed: () {
          _onWillPop().then((canPop) {
            if (canPop && _isMounted) {
              Navigator.of(context).pop();
            }
          });
        },
      ),
    );
  }

  Widget _buildPaymentMethodSection(bool isInitialized, String selectedPaymentMethod) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            if (isInitialized)
              PaymentMethodCard(
                icon: Icons.apple_rounded,
                title: 'App Store',
                isSelected: selectedPaymentMethod == 'apple',
                onTap: () {
                  if (_isMounted) {
                    ref.read(selectedPaymentMethodProvider.notifier).state = 'apple';
                  }
                },
              ),
            if (isInitialized) const SizedBox(height: 12),
            PaymentMethodCard(
              icon: Icons.credit_card_rounded,
              title: 'Credit/Debit Card',
              isSelected: selectedPaymentMethod == 'stripe',
              onTap: () {
                if (_isMounted) {
                  ref.read(selectedPaymentMethodProvider.notifier).state = 'stripe';
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}