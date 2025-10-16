import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/prompt_edit_provider.dart';
import 'sections/action_button_row.dart';
import 'sections/feature_button_row.dart';
import 'sections/image_upload_widget.dart';
import 'sections/undo_redo_buttons.dart';

class PromptEditScreen extends ConsumerWidget {
  const PromptEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 375;
    final isLargeScreen = size.width > 600;
    final state = ref.watch(promptEditProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: isSmallScreen ? 7 : 10),

                    if (state.showUndoRedo) const UndoRedoButtons(),
                    GestureDetector(
                      onTap: null,
                      // onTap: () => ref.read(promptEditProvider.notifier).pickImage(),
                      child: ImageUploadContainer(
                        isLargeScreen: isLargeScreen,
                        maxHeight: constraints.maxHeight,
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 12 : 16),
                    ActionButtonsRow(isSmallScreen: isSmallScreen),

                    SizedBox(height: isSmallScreen ? 16 : 60),
                    FeatureButtonsRow(isSmallScreen: isSmallScreen),

                    SizedBox(height: isSmallScreen ? 20 : 26),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 10),
                      child: Text(
                        "Draw on the image above to select it and add a prompt to add or replace an object",
                        style: AppTextstyle.interBold(
                            fontSize: isSmallScreen ? 12 : 13,
                            color: theme.colorScheme.onSurface.withOpacity(0.6)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Prompt",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 200,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(0.3),
                              ),
                            ),
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Text(
                                    "No prompt available",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: isLargeScreen ? 64 : 56,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 20),
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Generate now",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              10.spaceX,
                              Icon(
                                Icons.auto_awesome,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              SizedBox(width: isSmallScreen ? 20 : 24),
                              Image.asset(
                                AppAssets.stackofcoins,
                                width: 30,
                                height: 30,
                              ),
                              Text(
                                "20",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}