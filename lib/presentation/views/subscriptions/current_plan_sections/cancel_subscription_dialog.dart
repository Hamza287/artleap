import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import '../../../../domain/api_services/api_response.dart';
import '../../../../domain/subscriptions/subscription_model.dart';
import '../../../../domain/subscriptions/subscription_repo_provider.dart';
import '../../home_section/bottom_nav_bar.dart';

final cancelSubscriptionLoadingProvider = StateProvider<bool>((ref) => false);

class CancelSubscriptionDialog {
  static Future<void> show(
      BuildContext context,
      WidgetRef ref,
      UserSubscriptionModel subscription,
      ) async {
    bool? immediate = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final theme = Theme.of(context);
          final isLoading = ref.watch(cancelSubscriptionLoadingProvider);
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.3),
                        blurRadius: 32,
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline_sharp,
                          size: 36,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Cancel Plan',
                        style: AppTextstyle.interBold(
                          fontSize: 24,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You wont be charged for the next month, but can continue remaining benefits until ${DateFormat('MMM d, y').format(subscription.endDate)}',
                        style: AppTextstyle.interRegular(
                          fontSize: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                side: BorderSide(color: theme.colorScheme.outline),
                              ),
                              child: Text(
                                'Cancel',
                                style: AppTextstyle.interMedium(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                ref
                                    .read(
                                    cancelSubscriptionLoadingProvider
                                        .notifier)
                                    .state = true;
                                Navigator.pop(context, false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Delete',
                                style: AppTextstyle.interMedium(
                                  color: theme.colorScheme.onError,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: theme.colorScheme.scrim.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );

    if (immediate != null && context.mounted) {
      try {
        ref.read(cancelSubscriptionLoadingProvider.notifier).state = true;
        final response = await ref
            .read(subscriptionServiceProvider)
            .cancelSubscription(UserData.ins.userId!, immediate);

        if (response.status == Status.completed && response.data != null) {
          if (context.mounted) {
            appSnackBar(
              'Success',
              immediate
                  ? 'Subscription cancelled successfully'
                  : 'Subscription will end on ${DateFormat('MMM d, y').format(subscription.endDate)}',
              Colors.green,
            );
            ref.refresh(currentSubscriptionProvider(UserData.ins.userId!));
            Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
          }
        } else if (context.mounted) {
          appSnackBar(
            'Error',
            response.message ?? 'Failed to cancel subscription',
            Colors.red,
          );
        }
      } catch (e) {
        if (context.mounted) {
          appSnackBar('Error', 'Failed to Cancel Subscription: $e', Colors.red);
        }
      } finally {
        ref.read(cancelSubscriptionLoadingProvider.notifier).state = false;
      }
    }
  }
}