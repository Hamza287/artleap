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
    );
  }

  Widget _buildDropdown(BuildContext context, WidgetRef ref, PromptNavItem currentNav) {
    final options = [
      _DropdownOption(
        icon: AppAssets.create,
        label: "Create",
        value: PromptNavItem.create,
      ),
      _DropdownOption(
        icon: AppAssets.editObject,
        label: "Edit Object",
        value: PromptNavItem.edit,
      ),
      _DropdownOption(
        icon: AppAssets.animate,
        label: "Animate",
        value: PromptNavItem.animate,
      ),
      _DropdownOption(
        icon: AppAssets.enhance,
        label: "Enhance",
        value: PromptNavItem.enhance,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<PromptNavItem>(
        value: currentNav,
        isExpanded: true,
        underline: const SizedBox(), // Remove default underline
        dropdownColor: Colors.white, // Background color of dropdown menu
        icon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey.shade700,
          ),
        ),
        items: options.map((option) {
          return DropdownMenuItem<PromptNavItem>(
            value: option.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Image.asset(
                    option.icon,
                    height: 18,
                    color: currentNav == option.value ? const Color(0xFF923CFF) : Colors.black87,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: currentNav == option.value ? const Color(0xFF923CFF) : Colors.black87,
                      fontWeight: currentNav == option.value ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            ref.read(promptNavProvider.notifier).setNavItem(value);
          }
        },
        selectedItemBuilder: (BuildContext context) {
          return options.map((option) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: currentNav == option.value
                            ? LinearGradient(colors: [
                          Color(0xFFD59FFF),
                          Color(0xFF875EFF),
                        ])
                            : LinearGradient(colors: [
                          Color(0xFFCFC1F7),
                          Color(0xFFCFC1F7),
                        ]),
                        borderRadius: BorderRadius.circular(12),
                        // Removed the border property
                      ),
                      child: Center(
                        child: Image.asset(
                          option.icon,
                          height: 18,
                          color: currentNav == option.value ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 14,
                        color: currentNav == option.value ? const Color(0xFF923CFF) : Colors.black87,
                        fontWeight: currentNav == option.value ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
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