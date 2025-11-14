import 'package:Artleap.ai/widgets/common/custom_pro_icon_widget.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class PrivacySelectionSection extends ConsumerWidget {
  final bool isPremiumUser;
  const PrivacySelectionSection({super.key,required this.isPremiumUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedPrivacy = ref.watch(generateImageProvider).selectedPrivacy;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ImagePrivacy.values.map((privacy) {
          final isPremiumFeature = !isPremiumUser && privacy != ImagePrivacy.public;

          return _buildIconRadioOption(
            privacy: privacy,
            isSelected: privacy == selectedPrivacy,
            onTap: () {
              if (!isPremiumFeature) {
                ref.read(generateImageProvider.notifier).selectedPrivacy = privacy;
              } else {
                DialogService.showPremiumUpgrade(
                  context: context,
                  featureName: "${privacy.title} Privacy",
                    onConfirm: (){
                      Navigator.of(context).pushNamed(ChoosePlanScreen.routeName);
                    }
                );
              }
            },
            theme: theme,
            isPremiumFeature: isPremiumFeature,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconRadioOption({
    required ImagePrivacy privacy,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isPremiumFeature,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 100,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    privacy.icon,
                    size: 18,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  Text(
                    privacy.title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isPremiumFeature)
          Positioned(
            top: -8,
            right: -8,
            child: ProIconBadge(size: 14),
          ),
      ],
    );
  }
}