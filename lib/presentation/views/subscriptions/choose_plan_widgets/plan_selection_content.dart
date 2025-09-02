import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/subscriptions/plan_provider.dart';
import '../../../../domain/subscriptions/subscription_repo_provider.dart';
import '../../../../providers/user_profile_provider.dart';
import '../../../../shared/constants/user_data.dart';
import '../../../../shared/notification_utils/empty_state.dart';
import 'loading_state.dart';
import 'error_state.dart';
import 'plan_list_content.dart';

// Create a provider for tab index state
final currentTabIndexProvider = StateProvider<int>((ref) => 0);

class PlanSelectionContent extends ConsumerStatefulWidget {
  const PlanSelectionContent({super.key});

  @override
  ConsumerState<PlanSelectionContent> createState() => _PlanSelectionContentState();
}

class _PlanSelectionContentState extends ConsumerState<PlanSelectionContent> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    // Delay provider modification until after the build is complete
    Future.microtask(() {
      if (mounted) {
        ref.read(currentTabIndexProvider.notifier).state = 0;
        ref.read(userProfileProvider)
            .getUserProfileData(UserData.ins.userId ?? "");
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final selectedPlan = ref.watch(selectedPlanProvider);
    final profileProvider = ref.watch(userProfileProvider);
    final userPersonalData = profileProvider.userProfileData?.user;

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
          currentPlan: userPersonalData?.planName,
        );
      },
    );
  }
}