import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import '../../../../domain/subscriptions/plan_provider.dart';
import '../../../../domain/subscriptions/subscription_repo_provider.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../../../../shared/notification_utils/empty_state.dart';
import '../payment_screen.dart';
import 'loading_state.dart';
import 'error_state.dart';
import 'plan_card.dart';

// Create a provider for tab index state
final currentTabIndexProvider = StateProvider<int>((ref) => 0);

class PlanSelectionContent extends ConsumerWidget {
  const PlanSelectionContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final selectedPlan = ref.watch(selectedPlanProvider);

    return plansAsync.when(
      loading: () => const LoadingState(),
      error: (error, stack) => ErrorState(error),
      data: (plans) {
        if (plans.isEmpty) {
          return const EmptyState(
            icon: Icons.error,
            title: 'Error Occur',
            subtitle: 'No Active Plans Founded',
          );
        }
        return PlanListContent(plans: plans, selectedPlan: selectedPlan);
      },
    );
  }
}

class PlanListContent extends ConsumerWidget {
  final List<SubscriptionPlanModel> plans;
  final SubscriptionPlanModel? selectedPlan;

  const PlanListContent({
    super.key,
    required this.plans,
    required this.selectedPlan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group plans by type
    final basicPlans = plans
        .where((plan) => plan.type.toLowerCase().contains('basic'))
        .toList();
    final standardPlans = plans
        .where((plan) => plan.type.toLowerCase().contains('standard'))
        .toList();
    final premiumPlans = plans
        .where((plan) => plan.type.toLowerCase().contains('premium'))
        .toList();

    final pageController = PageController();
    final currentTabIndex = ref.watch(currentTabIndexProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Center(
            child: Column(
              children: [
                Text(
                  'Purchase a subscription',
                  style: AppTextstyle.interBold(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Choose the plan that works for you',
                  style: AppTextstyle.interMedium(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlanTab(ref, 'Basic', 0),
                _buildPlanTab(ref, 'Standard', 1),
                _buildPlanTab(ref, 'Premium', 2),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                ref.read(currentTabIndexProvider.notifier).state = index;
              },
              children: [
                _buildPlanPage(context, ref, basicPlans),
                _buildPlanPage(context, ref, standardPlans),
                _buildPlanPage(context, ref, premiumPlans),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanTab(WidgetRef ref, String title, int index) {
    final currentTabIndex = ref.watch(currentTabIndexProvider);

    return GestureDetector(
      onTap: () {
        ref.read(currentTabIndexProvider.notifier).state = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: currentTabIndex == index
              ? AppColors.purple.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: AppTextstyle.interMedium(
            fontSize: 14,
            color: currentTabIndex == index ? AppColors.purple : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanPage(
      BuildContext context, WidgetRef ref, List<SubscriptionPlanModel> plans) {
    if (plans.isEmpty) {
      return Center(
        child: Text(
          'No plans available',
          style: AppTextstyle.interMedium(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(subscriptionPlansProvider);
        await ref.read(subscriptionPlansProvider.future);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ...plans
                .map((plan) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: PlanCard(
                        plan: plan,
                        isSelected: selectedPlan?.id == plan.id,
                        onSelect: () => ref
                            .read(selectedPlanProvider.notifier)
                            .state = plan,
                      ),
                    ))
                .toList(),
            if (selectedPlan != null && plans.contains(selectedPlan))
              _buildContinueButton(context, selectedPlan!)
            else
              _buildSelectPlanPrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(
      BuildContext context, SubscriptionPlanModel plan) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
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
                arguments: plan,
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
              'Continue with ${plan.name}',
              style: AppTextstyle.interBold(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectPlanPrompt() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        'Please select a plan to continue',
        style: AppTextstyle.interMedium(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
