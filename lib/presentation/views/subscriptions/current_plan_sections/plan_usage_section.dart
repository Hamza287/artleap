import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import '../../../../domain/api_models/user_profile_model.dart';
import '../../../../domain/subscriptions/subscription_model.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constants/app_assets.dart';

class UsageSection extends StatelessWidget {
  final UserSubscriptionModel? subscription;
  final User? userPersonalData;
  const UsageSection({super.key, required this.subscription, this.userPersonalData});

  @override
  Widget build(BuildContext context) {
    // Show loading indicator if userPersonalData is null
    if (userPersonalData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
        SizedBox(
          height: 120, // Fixed height to ensure layout stability
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.7,
            children: [
              _buildStatCard(
                imageAsset: AppAssets.stackofcoins,
                title: 'Image Credits',
                value: '${userPersonalData!.usedImageCredits ?? 0}',
                color: Colors.amber,
              ),
              _buildStatCard(
                imageAsset: AppAssets.stackofcoins,
                title: 'Prompt Credits',
                value: '${userPersonalData!.usedPromptCredits ?? 0}',
                color: Colors.amber,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildResetCard(
          title: 'Reset In',
          value: subscription?.endDate != null && userPersonalData?.planType != 'free'
              ? DateFormat('MMM dd, yyyy').format(subscription!.endDate)
              : '1 Day',
          color: Colors.amber,
          width: MediaQuery.of(context).size.width,
          isResetCard: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String imageAsset,
    required String title,
    required String value,
    required Color color,
    double? width,
    bool isResetCard = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: width,
          padding: const EdgeInsets.all(10),
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
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTextstyle.interBold(
                      fontSize: constraints.maxWidth < 150 ? 20 : 25,
                      color: AppColors.darkBlue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      imageAsset,
                      width: 24,
                      height: 24,
                      color: color,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.error,
                        color: color,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                isResetCard ? title : 'Used $title',
                style: AppTextstyle.interRegular(
                  fontSize: constraints.maxWidth < 150 ? 12 : 14,
                  color: AppColors.darkBlue.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResetCard({
    required String title,
    required String value,
    required Color color,
    double? width,
    bool isResetCard = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: width,
          padding: const EdgeInsets.all(10),
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
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Icon(Icons.timer,color: Colors.amber,size: 20,),
              Text(
                isResetCard ? title : 'Used $title',
                style: AppTextstyle.interRegular(
                  fontSize: constraints.maxWidth < 150 ? 12 : 14,
                  color: AppColors.darkBlue.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: AppTextstyle.interBold(
                  fontSize: constraints.maxWidth < 150 ? 20 : 25,
                  color: AppColors.darkBlue,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}