import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/prompt_nav_provider.dart';

class PromptTopBar extends ConsumerWidget {
  const PromptTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentNav = ref.watch(promptNavProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 36,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.2,
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.stackofcoins,
                      height: 18,
                      color: Colors.amber[700],
                    ),
                    3.spaceX,
                    Text(
                      "${ref.watch(userProfileProvider).userProfileData?.user.dailyCredits ?? 0}",
                      style: AppTextstyle.interMedium(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              const Text(
                "Art leap",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("choose_plan_screen");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF923CFF),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "✨ Get Pro",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Navigation Buttons - Now properly aligned in one line
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8), // Initial padding
              _navButton(
                context,
                ref,
                Icons.add_circle,
                "Create",
                PromptNavItem.create,
                currentNav == PromptNavItem.create,
              ),
              _navButton(
                context,
                ref,
                Icons.remove_circle_outline,
                "Edit Object",
                PromptNavItem.edit,
                currentNav == PromptNavItem.edit,
              ),
              _navButton(
                context,
                ref,
                Icons.play_circle,
                "Animate",
                PromptNavItem.animate,
                currentNav == PromptNavItem.animate,
              ),
              _navButton(
                context,
                ref,
                Icons.auto_fix_high,
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
    );
  }

  Widget _navButton(
      BuildContext context,
      WidgetRef ref,
      IconData icon,
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
                color: selected ? AppColors.white : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: selected
                    ? Border.all(color: const Color(0xFF923CFF), width: 2)
                    : Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(icon,
                color: selected ? const Color(0xFF923CFF) : Colors.black54,
                size: 28,
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