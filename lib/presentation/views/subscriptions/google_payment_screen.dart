import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/domain/subscriptions/plan_provider.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_repo_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/domain/api_services/api_response.dart';

import 'payment_components/payment_method_card.dart';
import 'payment_components/subscribe_button.dart';
import 'payment_components/subscription_plan_card.dart';
import 'payment_components/terms_condition_text.dart';

final paymentLoadingProvider = StateProvider<bool>((ref) => false);
final termsAcceptedProvider = StateProvider<bool>((ref) => false);
final selectedPaymentMethodProvider = StateProvider<String>((ref) => 'google_play');
final inAppPurchaseInitializedProvider = StateProvider<bool>((ref) => false);

class GooglePaymentScreen extends ConsumerStatefulWidget {
  static const String routeName = "payment_screen";
  final SubscriptionPlanModel plan;

  const GooglePaymentScreen({super.key, required this.plan});

  @override
  ConsumerState<GooglePaymentScreen> createState() => _GooglePaymentScreenState();
}

class _GooglePaymentScreenState extends ConsumerState<GooglePaymentScreen> {
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initializeInAppPurchase();
    _listenToPurchaseUpdates();
  }

  @override
  void dispose() {
    _isMounted = false;
    _purchaseSubscription?.cancel();
    super.dispose();
  }

  void _safeStateUpdate(VoidCallback callback) {
    if (_isMounted) {
      callback();
    }
  }

  Future<void> _initializeInAppPurchase() async {
    try {
      final bool available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        _safeStateUpdate(() {
          appSnackBar('Error', 'In-app purchases not available', Colors.red);
        });
        return;
      }
      ref.read(inAppPurchaseInitializedProvider.notifier).state = true;
    } catch (e) {
      _safeStateUpdate(() {
        appSnackBar('Error', 'Failed to initialize payment service: $e', Colors.red);
      });
    }
  }

  void _listenToPurchaseUpdates() {
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
          (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onError: (error) {
        _safeStateUpdate(() {
          ref.read(paymentLoadingProvider.notifier).state = false;
          appSnackBar('Error', 'Purchase error: $error', Colors.red);
        });
      },
    );
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;

        case PurchaseStatus.canceled:
          _safeStateUpdate(() {
            ref.read(paymentLoadingProvider.notifier).state = false;
            print('Purchase Cancelled');
          });
          break;

        case PurchaseStatus.error:
          _safeStateUpdate(() {
            ref.read(paymentLoadingProvider.notifier).state = false;
            appSnackBar(
              'Error',
              'Purchase error: ${purchaseDetails.error?.message ?? "Unknown error"}',
              Colors.red,
            );
          });
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _safeStateUpdate(() {
            ref.read(paymentLoadingProvider.notifier).state = true;
          });

          try {
            final userId = UserData.ins.userId;
            if (userId != null) {
              await ref.read(currentSubscriptionProvider(userId).future);
            }

            _safeStateUpdate(() {
              ref.read(paymentLoadingProvider.notifier).state = false;
              appSnackBar('Success', 'Subscription activated', Colors.green);
            });
          } catch (e) {
            _safeStateUpdate(() {
              ref.read(paymentLoadingProvider.notifier).state = false;
            });
          }
          break;
      }
    }
  }

  Future<void> _handleSubscription() async {
    final paymentMethod = ref.read(selectedPaymentMethodProvider);
    final userId = UserData.ins.userId;

    if (userId == null) {
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
        final productId = widget.plan.type;
        final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails({productId});
        print(productId);
        if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
          _safeStateUpdate(() {
            appSnackBar('Error', 'Plan not available', Colors.red);
            ref.read(paymentLoadingProvider.notifier).state = false;
          });
          return;
        }

        final ProductDetails productDetails = response.productDetails.first;
        final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
        final bool purchaseInitiated = await InAppPurchase.instance
            .buyNonConsumable(purchaseParam: purchaseParam);

        if (!purchaseInitiated) {
          _safeStateUpdate(() {
            appSnackBar('Error', 'Failed to initiate purchase', Colors.red);
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
            ref.refresh(currentSubscriptionProvider(userId));
            ref.read(paymentLoadingProvider.notifier).state = false;
            Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
          });
        } else {
          _safeStateUpdate(() {
            ref.read(paymentLoadingProvider.notifier).state = false;
          });
        }
      }
    } catch (e) {
      _safeStateUpdate(() {
        ref.read(paymentLoadingProvider.notifier).state = false;
      });
    } finally {
      if (paymentMethod == 'stripe') {
        _safeStateUpdate(() {
          ref.read(paymentLoadingProvider.notifier).state = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(paymentLoadingProvider);
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);
    final isInitialized = ref.watch(inAppPurchaseInitializedProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: _buildAppBar(theme),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubscriptionPlanCard(plan: widget.plan),
              const SizedBox(height: 30),
              _buildPaymentMethodSection(theme, isInitialized, selectedPaymentMethod),
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
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(
        'Confirm Your Subscription',
        style: AppTextstyle.interBold(fontSize: 16, color: theme.colorScheme.onBackground),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.background,
      iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildPaymentMethodSection(ThemeData theme, bool isInitialized, String selectedPaymentMethod) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            if (isInitialized)
              PaymentMethodCard(
                icon: Icons.android_rounded,
                title: 'Google Pay',
                isSelected: selectedPaymentMethod == 'google_play',
                onTap: () {
                  if (_isMounted) {
                    ref.read(selectedPaymentMethodProvider.notifier).state = 'google_play';
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