import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/prompt_nav_provider.dart';
import '../../../global_widgets/artleap_top_bar.dart';

class PromptTopBar extends ConsumerStatefulWidget {
  const PromptTopBar({super.key});

  @override
  ConsumerState<PromptTopBar> createState() => _PromptTopBarState();
}

class _PromptTopBarState extends ConsumerState<PromptTopBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return Column(
      children: [
        // Selected option card
        GestureDetector(
          onTap: _toggleExpansion,
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
                      height: 18,
                      color: Colors.white,
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
                  turns: Tween(begin: 0.0, end: 0.5).animate(_heightAnimation),
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
        // Dropdown options
        SizeTransition(
          sizeFactor: _heightAnimation,
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
                      _toggleExpansion();
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
                                height: 18,
                                color: Colors.black87,
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