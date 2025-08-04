import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import '../../../../domain/subscriptions/subscription_model.dart';
import '../../../../domain/subscriptions/subscription_repo_provider.dart';

class UsageSection extends StatelessWidget {
  final UserSubscriptionModel? subscription;

  const UsageSection({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final imageLimits = ref.watch(generationLimitsProvider({
          'userId': UserData.ins.userId!,
          'generationType': 'image',
        }));
        final promptLimits = ref.watch(generationLimitsProvider({
          'userId': UserData.ins.userId!,
          'generationType': 'prompt',
        }));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Statistics',
              style: AppTextstyle.interBold(
                fontSize: 18,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.5,
              children: [
                imageLimits.when(
                  loading: () => _buildStatCard(
                    icon: Icons.auto_awesome,
                    title: 'Image Credits',
                    value: 'Loading...',
                    color: AppColors.purple,
                  ),
                  error: (error, stack) => _buildStatCard(
                    icon: Icons.error,
                    title: 'Image Credits',
                    value: 'Error',
                    color: AppColors.redColor,
                  ),
                  data: (limits) => _buildStatCard(
                    icon: Icons.auto_awesome,
                    title: 'Image Credits',
                    value: '${limits.remaining}/${subscription?.planSnapshot?.imageGenerationCredits ?? 0}',
                    color: AppColors.purple,
                  ),
                ),
                promptLimits.when(
                  loading: () => _buildStatCard(
                    icon: Icons.text_fields,
                    title: 'Prompt Credits',
                    value: 'Loading...',
                    color: AppColors.blue,
                  ),
                  error: (error, stack) => _buildStatCard(
                    icon: Icons.error,
                    title: 'Prompt Credits',
                    value: 'Error',
                    color: AppColors.redColor,
                  ),
                  data: (limits) => _buildStatCard(
                    icon: Icons.text_fields,
                    title: 'Prompt Credits',
                    value: '${limits.remaining}/${subscription?.planSnapshot?.promptGenerationCredits ?? 0}',
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildStatCard(
              icon: Icons.timer,
              title: 'Reset In',
              value: subscription?.endDate != null
                  ? '${subscription!.endDate.difference(DateTime.now()).inDays} days'
                  : 'N/A',
              color: Colors.amber,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    double? width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: AppColors.darkBlue.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextstyle.interBold(
                  fontSize: 20,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}