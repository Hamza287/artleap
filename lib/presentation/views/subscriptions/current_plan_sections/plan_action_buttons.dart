import 'package:Artleap.ai/presentation/views/common/dialog_box/payment_method_guide_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void _handleCancelSubscription(BuildContext context, WidgetRef ref) {
    final paymentMethod = subscription?.paymentMethod?.toLowerCase() ?? '';

    if (paymentMethod == 'stripe') {
      CancelSubscriptionDialog.show(context, ref, subscription!);
    } else if (paymentMethod == 'google_play' || paymentMethod == 'google_pay') {
      PaymentMethodGuideDialog.show(
        context: context,
        title: 'Cancel Google Play Subscription',
        message: 'To cancel your subscription, please visit the Google Play Store:\n\n'
            '1. Open Google Play Store\n'
            '2. Tap your profile icon\n'
            '3. Go to "Payments & subscriptions" → "Subscriptions"\n'
            '4. Find "Artleap.ai" and cancel your subscription',
        paymentMethod: 'google_play',
      );
    } else if (paymentMethod == 'apple' || paymentMethod == 'appstore') {
      PaymentMethodGuideDialog.show(
        context: context,
        title: 'Cancel Apple App Store Subscription',
        message: 'To cancel your subscription, please visit the App Store:\n\n'
            '1. Open Settings app\n'
            '2. Tap your name\n'
            '3. Go to "Subscriptions"\n'
            '4. Find "Artleap.ai" and cancel your subscription',
        paymentMethod: 'apple',
      );
    } else {
      PaymentMethodGuideDialog.show(
        context: context,
        title: 'Cancel Subscription',
        message: 'Please contact our support team or visit the platform '
            'where you originally purchased the subscription to cancel.',
        paymentMethod: 'other',
      );
    }
  }

  bool get _shouldShowCancelButton {
    if (!isActive) return false;
    if (subscription == null) return false;
    if (subscription!.planSnapshot?.type == 'free') return false;
    if (subscription!.autoRenew != true) return false;

    final paymentMethod = subscription!.paymentMethod?.toLowerCase();
    return paymentMethod != null && paymentMethod.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = Theme.of(context);
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
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isActive && subscription?.planSnapshot?.name != 'Free'
                      ? 'Change Plan'
                      : 'Subscribe Now',
                  style: AppTextstyle.interBold(
                    fontSize: 16,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (_shouldShowCancelButton)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    _handleCancelSubscription(context, ref);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel Subscription',
                    style: AppTextstyle.interBold(
                      fontSize: 16,
                      color: theme.colorScheme.error,
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