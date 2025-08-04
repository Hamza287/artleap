import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import '../../../../domain/api_services/api_response.dart';
import '../../../../domain/subscriptions/subscription_model.dart';
import '../../../../domain/subscriptions/subscription_repo_provider.dart';
import '../../home_section/bottom_nav_bar.dart';

// Add this provider at the top of your file (outside the class)
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
          final isLoading = ref.watch(cancelSubscriptionLoadingProvider);
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(24),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(16),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.1),
                //         blurRadius: 20,
                //         spreadRadius: 2,
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         children: [
                //           Container(
                //             padding: const EdgeInsets.all(8),
                //             decoration: BoxDecoration(
                //               color: AppColors.redColor.withOpacity(0.1),
                //               borderRadius: BorderRadius.circular(12),
                //             ),
                //             child: Icon(
                //               Icons.unsubscribe,
                //               color: AppColors.redColor,
                //               size: 28,
                //             ),
                //           ),
                //           const SizedBox(width: 12),
                //           Text(
                //             'Cancel Subscription',
                //             style: AppTextstyle.interBold(
                //               fontSize: 20,
                //               color: AppColors.darkBlue,
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 20),
                //       Text(
                //         'How would you like to cancel your subscription?',
                //         style: AppTextstyle.interRegular(
                //           fontSize: 16,
                //           color: AppColors.darkBlue.withOpacity(0.8),
                //         ),
                //       ),
                //       const SizedBox(height: 24),
                //       Column(
                //         children: [
                //           _buildCancelOption(
                //             context,
                //             ref,
                //             icon: Icons.calendar_today,
                //             title: 'End of Billing Period',
                //             subtitle:
                //             'Continue benefits until ${DateFormat('MMM d, y').format(subscription.endDate)}',
                //             isImmediate: false,
                //             isLoading: isLoading,
                //           ),
                //           const SizedBox(height: 12),
                //           // _buildCancelOption(
                //           //   context,
                //           //   ref,
                //           //   icon: Icons.block,
                //           //   title: 'Cancel Immediately',
                //           //   subtitle: 'Lose access to premium features now',
                //           //   isImmediate: true,
                //           //   isLoading: isLoading,
                //           // ),
                //         ],
                //       ),
                //       const SizedBox(height: 24),
                //       TextButton(
                //         onPressed: isLoading ? null : () => Navigator.pop(context),
                //         style: TextButton.styleFrom(
                //           padding: const EdgeInsets.symmetric(vertical: 12),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         child: Text(
                //           'Go Back',
                //           style: AppTextstyle.interMedium(
                //             fontSize: 16,
                //             color: AppColors.darkBlue.withOpacity(0.6),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Warning Icon
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          color: AppColors.redColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline_sharp,
                          size: 36,
                          color: AppColors.redColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'Cancel Plan',
                        style: AppTextstyle.interBold(
                          fontSize: 24,
                          color: AppColors.darkBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Message
                      Text(
                        'You wont be charged for the next month, but can continue remaining benefits until ${DateFormat('MMM d, y').format(subscription.endDate)}',
                        style: AppTextstyle.interRegular(
                          fontSize: 16,
                          color: AppColors.darkBlue.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Cancel Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: AppColors.darkBlue),
                              ),
                              child: Text(
                                'Cancel',
                                style: AppTextstyle.interMedium(
                                  color: AppColors.darkBlue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Delete Button
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
                                backgroundColor: AppColors.redColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Delete',
                                style: AppTextstyle.interMedium(
                                  color: Colors.white,
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
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
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

  static Widget _buildCancelOption(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isImmediate,
    required bool isLoading,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: isLoading
          ? null
          : () {
              ref.read(cancelSubscriptionLoadingProvider.notifier).state = true;
              Navigator.pop(context, isImmediate);
            },
      child: Opacity(
        opacity: isLoading ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isImmediate
                ? AppColors.redColor.withOpacity(0.05)
                : AppColors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isImmediate
                  ? AppColors.redColor.withOpacity(0.2)
                  : AppColors.blue.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isImmediate
                      ? AppColors.redColor.withOpacity(0.1)
                      : AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isImmediate ? AppColors.redColor : AppColors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextstyle.interBold(
                        fontSize: 16,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextstyle.interRegular(
                        fontSize: 14,
                        color: AppColors.darkBlue.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.darkBlue.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
