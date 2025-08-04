import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

import 'coming_soon_button.dart';
import 'info_row.dart';


class SubscriptionCard extends StatelessWidget {
  final String status;
  final String planName;
  final String planType;
  final String? currentSubscription;
  final bool isSubscribed;

  const SubscriptionCard({
    super.key,
    required this.status,
    required this.planName,
    required this.planType,
    this.currentSubscription,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subscription",
                  style: AppTextstyle.interBold(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                _StatusChip(status: status),
              ],
            ),
            const SizedBox(height: 16),
            if (planName.isNotEmpty)
              InfoRow(
                label: "Plan",
                value: "$planName ($planType)",
                icon: Icons.credit_card_outlined,
              ),
            if (currentSubscription != null)
              InfoRow(
                label: "Subscription ID",
                value: currentSubscription!,
                icon: Icons.receipt_outlined,
              ),
            const SizedBox(height: 16),
            ComingSoonButton(
              label: isSubscribed ? "Manage Subscription" : "Upgrade Plan",
              icon: Icons.credit_card,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'active':
        chipColor = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'trial':
        chipColor = Colors.blue;
        icon = Icons.timer_outlined;
        break;
      case 'canceled':
        chipColor = Colors.orange;
        icon = Icons.cancel_outlined;
        break;
      default:
        chipColor = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: chipColor),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}