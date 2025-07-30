import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../domain/subscriptions/subscription_model.dart';
import '../../../domain/subscriptions/subscription_repo_provider.dart';
import 'choose_plan_widgets/plan_card.dart';
import 'payment_screen.dart';

final selectedPlanProvider = StateProvider<SubscriptionPlanModel?>((ref) => null);

class ChoosePlanScreen extends ConsumerWidget {
  const ChoosePlanScreen({super.key});
  static const String routeName = "choose_plan_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final selectedPlan = ref.watch(selectedPlanProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Plan',
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
        child: plansAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error', style: AppTextstyle.interRegular(fontSize: 16, color: AppColors.redColor)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(subscriptionPlansProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Retry', style: AppTextstyle.interBold(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
          data: (plans) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'Select the plan that fits your needs',
                              style: AppTextstyle.interRegular(
                                fontSize: 16,
                                color: AppColors.darkBlue.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: screenHeight * 0.55,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: plans.length,
                                itemExtent: screenWidth * 0.8,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final plan = plans[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: PlanCard(
                                      plan: plan,
                                      isSelected: selectedPlan?.id == plan.id,
                                      onSelect: () => ref.read(selectedPlanProvider.notifier).state = plan,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Spacer(),
                            if (selectedPlan != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                margin: const EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected Plan: ${selectedPlan.name}',
                                      style: AppTextstyle.interBold(
                                        fontSize: 18,
                                        color: AppColors.darkBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${selectedPlan.price.toStringAsFixed(2)}/${_getPlanPeriod(selectedPlan.type)}',
                                      style: AppTextstyle.interMedium(
                                        fontSize: 16,
                                        color: AppColors.darkBlue.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFFF61E6), Color(0xFF7D33F9)],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              PaymentScreen.routeName,
                                              arguments: selectedPlan,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            'Continue with ${selectedPlan.name}',
                                            style: AppTextstyle.interBold(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.all(24),
                                margin: const EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Please select a plan to continue',
                                    style: AppTextstyle.interMedium(
                                      fontSize: 16,
                                      color: AppColors.darkBlue.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
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