import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/prompt_nav_provider.dart';
import '../../../global_widgets/artleap_top_bar.dart';

class PromptTopBar extends ConsumerWidget {
  const PromptTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentNav = ref.watch(promptNavProvider);

    return Container(
      color: AppColors.topBar,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ArtLeapTopBar(),
          ),
          const SizedBox(height: 20), // Navigation Buttons - Now properly aligned in one line
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 8), // Initial padding
                _navButton(
                  context,
                  ref,
                  AppAssets.create,
                  "Create",
                  PromptNavItem.create,
                  currentNav == PromptNavItem.create,
                ),
                _navButton(
                  context,
                  ref,
                  AppAssets.editObject,
                  "Edit Object",
                  PromptNavItem.edit,
                  currentNav == PromptNavItem.edit,
                ),
                _navButton(
                  context,
                  ref,
                  AppAssets.animate,
                  "Animate",
                  PromptNavItem.animate,
                  currentNav == PromptNavItem.animate,
                ),
                _navButton(
                  context,
                  ref,
                  AppAssets.enhance,
                  "Enhance",
                  PromptNavItem.enhance,
                  currentNav == PromptNavItem.enhance,
                ),
                const SizedBox(width: 8), // End padding
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _navButton(
      BuildContext context,
      WidgetRef ref,
      String icon,
      String label,
      PromptNavItem navItem,
      bool selected,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => ref.read(promptNavProvider.notifier).setNavItem(navItem),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 70,
              height: 58,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: selected ? LinearGradient(colors: [
                  Color(0xFFD59FFF),
                  Color(0xFF875EFF),
                ]) : LinearGradient(colors: [
                  Color(0xFFCFC1F7),
                  Color(0xFFCFC1F7),
                ]),
                borderRadius: BorderRadius.circular(12),
                border: selected
                    ? Border.all(color: const Color(0xFF923CFF), width: 2)
                    : Border.all(color: Colors.grey.shade300),
              ),
              child: Image.asset(
                 icon,
                 height: 18,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: selected ? const Color(0xFF923CFF) : Colors.black87,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}