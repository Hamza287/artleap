import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import '../../../domain/api_services/api_response.dart';
import '../../../domain/subscriptions/subscription_model.dart';
import '../../../domain/subscriptions/subscription_repo_provider.dart';
import '../home_section/bottom_nav_bar.dart';

// Create a provider for the loading state
final paymentLoadingProvider = StateProvider<bool>((ref) => false);

class PaymentScreen extends ConsumerWidget {
  static const String routeName = "payment_screen";
  final SubscriptionPlanModel plan;
  const PaymentScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethods = ['Google Pay']; // Only Google Pay option

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: AppTextstyle.interBold(
            fontSize: 20,
            color: AppColors.darkBlue,
          ),
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
                          plan.name,
                          style: AppTextstyle.interBold(
                            fontSize: 20,
                            color: AppColors.purple,
                          ),
                        ),
                        Text(
                          '\$${plan.price.toStringAsFixed(2)}/${_getPlanPeriod(plan.type)}',
                          style: AppTextstyle.interBold(
                            fontSize: 20,
                            color: AppColors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...plan.features.take(3).map((feature) => Padding(
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
              // Payment method tile (only Google Pay)
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
                    const Icon(
                      Icons.android, // Google Pay icon
                      size: 24,
                      color: AppColors.purple,
                    ),
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
              // Terms and conditions checkbox
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {}, // Implement logic if needed
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
                child: Consumer(
                  builder: (context, ref, child) {
                    final isLoading = ref.watch(paymentLoadingProvider);
                    return ElevatedButton(
                      onPressed: isLoading ? null : () => _handleSubscription(ref, context),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubscription(WidgetRef ref, BuildContext context) async {
    ref.read(paymentLoadingProvider.notifier).state = true;
    try {
      final response = await ref.read(subscriptionServiceProvider).subscribe(
        UserData.ins.userId!,
        plan.id,
        'Google Pay', // Hardcoded since it's the only option
      );

      if (response.status == Status.completed) {
        if (context.mounted) {
          appSnackBar('Success', 'Subscription Successful', Colors.green);
          Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
          ref.refresh(currentSubscriptionProvider(UserData.ins.userId!));
        }
      } else if (context.mounted) {
        appSnackBar('Error', response.message ?? 'Subscription failed', Colors.red);
      }
    } catch (e) {
      if (context.mounted) {
        appSnackBar('Error', 'An error occurred during subscription', Colors.red);
      }
    } finally {
      if (context.mounted) {
        ref.read(paymentLoadingProvider.notifier).state = false;
      }
    }
  }

  String _getPlanPeriod(String type) {
    switch (type.toLowerCase()) {
      case 'weekly':
        return 'week';
      case 'monthly':
        return 'month';
      case 'yearly':
        return 'year';
      case 'trial':
        return 'trial';
      default:
        return '';
    }
  }
}