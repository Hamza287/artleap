import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/subscriptions/subscription_model.dart';
import 'package:Artleap.ai/presentation/views/subscriptions/apple_payment_screen.dart';
import '../../../../domain/subscriptions/plan_provider.dart';
import '../../../../domain/subscriptions/subscription_repo_provider.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../payment_screen.dart';
import 'plan_card.dart';
import 'plan_selection_content.dart';

class PlanListContent extends ConsumerStatefulWidget {
  final List<SubscriptionPlanModel> plans;
  final SubscriptionPlanModel? selectedPlan;
  final PageController pageController;
  final String? currentPlan;
  final VoidCallback? onDispose;

  const PlanListContent({
    super.key,
    required this.plans,
    required this.selectedPlan,
    required this.pageController,
    this.currentPlan,
    this.onDispose,
  });

  @override
  ConsumerState<PlanListContent> createState() => _PlanListContentState();
}

class _PlanListContentState extends ConsumerState<PlanListContent> {
  // Store tab information to prevent rebuilding with different content
  late List<Map<String, dynamic>> _tabsAndPages;

  @override
  void initState() {
    super.initState();

    // Pre-calculate tabs and pages to prevent layout shifts
    _tabsAndPages = _buildTabsAndPages();

    // Set up listener for page changes
    widget.pageController.addListener(_pageListener);

    // Auto-select first plan in initial tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoSelectFirstPlanInTab(ref.read(currentTabIndexProvider));
    });
  }

  // Page listener callback method
  void _pageListener() {
    final currentPage = widget.pageController.page?.round() ?? 0;
    if (currentPage < _tabsAndPages.length) {
      final actualTabIndex = _tabsAndPages[currentPage]["tabIndex"] as int;
      if (actualTabIndex != ref.read(currentTabIndexProvider)) {
        ref.read(currentTabIndexProvider.notifier).state = actualTabIndex;
        _autoSelectFirstPlanInTab(actualTabIndex);
      }
    }
  }

  @override
  void dispose() {
    // Remove the listener first
    widget.pageController.removeListener(_pageListener);

    // Call the onDispose callback if provided
    widget.onDispose?.call();

    super.dispose();
  }

  // Pre-calculate tabs to prevent layout shifts
  List<Map<String, dynamic>> _buildTabsAndPages() {
    final tabsAndPages = <Map<String, dynamic>>[];

    final basicPlans = _getPlansForTab(0);
    if (basicPlans.isNotEmpty) {
      tabsAndPages.add({
        "title": widget.currentPlan == 'Basic' ? "Current" : "Basic",
        "plans": basicPlans,
        "tabIndex": 0
      });
    }

    final standardPlans = _getPlansForTab(1);
    if (standardPlans.isNotEmpty) {
      tabsAndPages.add({
        "title": widget.currentPlan == 'Standard' ? "Current" : "Standard",
        "plans": standardPlans,
        "tabIndex": 1
      });
    }

    final premiumPlans = _getPlansForTab(2);
    if (premiumPlans.isNotEmpty) {
      tabsAndPages.add({
        "title": widget.currentPlan == 'Premium' ? "Current" : "Premium",
        "plans": premiumPlans,
        "tabIndex": 2
      });
    }

    return tabsAndPages;
  }

  void _autoSelectFirstPlanInTab(int tabIndex) {
    // Find the actual plans for this tab index
    final tabData = _tabsAndPages.firstWhere(
          (tab) => tab["tabIndex"] == tabIndex,
      orElse: () => _tabsAndPages.first,
    );

    final plans = tabData["plans"] as List<SubscriptionPlanModel>;
    if (plans.isNotEmpty) {
      ref.read(selectedPlanProvider.notifier).state = plans.first;
    }
  }

  List<SubscriptionPlanModel> _filterPlansByCurrent({
    required List<SubscriptionPlanModel> widgetPlans,
    required String? currentPlan,
  }) {
    if (currentPlan == null || currentPlan.isEmpty) {
      return widgetPlans; // show all if no current plan
    }

    // Define plan hierarchy
    final order = ["basic", "standard", "premium"];
    final currentIndex = order.indexOf(currentPlan.toLowerCase());

    if (currentIndex == -1) {
      return widgetPlans;
    }

    // Only allow current or higher plans
    return widgetPlans.where((plan) {
      final planIndex = order.indexOf(plan.type.toLowerCase());
      return planIndex >= currentIndex;
    }).toList();
  }

  List<SubscriptionPlanModel> _getPlansForTab(int tabIndex) {
    List<SubscriptionPlanModel> tabPlans;
    switch (tabIndex) {
      case 0:
        tabPlans = widget.plans
            .where((plan) => plan.type.toLowerCase().contains('basic'))
            .toList();
        break;
      case 1:
        tabPlans = widget.plans
            .where((plan) => plan.type.toLowerCase().contains('standard'))
            .toList();
        break;
      case 2:
        tabPlans = widget.plans
            .where((plan) => plan.type.toLowerCase().contains('premium'))
            .toList();
        break;
      default:
        tabPlans = [];
    }

    // ✅ Apply filter here
    return _filterPlansByCurrent(
      widgetPlans: tabPlans,
      currentPlan: widget.currentPlan,
    );
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
              children: List.generate(_tabsAndPages.length, (index) {
                return _buildPlanTab(
                  ref,
                  _tabsAndPages[index]["title"] as String,
                  _tabsAndPages[index]["tabIndex"] as int,
                  index,
                  widget.pageController,
                );
              }),
            ),
          ),
          Expanded(
            child: PageView(
              controller: widget.pageController,
              onPageChanged: (index) {
                if (index < _tabsAndPages.length) {
                  // Use the actual tab index, not the display index
                  final actualTabIndex = _tabsAndPages[index]["tabIndex"] as int;
                  ref.read(currentTabIndexProvider.notifier).state = actualTabIndex;
                  _autoSelectFirstPlanInTab(actualTabIndex);
                }
              },
              children: List.generate(
                _tabsAndPages.length,
                    (index) => _buildPlanPage(context, ref, _tabsAndPages[index]["plans"] as List<SubscriptionPlanModel>),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanTab(WidgetRef ref, String title, int actualTabIndex, int displayIndex, PageController pageController) {
    final currentTabIndex = ref.watch(currentTabIndexProvider);
    final screenSize = MediaQuery.of(context).size;

    // Check if this is the currently selected tab
    final isSelected = currentTabIndex == actualTabIndex;

    return GestureDetector(
      onTap: () {
        pageController.animateToPage(
          displayIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _autoSelectFirstPlanInTab(actualTabIndex);
      },
      child: Container(
        constraints: BoxConstraints(
          minWidth: screenSize.width * 0.25, // Ensure consistent width
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.045,
          vertical: screenSize.height * 0.015,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFFE4C1FF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextstyle.interMedium(
            fontSize: screenSize.width * 0.035,
            color: isSelected ? AppColors.purple : Colors.black,
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