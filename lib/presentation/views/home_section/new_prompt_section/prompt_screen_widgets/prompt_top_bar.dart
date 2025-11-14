import 'package:Artleap.ai/providers/prompt_nav_provider.dart';
import 'package:Artleap.ai/shared/route_export.dart';

final isDropdownExpandedProvider = StateProvider<bool>((ref) => false);

ScreenSizeCategory getScreenSizeCategory(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 375) return ScreenSizeCategory.extraSmall;
  if (width < 414) return ScreenSizeCategory.small;
  if (width < 600) return ScreenSizeCategory.medium;
  return ScreenSizeCategory.large;
}

enum ScreenSizeCategory { extraSmall, small, medium, large }

class PromptTopBar extends ConsumerWidget {
  const PromptTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentNav = ref.watch(promptNavProvider);
    final screenSize = getScreenSizeCategory(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize == ScreenSizeCategory.extraSmall ? 16 : 20,
          vertical: 12,
        ),
        child: _buildProfessionalDropdown(
            context, ref, currentNav, screenSize, theme),
      ),
    );
  }

  Widget _buildProfessionalDropdown(
      BuildContext context,
      WidgetRef ref,
      PromptNavItem currentNav,
      ScreenSizeCategory screenSize,
      ThemeData theme) {
    final isExpanded = ref.watch(isDropdownExpandedProvider);
    final animationController = ref.watch(_animationControllerProvider);

    final options = [
      _DropdownOption(
        icon: FeatherIcons.plusSquare,
        label: "Create",
        value: PromptNavItem.create,
      ),
      _DropdownOption(
        icon: FeatherIcons.edit,
        label: "Edit Object",
        value: PromptNavItem.edit,
      ),
      _DropdownOption(
        icon: FeatherIcons.playCircle,
        label: "Animate",
        value: PromptNavItem.animate,
      ),
      _DropdownOption(
        icon: FeatherIcons.zap,
        label: "Enhance",
        value: PromptNavItem.enhance,
      ),
    ];

    final iconSize = _getIconSize(screenSize);
    final fontSize = _getFontSize(screenSize);
    final padding = _getPadding(screenSize);

    final currentOption = options.firstWhere((opt) => opt.value == currentNav);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref.read(isDropdownExpandedProvider.notifier).state =
                !isExpanded;
                if (isExpanded) {
                  animationController.reverse();
                } else {
                  animationController.forward();
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: padding, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          currentOption.icon,
                          size: iconSize * 0.5,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: padding * 0.8),
                    Expanded(
                      child: Text(
                        currentOption.label,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: padding * 0.8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(
                          CurvedAnimation(
                            parent: animationController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animationController,
            curve: Curves.easeInOut,
          ),
          child: FadeTransition(
            opacity: animationController,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: options
                      .where((opt) => opt.value != currentNav)
                      .map((option) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(promptNavProvider.notifier)
                              .setNavItem(option.value);
                          ref.read(isDropdownExpandedProvider.notifier).state =
                          false;
                          animationController.reverse();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: padding, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: options.last == option
                                  ? BorderSide.none
                                  : BorderSide(
                                color: theme.colorScheme.outline
                                    .withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: iconSize,
                                height: iconSize,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Icon(
                                    option.icon,
                                    size: iconSize * 0.45,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              SizedBox(width: padding * 0.8),
                              Expanded(
                                child: Text(
                                  option.label,
                                  style: TextStyle(
                                    fontSize: fontSize * 0.95,
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.5),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getIconSize(ScreenSizeCategory screenSize) {
    switch (screenSize) {
      case ScreenSizeCategory.extraSmall:
        return 28;
      case ScreenSizeCategory.small:
        return 32;
      case ScreenSizeCategory.medium:
        return 34;
      case ScreenSizeCategory.large:
        return 36;
    }
  }

  double _getFontSize(ScreenSizeCategory screenSize) {
    switch (screenSize) {
      case ScreenSizeCategory.extraSmall:
        return 14;
      case ScreenSizeCategory.small:
        return 15;
      case ScreenSizeCategory.medium:
        return 15;
      case ScreenSizeCategory.large:
        return 16;
    }
  }

  double _getPadding(ScreenSizeCategory screenSize) {
    switch (screenSize) {
      case ScreenSizeCategory.extraSmall:
        return 12;
      case ScreenSizeCategory.small:
        return 14;
      case ScreenSizeCategory.medium:
        return 16;
      case ScreenSizeCategory.large:
        return 16;
    }
  }
}

final _animationControllerProvider = Provider<AnimationController>((ref) {
  final controller = AnimationController(
    vsync: _TickerProvider(),
    duration: const Duration(milliseconds: 300),
  );
  ref.onDispose(() => controller.dispose());
  return controller;
});

class _TickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class _DropdownOption {
  final IconData icon;
  final String label;
  final PromptNavItem value;

  _DropdownOption({
    required this.icon,
    required this.label,
    required this.value,
  });
}