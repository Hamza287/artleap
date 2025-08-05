import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/prompt_nav_provider.dart';
import '../../../global_widgets/artleap_top_bar.dart';

// Provider for dropdown expansion state
final isDropdownExpandedProvider = StateProvider<bool>((ref) => false);

class PromptTopBar extends ConsumerWidget {
  const PromptTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentNav = ref.watch(promptNavProvider);
    final isExpanded = ref.watch(isDropdownExpandedProvider);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ArtLeapTopBar(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildDropdown(context, ref, currentNav),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context, WidgetRef ref, PromptNavItem currentNav) {
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFD59FFF),
                        const Color(0xFF875EFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      options.firstWhere((opt) => opt.value == currentNav).icon,
                      height: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  options.firstWhere((opt) => opt.value == currentNav).label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(animationController),
                  child: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black87,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Image.asset(
                                option.icon,
                                height: 50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            option.label,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
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