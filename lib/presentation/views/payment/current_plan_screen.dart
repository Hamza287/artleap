import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:intl/intl.dart';
import '../../../domain/subscription_model/subscription_moderl.dart';
import '../../../providers/subscription_provider.dart';

class SubscriptionStatusScreen extends ConsumerWidget {
  static const routeName = '/subscription-status';

  const SubscriptionStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    final isActive = subscription.status == 'Active';
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? 40 : 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              // Current Plan Card
              _buildCurrentPlanCard(subscription, context),
              const SizedBox(height: 30),
        
              // Usage Statistics
              _buildUsageSection(subscription, context),
              const SizedBox(height: 30),
        
              // Plan Features
              _buildFeaturesSection(subscription),
              const SizedBox(height: 30),
        
              // Billing Information
              _buildBillingSection(subscription, context),
              const SizedBox(height: 30),
        
              // Action Buttons
              _buildActionButtons(context, isActive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard(SubscriptionModel subscription, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getPlanColor(subscription.currentPlan).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getPlanColor(subscription.currentPlan).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscription.currentPlan,
                style: AppTextstyle.interBold(
                  fontSize: 24,
                  color: _getPlanColor(subscription.currentPlan),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: subscription.status == 'Active'
                      ? AppColors.green.withOpacity(0.1)
                      : AppColors.redColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: subscription.status == 'Active'
                        ? AppColors.green
                        : AppColors.redColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  subscription.status,
                  style: AppTextstyle.interMedium(
                    fontSize: 14,
                    color: subscription.status == 'Active'
                        ? AppColors.green
                        : AppColors.redColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: subscription.remainingGenerations / subscription.totalGenerations,
            backgroundColor: AppColors.white.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              _getPlanColor(subscription.currentPlan),
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${subscription.remainingGenerations} of ${subscription.totalGenerations} generations left',
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: AppColors.darkBlue.withOpacity(0.7),
                ),
              ),
              Text(
                '${((subscription.remainingGenerations / subscription.totalGenerations) * 100).toStringAsFixed(0)}% remaining',
                style: AppTextstyle.interMedium(
                  fontSize: 14,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageSection(SubscriptionModel subscription, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Statistics',
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 15),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              icon: Icons.auto_awesome,
              title: 'Daily Limit',
              value: '${subscription.totalGenerations}',
              color: AppColors.purple,
            ),
            _buildStatCard(
              icon: Icons.data_usage,
              title: 'Used Today',
              value: '${subscription.totalGenerations - subscription.remainingGenerations}',
              color: AppColors.blue,
            ),
            _buildStatCard(
              icon: Icons.timer,
              title: 'Reset In',
              value: '24 hours',
              color: Colors.amber,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: AppColors.darkBlue.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextstyle.interBold(
                  fontSize: 20,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(SubscriptionModel subscription) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan Features',
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: subscription.features.map((feature) {
            return Chip(
              label: Text(
                feature,
                style: AppTextstyle.interMedium(
                  fontSize: 14,
                  color: AppColors.darkBlue,
                ),
              ),
              backgroundColor: AppColors.white.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppColors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBillingSection(SubscriptionModel subscription, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Billing Information',
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildBillingRow(
                icon: Icons.calendar_today,
                title: 'Next Billing Date',
                value: DateFormat('MMMM d, y').format(subscription.nextBillingDate),
              ),
              const Divider(height: 24, thickness: 0.5),
              _buildBillingRow(
                icon: Icons.payment,
                title: 'Payment Method',
                value: 'VISA •••• 4242',
              ),
              const Divider(height: 24, thickness: 0.5),
              _buildBillingRow(
                icon: Icons.receipt,
                title: 'Last Invoice',
                value: 'View Receipt',
                isClickable: true,
                onTap: () {
                  // Handle view receipt action
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillingRow({
    required IconData icon,
    required String title,
    required String value,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isClickable ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.darkBlue.withOpacity(0.6)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextstyle.interRegular(
                  fontSize: 15,
                  color: AppColors.darkBlue.withOpacity(0.7),
                ),
              ),
            ),
            Text(
              value,
              style: AppTextstyle.interMedium(
                fontSize: 15,
                color: isClickable ? AppColors.blue : AppColors.darkBlue,
              ),
            ),
            if (isClickable) const SizedBox(width: 4),
            if (isClickable)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.blue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isActive) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Handle upgrade/downgrade plan
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
              isActive ? 'Change Plan' : 'Subscribe Now',
              style: AppTextstyle.interBold(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        if (isActive)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                // Handle cancel subscription
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.redColor,
                side: const BorderSide(color: AppColors.redColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancel Subscription',
                style: AppTextstyle.interBold(
                  fontSize: 16,
                  color: AppColors.redColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getPlanColor(String planName) {
    switch (planName.toLowerCase()) {
      case 'premium':
        return AppColors.purple;
      case 'standard':
        return AppColors.blue;
      case 'basic':
        return AppColors.green;
      default:
        return AppColors.darkBlue;
    }
  }
}