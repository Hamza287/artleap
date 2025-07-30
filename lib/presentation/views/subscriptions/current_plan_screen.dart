import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import '../../../domain/subscriptions/subscription_repo_provider.dart';
import 'choose_plan_screen.dart';
import 'current_plan_sections/billing_section.dart';
import 'current_plan_sections/current_plan_card.dart';
import 'current_plan_sections/plan_action_buttons.dart';
import 'current_plan_sections/plan_usage_section.dart';


class CurrentPlanScreen extends ConsumerStatefulWidget {
  static const String routeName = '/subscription-status';

  const CurrentPlanScreen({super.key});

  @override
  ConsumerState<CurrentPlanScreen> createState() => _CurrentPlanScreenState();
}

class _CurrentPlanScreenState extends ConsumerState<CurrentPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserData.ins.userId != null) {
        ref.refresh(currentSubscriptionProvider(UserData.ins.userId!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = UserData.ins.userId;

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'User not authenticated',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: AppColors.redColor,
            ),
          ),
        ),
      );
    }

    final subscriptionAsync = ref.watch(currentSubscriptionProvider(userId));
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Subscription',
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
        child: subscriptionAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: $error',
                  style: AppTextstyle.interRegular(
                    fontSize: 16,
                    color: AppColors.redColor,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.refresh(currentSubscriptionProvider(userId));
                      print(error);
                    } catch (e) {
                      print('Error during refresh: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: AppTextstyle.interBold(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          data: (subscription) {
            final isActive = subscription?.isActive == true ;
            final planName = subscription?.plan?.name ?? 'Free';
            if(subscription?.cancelledAt != null){
                return  Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You do not have any Subscription Right Now ',
                          style: AppTextstyle.interRegular(
                            fontSize: 16,
                            color: AppColors.redColor,
                          ),
                        ),
                        10.spaceY,
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, ChoosePlanScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Subscribe Now',
                              style: AppTextstyle.interBold(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            } else {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth > 600 ? 40 : 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    CurrentPlanCard(
                      planName: planName,
                      isActive: isActive,
                      subscription: subscription,
                    ),
                    const SizedBox(height: 30),
                    UsageSection(subscription: subscription),
                    const SizedBox(height: 30),
                    if (subscription != null)
                      BillingSection(subscription: subscription),
                    const SizedBox(height: 30),
                    ActionButtons(
                      isActive: isActive,
                      subscription: subscription,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}