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
    final theme = Theme.of(context);
    ref.watch(currentSubscriptionProvider(UserData.ins.userId!));
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
                  GestureDetector(
                    onTap: onMenuTap,
                    child: Container(
                      width: screenWidth * 0.1 > 42 ? 42 : screenWidth * 0.1,
                      height: screenWidth * 0.1 > 42 ? 42 : screenWidth * 0.1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
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
                              color: theme.colorScheme.onPrimary,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 16,
                              height: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 16,
                              height: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
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
                          color: Colors.amber,
                          width: 1.5,
                        ),
                        color: theme.colorScheme.surface,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.stackofcoins,
                            height: 20,
                            color: Colors.amber,
                          ),
                          SizedBox(width: screenWidth * 0.015),
                          Text(
                            "${ref.watch(userProfileProvider).userProfileData?.user.totalCredits ?? 0}",
                            style: AppTextstyle.interMedium(
                              color: Colors.amber,
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
              isFreePlan ? _buildProfessionalProButton(screenWidth, context, theme) : _buildPlanBadge(planName, screenWidth, theme),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProfessionalProButton(double screenWidth, BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.star,
                    color: theme.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "GET PRO",
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
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
                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanBadge(String planName, double screenWidth, ThemeData theme) {
    Color textColor;
    Color borderColor;
    IconData icon;
    LinearGradient? gradient;

    switch (planName.toLowerCase()) {
      case 'basic':
        gradient = LinearGradient(
          colors: [theme.colorScheme.surface, theme.colorScheme.surfaceContainerHighest],
        );
        textColor = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary.withOpacity(0.5);
        icon = Icons.star_outline;
        break;
      case 'standard':
        gradient = LinearGradient(
          colors: [theme.colorScheme.surface, theme.colorScheme.surfaceContainerHighest],
        );
        textColor = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary.withOpacity(0.5);
        icon = Icons.star_half;
        break;
      case 'premium':
        gradient = LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
        );
        textColor = theme.colorScheme.onPrimary;
        borderColor = theme.colorScheme.primary;
        icon = Icons.star;
        break;
      default:
        gradient = LinearGradient(
          colors: [theme.colorScheme.surface, theme.colorScheme.surfaceContainerHighest],
        );
        textColor = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary.withOpacity(0.5);
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