import 'package:intl/intl.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class BillingSection extends StatelessWidget {
  final UserSubscriptionModel subscription;

  const BillingSection({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Billing Information',
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildBillingRow(
                icon: Icons.calendar_today,
                title: 'Start Date',
                value: DateFormat('MMMM d, y').format(subscription.startDate),
                theme: theme,
              ),

              if(subscription.isActive && subscription.planSnapshot?.name != 'Free') ... [
                const Divider(height: 24, thickness: 0.5),
                _buildBillingRow(
                  icon: Icons.calendar_today,
                  title: 'End Date',
                  value: DateFormat('MMMM d, y').format(subscription.endDate),
                  theme: theme,
                ),
              ],
              if (subscription.paymentMethod != null) ...[
                const Divider(height: 24, thickness: 0.5),
                _buildBillingRow(
                  icon: Icons.payment,
                  title: 'Payment Method',
                  value: subscription.paymentMethod!,
                  theme: theme,
                ),
              ],
              if (subscription.cancelledAt != null) ...[
                const Divider(height: 24, thickness: 0.5),
                _buildBillingRow(
                  icon: Icons.block,
                  title: 'Cancelled On',
                  value: DateFormat('MMMM d, y').format(subscription.cancelledAt!),
                  theme: theme,
                ),
              ],
              if (subscription.isTrial) ...[
                const Divider(height: 24, thickness: 0.5),
                _buildBillingRow(
                  icon: Icons.star,
                  title: 'Trial Status',
                  value: 'Active Trial',
                  theme: theme,
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
    required ThemeData theme,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isClickable ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextstyle.interRegular(
                  fontSize: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextstyle.interMedium(
                fontSize: 15,
                color: isClickable ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            ),
            if (isClickable) const SizedBox(width: 4),
            if (isClickable)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}