import 'dart:io';
import 'plan_list_content.dart';
import 'package:Artleap.ai/shared/route_export.dart';

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
      loading: () => const LoadingState(
        useShimmer: true,
        shimmerItemCount: 3,
      ),
      error: (e, s) => ErrorState(
        message: _getErrorMessage(e),
        onRetry: () => ref.invalidate(subscriptionPlansProvider),
        icon: Icons.credit_card_off,
      ),
      data: (plans) {
        if (plans.isEmpty) {
          return EmptyState(
            icon: Icons.credit_card_off,
            title: 'No Subscription Plans',
            subtitle: 'We couldn\'t find any available subscription plans at the moment.',
            iconColor: Theme.of(context).colorScheme.primary,
          );
        }

        final filteredPlans = plans.where((plan) {
          if (Platform.isIOS) return plan.appleProductId.isNotEmpty;
          if (Platform.isAndroid) return plan.googleProductId.isNotEmpty;
          return false;
        }).toList();

        if (filteredPlans.isEmpty) {
          return EmptyState(
            icon: Icons.smartphone_outlined,
            title: 'Platform Not Supported',
            subtitle: 'No subscription plans available for your device platform.',
            iconColor: Theme.of(context).colorScheme.error,
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
                  color: const Color(0xFFB58F48),
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

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('network') || error.toString().contains('connection')) {
      return 'Network error - Please check your connection';
    } else if (error.toString().contains('unauthorized') || error.toString().contains('401')) {
      return 'Authentication failed - Please login again';
    } else {
      return 'Failed to load subscription plans';
    }
  }
}