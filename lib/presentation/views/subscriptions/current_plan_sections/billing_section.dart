import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../domain/subscriptions/subscription_model.dart';

class BillingSection extends StatelessWidget {
  final UserSubscriptionModel subscription;

  const BillingSection({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
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
                title: 'Start Date',
                value: DateFormat('MMMM d, y').format(subscription.startDate),
              ),
              const Divider(height: 24, thickness: 0.5),
              if(subscription.isActive && subscription.planSnapshot?.name != 'Free') ... [
                _buildBillingRow(
                  icon: Icons.calendar_today,
                  title: 'End Date',
                  value: DateFormat('MMMM d, y').format(subscription.endDate),
                ),
              ],
              if (subscription.paymentMethod != null) ...[
                const Divider(height: 24, thickness: 0.5),
                _buildBillingRow(
                  icon: Icons.payment,
                  title: 'Payment Method',
                  value: subscription.paymentMethod!,
                ),
              ],
              if (subscription.cancelledAt != null) ...[
                const Divider(height: 24, thickness: 0.5),
                _buildBillingRow(
                  icon: Icons.block,
                  title: 'Cancelled On',
                  value: DateFormat('MMMM d, y').format(subscription.cancelledAt!),
                ),
              ],
              if (subscription.isTrial) ...[
                const Divider(height: 24, thickness: 0.5),
                _buildBillingRow(
                  icon: Icons.star,
                  title: 'Trial Status',
                  value: 'Active Trial',
                ),
              ],
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
}