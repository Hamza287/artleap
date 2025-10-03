import 'package:Artleap.ai/domain/subscriptions/subscription_repo_provider.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/constants/user_data.dart';

class HomeScreenTopBar extends ConsumerWidget {
  final VoidCallback? onMenuTap;
  const HomeScreenTopBar({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    final subscriptionAsync = ref.watch(currentSubscriptionProvider(UserData.ins.userId!));

    // Get the actual plan name from user profile
    final planName = ref.watch(userProfileProvider).userProfileData?.user.planName ?? 'Free';
    final isFreePlan = planName.toLowerCase() == 'free';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: screenWidth * 0.05,
            right: screenWidth * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Hamburger Icon
                  GestureDetector(
                    onTap: onMenuTap,
                    child: Container(
                      width: screenWidth * 0.1 > 42 ? 42 : screenWidth * 0.1,
                      height: screenWidth * 0.1 > 42 ? 42 : screenWidth * 0.1,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF923CFF), Color(0xFF6A11CB)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF923CFF).withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 16,
                              height: 2,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 16,
                              height: 2,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 16,
                              height: 2,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  // Coin container
                  InkWell(
                    onTap: () {
                      if (!isFreePlan) {
                        Navigator.of(context).pushNamed("/subscription-status");
                      } else {
                        Navigator.of(context).pushNamed("choose_plan_screen");
                      }
                    },
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(
                          color: Colors.amber.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.stackofcoins,
                            height: 20,
                            color: Colors.amber[700],
                          ),
                          SizedBox(width: screenWidth * 0.015),
                          Text(
                            "${ref.watch(userProfileProvider).userProfileData?.user.totalCredits ?? 0}",
                            style: AppTextstyle.interMedium(
                              color: Colors.amber.shade900,
                              fontSize: screenWidth * 0.035 > 14 ? 14 : screenWidth * 0.035,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Show different UI based on plan type
              isFreePlan
                  ? ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("choose_plan_screen");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF923CFF),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(86),
                  ),
                  elevation: 2,
                  shadowColor: const Color(0xFF923CFF).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      AppAssets.proBtn,
                      height: 30,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      "Get Pro",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.035 > 14 ? 14 : screenWidth * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
                  : _buildPlanBadge(planName, screenWidth),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Helper method to build the plan badge with appropriate colors
  Widget _buildPlanBadge(String planName, double screenWidth) {
    Color badgeColor;
    Color textColor;
    Color borderColor;
    IconData icon;

    // Set different colors based on plan type
    switch (planName.toLowerCase()) {
      case 'basic':
        badgeColor = Colors.blue.shade50;
        textColor = Colors.blue.shade800;
        borderColor = Colors.blue.shade300;
        icon = Icons.star_outline;
        break;
      case 'standard':
        badgeColor = Colors.purple.shade50;
        textColor = Colors.purple.shade800;
        borderColor = Colors.purple.shade300;
        icon = Icons.star_half;
        break;
      case 'premium':
        badgeColor = Colors.amber.shade50;
        textColor = Colors.amber.shade900;
        borderColor = Colors.amber.shade300;
        icon = Icons.star;
        break;
      default:
        badgeColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        borderColor = Colors.green.shade300;
        icon = Icons.verified;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 18),
          SizedBox(width: screenWidth * 0.01),
          Text(
            planName,
            style: TextStyle(
              color: textColor,
              fontSize: screenWidth * 0.035 > 14 ? 14 : screenWidth * 0.035,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}