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

    final subscriptionAsync =
    ref.watch(currentSubscriptionProvider(UserData.ins.userId!));
    final planName =
        ref.watch(userProfileProvider).userProfileData?.user.planName ?? 'Free';
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
                              fontSize: screenWidth * 0.035 > 14
                                  ? 14
                                  : screenWidth * 0.035,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isFreePlan ? _buildProfessionalProButton(screenWidth, context) : _buildPlanBadge(planName, screenWidth),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProfessionalProButton(double screenWidth, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFFFF8C00).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("choose_plan_screen");
          },
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD700),
                  Color(0xFFFFA500),
                  Color(0xFFFF8C00),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.white, Color(0xFFFFF8E1)],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "GET PRO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                    screenWidth * 0.035 > 14 ? 14 : screenWidth * 0.035,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced Plan Badge with professional look
  Widget _buildPlanBadge(String planName, double screenWidth) {
    Color badgeColor;
    Color textColor;
    Color borderColor;
    IconData icon;
    LinearGradient? gradient;

    // Set different colors based on plan type
    switch (planName.toLowerCase()) {
      case 'basic':
        gradient = const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
        );
        textColor = const Color(0xFF1976D2);
        borderColor = const Color(0xFF64B5F6);
        icon = Icons.star_outline;
        break;
      case 'standard':
        gradient = const LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
        );
        textColor = const Color(0xFF7B1FA2);
        borderColor = const Color(0xFFBA68C8);
        icon = Icons.star_half;
        break;
      case 'premium':
        gradient = const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
        );
        textColor = const Color(0xFFF57C00);
        borderColor = const Color(0xFFFFB74D);
        icon = Icons.star;
        break;
      default:
        gradient = const LinearGradient(
          colors: [Color(0xFFE8F5E8), Color(0xFFC8E6C9)],
        );
        textColor = const Color(0xFF388E3C);
        borderColor = const Color(0xFF81C784);
        icon = Icons.verified;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            planName.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: screenWidth * 0.032 > 13 ? 13 : screenWidth * 0.032,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
