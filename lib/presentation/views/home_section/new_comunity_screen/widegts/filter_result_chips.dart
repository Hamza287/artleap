import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/route_export.dart';
import '../../../../../providers/home_screen_provider.dart';

class FilterResultChips extends ConsumerWidget {
  final Function(String)? onStyleSelected;
  final String? currentFilter;

  const FilterResultChips({
    super.key,
    this.onStyleSelected,
    this.currentFilter,
  });

  void _handleFilterSelection(WidgetRef ref, String? styleTitle, BuildContext context) {
    final homeProvider = ref.read(homeScreenProvider.notifier);

    if (styleTitle == null) {
      homeProvider.selectAllStyles();
    } else {
      homeProvider.filteredListFtn(styleTitle);
    }
    onStyleSelected?.call(styleTitle ?? '');
    Navigator.of(context).pop();
  }

  void _handleClearFilter(WidgetRef ref, BuildContext context) {
    final homeProvider = ref.read(homeScreenProvider.notifier);
    homeProvider.selectAllStyles();
    onStyleSelected?.call('');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allStyles = [...freePikStyles, ...textToImageStyles];
    final homeProvider = ref.watch(homeScreenProvider);

    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (homeProvider.selectedStyleTitle != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => _handleClearFilter(ref, context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.error, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.clear,
                          size: 16,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Clear',
                          style: AppTextstyle.interMedium(
                            fontSize: 12,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: [
                  _buildFilterChip(
                    context: context,
                    ref: ref,
                    isSelected: homeProvider.selectedStyleTitle == null,
                    label: 'All Styles',
                    icon: null,
                    styleTitle: null,
                    theme: theme,
                  ),
                  ...allStyles.map((e) => _buildFilterChip(
                    context: context,
                    ref: ref,
                    isSelected: homeProvider.selectedStyleTitle == e["title"],
                    label: e["title"]!,
                    icon: e['icon'],
                    styleTitle: e["title"]!,
                    theme: theme,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required WidgetRef ref,
    required bool isSelected,
    required String label,
    required String? icon,
    required String? styleTitle,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () => _handleFilterSelection(ref, styleTitle, context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(icon),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextstyle.interMedium(
                fontSize: 13,
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check,
                size: 16,
                color: theme.colorScheme.onPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}