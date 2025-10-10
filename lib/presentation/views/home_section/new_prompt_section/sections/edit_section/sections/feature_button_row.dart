import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/prompt_edit_provider.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';

class FeatureButtonsRow extends ConsumerWidget {
  final bool isSmallScreen;

  const FeatureButtonsRow({super.key, required this.isSmallScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(promptEditProvider);
    final activeFeature = state.activeFeature;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FeatureButton(
            label: "Add Object",
            icon: AppAssets.pencil,
            isActive: activeFeature == EditFeature.addObject,
            isSmallScreen: isSmallScreen,
            onTap: () => ref.read(promptEditProvider.notifier)
                .setActiveFeature(EditFeature.addObject),
            theme: theme,
          ),
          _FeatureButton(
            label: "Remove Object",
            icon: AppAssets.editObject,
            isActive: activeFeature == EditFeature.removeObject,
            isSmallScreen: isSmallScreen,
            onTap: () => ref.read(promptEditProvider.notifier)
                .setActiveFeature(EditFeature.removeObject),
            theme: theme,
          ),
          _FeatureButton(
            label: "Remove Background",
            icon: AppAssets.removeBackground,
            isActive: activeFeature == EditFeature.removeBackground,
            isSmallScreen: isSmallScreen,
            onTap: () => ref.read(promptEditProvider.notifier)
                .setActiveFeature(EditFeature.removeBackground),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final String label;
  final String icon;
  final bool isActive;
  final bool isSmallScreen;
  final VoidCallback onTap;
  final ThemeData theme;

  const _FeatureButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isSmallScreen,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = isSmallScreen ? 40.0 : 80.0;
    final fontSize = isSmallScreen ? 10.0 : 11.0;
    final buttonWidth = isSmallScreen ? 80.0 : 100.0;

    return GestureDetector(
      onTap: null,
      // onTap: onTap,
      child: Container(
        width: buttonWidth+12,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: buttonSize + 12,
              width: buttonSize + 12,
              decoration: BoxDecoration(
                color: isActive
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  height: buttonSize - 4,
                  width: buttonSize - 4,
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary.withOpacity(0.2)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    icon,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    height: buttonSize * 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: buttonWidth,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}