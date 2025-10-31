import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import '../../../domain/subscriptions/subscription_repo_provider.dart';
import '../../../providers/user_profile_provider.dart';
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
        ref.read(currentSubscriptionProvider(UserData.ins.userId!));
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(userProfileProvider)
          .getUserProfileData(UserData.ins.userId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = UserData.ins.userId;
    final profileProvider = ref.watch(userProfileProvider);
    final userPersonalData = profileProvider.userProfileData?.user;

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'User not authenticated',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: theme.colorScheme.error,
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
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: subscriptionAsync.when(
          loading: () => Center(
              child:
                  CircularProgressIndicator(color: theme.colorScheme.primary)),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: $error',
                  style: AppTextstyle.interRegular(
                    fontSize: 16,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.refresh(currentSubscriptionProvider(userId));
                    } catch (e) {
                      debugPrint('Error during refresh: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: AppTextstyle.interBold(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          data: (subscription) {
            if (subscription!.paymentMethod!.toLowerCase() != 'stripe' &&
                (subscription.cancelledAt != null ||
                    !subscription.isActive ||
                    !subscription.autoRenew
                )) {
              return _buildNoSubscriptionUI(context, theme);
            }

            final planName = subscription.planSnapshot?.name ?? 'Free';
            final isActive = subscription.isActive;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 600 ? 40 : 20,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height - kToolbarHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CurrentPlanCard(
                      planName: planName,
                      isActive: isActive,
                      subscription: subscription,
                      userPersonalData: userPersonalData,
                    ),
                    const SizedBox(height: 30),
                    UsageSection(
                        subscription: subscription,
                        userPersonalData: userPersonalData),
                    const SizedBox(height: 30),
                    BillingSection(subscription: subscription),
                    const SizedBox(height: 30),
                    ActionButtons(
                      isActive: isActive,
                      subscription: subscription,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoSubscriptionUI(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.credit_card_outlined,
                size: 60,
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Active Subscription',
              style: AppTextstyle.interBold(
                fontSize: 24,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Unlock premium features and enhance your experience with our flexible subscription plans tailored to your needs.',
              style: AppTextstyle.interRegular(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildBenefitsList(theme),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChoosePlanScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Explore Plans',
                      style: AppTextstyle.interBold(
                        fontSize: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {

              },
              child: Text(
                'Need help choosing? Contact support',
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsList(ThemeData theme) {
    final benefits = [
      {'icon': Icons.auto_awesome, 'text': 'Premium features'},
      {'icon': Icons.speed, 'text': 'Faster processing'},
      {'icon': Icons.storage, 'text': 'More storage'},
      {'icon': Icons.support_agent, 'text': 'Priority support'},
    ];

    return Column(
      children: benefits
          .map((benefit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        benefit['icon'] as IconData,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      benefit['text'] as String,
                      style: AppTextstyle.interRegular(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
