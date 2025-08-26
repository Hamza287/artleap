import 'package:Artleap.ai/presentation/views/home_section/new_prompt_section/prompt_screen_widgets/prompt_top_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/new_prompt_section/sections/create_section/prompt_create_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/new_prompt_section/sections/edit_section/prompt_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/prompt_nav_provider.dart';
import 'sections/create_section/create_section_widget/prompt_widget.dart';

class PromptScreen extends ConsumerWidget {
  const PromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentNav = ref.watch(promptNavProvider);
    final isExpanded = ref.watch(isDropdownExpandedProvider);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (isExpanded) {
            ref.read(isDropdownExpandedProvider.notifier).state = false;
          }
        },
        child: Column(
          children: [
            const PromptTopBar(),
            Expanded(
              child: Stack(
                children: [
                  _buildCurrentScreen(currentNav),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 4, // Shadow height
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen(PromptNavItem navItem) {
    switch (navItem) {
      case PromptNavItem.create:
        return const PromptCreateScreen();
      case PromptNavItem.edit:
        return const PromptEditScreen();
      case PromptNavItem.animate:
      return Center(child: Text('Coming soon',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),);
      case PromptNavItem.enhance:
        return Center(child: Text('Coming soon',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),);
    }
  }
}

