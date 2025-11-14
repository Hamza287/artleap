import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class UsageSection extends StatelessWidget {
  final UserSubscriptionModel? subscription;
  final User? userPersonalData;
  const UsageSection(
      {super.key, required this.subscription, this.userPersonalData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String getSubscriptionEndDate(DateTime? endDate, String planName) {
      if (endDate != null && planName != 'Free') {
        final currentDate = DateTime.now();
        final difference = endDate.difference(currentDate).inDays;

        return difference >= 0 ? '$difference Days' : 'Expired';
      } else {
        return '1 Day';
      }
    }

    if (userPersonalData == null) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Statistics',
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
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
                value: '${userPersonalData!.usedImageCredits}',
                color: Colors.amberAccent.shade200,
                theme: theme,
              ),
              _buildStatCard(
                imageAsset: AppAssets.stackofcoins,
                title: 'Prompt Credits',
                value: '${userPersonalData!.usedPromptCredits}',
                color: Colors.amberAccent.shade200,
                theme: theme,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildResetCard(
          title: 'End in',
          value: getSubscriptionEndDate(
              subscription?.endDate, userPersonalData?.planName ?? ''),
          color: theme.colorScheme.primary,
          width: MediaQuery.of(context).size.width,
          isResetCard: true,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String imageAsset,
    required String title,
    required String value,
    required Color color,
    required ThemeData theme,
    double? width,
    bool isResetCard = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
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
                      color: theme.colorScheme.onSurface,
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
                  color: theme.colorScheme.onSurfaceVariant,
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
    required ThemeData theme,
    double? width,
    bool isResetCard = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Icon(
                Icons.timer,
                color: color,
                size: 20,
              ),
              Text(
                isResetCard ? title : 'Used $title',
                style: AppTextstyle.interRegular(
                  fontSize: constraints.maxWidth < 150 ? 12 : 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: AppTextstyle.interBold(
                  fontSize: constraints.maxWidth < 150 ? 20 : 25,
                  color: theme.colorScheme.onSurface,
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
