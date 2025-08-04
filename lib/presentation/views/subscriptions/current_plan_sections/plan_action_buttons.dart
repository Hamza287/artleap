import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import '../../../../domain/subscriptions/subscription_model.dart';
import '../choose_plan_screen.dart';
import 'cancel_subscription_dialog.dart';


class ActionButtons extends StatelessWidget {
  final bool isActive;
  final UserSubscriptionModel? subscription;

  const ActionButtons({
    super.key,
    required this.isActive,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
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
                  isActive && subscription!.planSnapshot?.name != 'Free' ? 'Change Plan' : 'Subscribe Now',
                  style: AppTextstyle.interBold(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (isActive && subscription!.planSnapshot?.name != 'Free')
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    CancelSubscriptionDialog.show(context, ref, subscription!);
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
      },
    );
  }
}