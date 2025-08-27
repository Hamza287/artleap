import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/prompt_nav_provider.dart';
import '../../../global_widgets/artleap_top_bar.dart';
import '../sections/create_section/create_section_widget/prompt_widget.dart';

// Provider for dropdown expansion state
final isDropdownExpandedProvider = StateProvider<bool>((ref) => false);

// Screen size category helper function
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
    final currentNav = ref.watch(promptNavProvider);
    final isExpanded = ref.watch(isDropdownExpandedProvider);

    // Get screen size directly from context without modifying providers
    final screenSize = getScreenSizeCategory(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(keyboardVisibleProvider.notifier).state = false;
            if (isExpanded) {
              ref.read(isDropdownExpandedProvider.notifier).state = false;
            }
          },
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize == ScreenSizeCategory.small ||
                      screenSize == ScreenSizeCategory.extraSmall
                      ? 12 : 16,
                ),
                child: ArtLeapTopBar(),
              ),
              SizedBox(height: screenSize == ScreenSizeCategory.small ||
                  screenSize == ScreenSizeCategory.extraSmall
                  ? 12 : 20),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize == ScreenSizeCategory.small ||
                      screenSize == ScreenSizeCategory.extraSmall
                      ? 12 : 16,
                ),
                child: _buildDropdown(context, ref, currentNav, screenSize),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context, WidgetRef ref, PromptNavItem currentNav, ScreenSizeCategory screenSize) {
    final isExpanded = ref.watch(isDropdownExpandedProvider);
    final animationController = ref.watch(_animationControllerProvider);

    final options = [
      _DropdownOption(
        icon: AppAssets.create,
        label: "Create",
        value: PromptNavItem.create,
      ),
      _DropdownOption(
        icon: AppAssets.enhance,
        label: "Edit Object",
        value: PromptNavItem.edit,
      ),
      _DropdownOption(
        icon: AppAssets.animate,
        label: "Animate",
        value: PromptNavItem.animate,
      ),
      _DropdownOption(
        icon: AppAssets.editObject,
        label: "Enhance",
        value: PromptNavItem.enhance,
      ),
    ];

    // Adjust sizes based on screen category
    final iconSize = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 32.0 : 40.0;
    final fontSize = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 14.0 : 16.0;
    final horizontalPadding = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 10.0 : 12.0;
    final verticalPadding = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 10.0 : 12.0;
    final spacing = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 8.0 : 12.0;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(isDropdownExpandedProvider.notifier).state = !isExpanded;
            if (isExpanded) {
              animationController.reverse();
            } else {
              animationController.forward();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFD59FFF),
                        Color(0xFF875EFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      options.firstWhere((opt) => opt.value == currentNav).icon,
                      height: iconSize * 0.75,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Text(
                    options.firstWhere((opt) => opt.value == currentNav).label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: spacing),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(animationController),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black87,
                    size: iconSize * 0.75,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizeTransition(
          sizeFactor: animationController,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: options.where((opt) => opt.value != currentNav).map((option) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ref.read(promptNavProvider.notifier).setNavItem(option.value);
                      ref.read(isDropdownExpandedProvider.notifier).state = false;
                      animationController.reverse();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: iconSize,
                            height: iconSize,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Image.asset(
                                option.icon,
                                height: iconSize * 1.25,
                              ),
                            ),
                          ),
                          SizedBox(width: spacing),
                          Expanded(
                            child: Text(
                              option.label,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
      ],
    );
  }
}

// Provider for AnimationController
final _animationControllerProvider = Provider<AnimationController>((ref) {
  final controller = AnimationController(
    vsync: _TickerProvider(),
    duration: const Duration(milliseconds: 300),
  );
  ref.onDispose(() => controller.dispose());
  return controller;
});

// Ticker provider for AnimationController
class _TickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class _DropdownOption {
  final String icon;
  final String label;
  final PromptNavItem value;

  _DropdownOption({
    required this.icon,
    required this.label,
    required this.value,
  });
}