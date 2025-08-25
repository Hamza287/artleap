import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/presentation/views/subscriptions/apple_payment_screen.dart';
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
    final pageController = PageController();

    return plansAsync.when(
      loading: () => const LoadingState(),
      error: (error, stack) => ErrorState(error),
      data: (plans) {
        if (plans.isEmpty) {
          return const EmptyState(
            icon: Icons.error,
            title: 'Error Occur',
            subtitle: 'No Active Plans Found',
          );
        }

        // ✅ Filter plans based on platform
        final filteredPlans = plans.where((plan) {
          if (Platform.isIOS) {
            return plan.appleProductId.isNotEmpty;
          } else if (Platform.isAndroid) {
            return plan.googleProductId.isNotEmpty;
          }
          return false; // if another platform, show nothing
        }).toList();

        if (filteredPlans.isEmpty) {
          return const EmptyState(
            icon: Icons.error,
            title: 'No Plans Available',
            subtitle: 'No valid subscription plans for this platform',
          );
        }

        return PlanListContent(
          plans: filteredPlans,
          selectedPlan: selectedPlan,
          pageController: pageController,
        );
      },
    );
  }
}

class PlanListContent extends ConsumerStatefulWidget {
  final List<SubscriptionPlanModel> plans;
  final SubscriptionPlanModel? selectedPlan;
  final PageController pageController;

  const PlanListContent({
    super.key,
    required this.plans,
    required this.selectedPlan,
    required this.pageController,
  });

  @override
  ConsumerState<PlanListContent> createState() => _PlanListContentState();
}

class _PlanListContentState extends ConsumerState<PlanListContent> {
  @override
  void initState() {
    super.initState();

    // Set up listener for page changes to auto-select first plan in each tab
    widget.pageController.addListener(() {
      final currentPage = widget.pageController.page?.round() ?? 0;
      if (currentPage != ref.read(currentTabIndexProvider)) {
        ref.read(currentTabIndexProvider.notifier).state = currentPage;
        _autoSelectFirstPlanInTab(currentPage);
      }
    });

    // Auto-select first plan in initial tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoSelectFirstPlanInTab(ref.read(currentTabIndexProvider));
    });
  }

  void _autoSelectFirstPlanInTab(int tabIndex) {
    final plans = _getPlansForTab(tabIndex);
    if (plans.isNotEmpty) {
      ref.read(selectedPlanProvider.notifier).state = plans.first;
    }
  }

  List<SubscriptionPlanModel> _getPlansForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return widget.plans
            .where((plan) => plan.type.toLowerCase().contains('basic'))
            .toList();
      case 1:
        return widget.plans
            .where((plan) => plan.type.toLowerCase().contains('standard'))
            .toList();
      case 2:
        return widget.plans
            .where((plan) => plan.type.toLowerCase().contains('premium'))
            .toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTabIndex = ref.watch(currentTabIndexProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(height: screenSize.height * 0.02),
          Center(
            child: Column(
              children: [
                Text(
                  'Purchase a subscription',
                  style: AppTextstyle.interBold(
                    fontSize: screenSize.width * 0.06,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.005),
                Text(
                  'Choose the plan that works for you',
                  style: AppTextstyle.interMedium(
                    fontSize: screenSize.width * 0.035,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05,
              vertical: screenSize.height * 0.02,
            ),
            padding: EdgeInsets.all(screenSize.width * 0.02),
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
                _buildPlanTab(ref, 'Basic', 0, widget.pageController),
                _buildPlanTab(ref, 'Standard', 1, widget.pageController),
                _buildPlanTab(ref, 'Premium', 2, widget.pageController),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: widget.pageController,
              onPageChanged: (index) {
                ref.read(currentTabIndexProvider.notifier).state = index;
                _autoSelectFirstPlanInTab(index);
              },
              children: [
                _buildPlanPage(context, ref, _getPlansForTab(0)),
                _buildPlanPage(context, ref, _getPlansForTab(1)),
                _buildPlanPage(context, ref, _getPlansForTab(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanTab(WidgetRef ref, String title, int index, PageController pageController) {
    final currentTabIndex = ref.watch(currentTabIndexProvider);
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        ref.read(currentTabIndexProvider.notifier).state = index;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _autoSelectFirstPlanInTab(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.045,
          vertical: screenSize.height * 0.015,
        ),
        decoration: BoxDecoration(
          color: currentTabIndex == index
              ? Color(0xFFE4C1FF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: AppTextstyle.interMedium(
            fontSize: screenSize.width * 0.035,
            color: currentTabIndex == index ? AppColors.purple : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanPage(
      BuildContext context, WidgetRef ref, List<SubscriptionPlanModel> plans) {
    final screenSize = MediaQuery.of(context).size;

    if (plans.isEmpty) {
      return Center(
        child: Text(
          'No plans available',
          style: AppTextstyle.interMedium(
            fontSize: screenSize.width * 0.04,
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
            SizedBox(height: screenSize.height * 0.01),
            ...plans
                .map((plan) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
                vertical: screenSize.height * 0.005,
              ),
              child: PlanCard(
                plan: plan,
                isSelected: ref.watch(selectedPlanProvider)?.id == plan.id,
                onSelect: () {
                  ref.read(selectedPlanProvider.notifier).state = plan;
                  // Navigate directly to payment screen when a plan is selected
                  final route = Platform.isIOS
                      ? ApplePaymentScreen.routeName
                      : PaymentScreen.routeName;
                  Navigator.pushNamed(
                    context,
                    route,
                    arguments: plan,
                  );
                },
              ),
            ))
                .toList(),
          ],
        ),
      ),
    );
  }
}