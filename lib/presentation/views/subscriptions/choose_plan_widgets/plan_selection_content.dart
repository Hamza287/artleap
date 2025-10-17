import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../../../../domain/subscriptions/subscription_repo_provider.dart';
import '../../../../providers/user_profile_provider.dart';
import '../../../../shared/constants/user_data.dart';
import 'plan_list_content.dart';
import 'loading_state.dart';
import 'error_state.dart';
import '../../../../shared/notification_utils/empty_state.dart';

final currentTabIndexProvider = StateProvider<int>((ref) => 0);

class PlanSelectionContent extends ConsumerStatefulWidget {
  const PlanSelectionContent({super.key});

  @override
  ConsumerState<PlanSelectionContent> createState() => _PlanSelectionContentState();
}

class _PlanSelectionContentState extends ConsumerState<PlanSelectionContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(currentTabIndexProvider.notifier).state = 0;
        ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final screenSize = MediaQuery.of(context).size;

    return plansAsync.when(
      loading: () => const LoadingState(),
      error: (e, s) => ErrorState(e),
      data: (plans) {
        if (plans.isEmpty) {
          return const EmptyState(
            icon: Icons.error,
            title: 'No Plans',
            subtitle: 'No active plans were found.',
          );
        }
        final filteredPlans = plans.where((plan) {
          if (Platform.isIOS) return plan.appleProductId.isNotEmpty;
          if (Platform.isAndroid) return plan.googleProductId.isNotEmpty;
          return false;
        }).toList();

        if (filteredPlans.isEmpty) {
          return const EmptyState(
            icon: Icons.error,
            title: 'No Plans Available',
            subtitle: 'No valid subscription plans for this platform',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: screenSize.height * 0.01),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFB58F48), // warm/golden
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Welcome to Artleap Subscribe Now",
                  style: AppTextstyle.interMedium(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "10% OFF",
                    style: AppTextstyle.interBold(
                      fontSize: screenSize.width * 0.14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.008),
                  Text(
                    "Get this exclusive limited offer!",
                    style: AppTextstyle.interMedium(
                      fontSize: screenSize.width * 0.037,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            PlanListContent(
              plans: filteredPlans,
            ),
            SizedBox(height: screenSize.height * 0.02),
          ],
        );
      },
    );
  }
}
