import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import '../../../prompt_screen_widgets/prompt_top_bar.dart';

final keyboardVisibleProvider = StateProvider<bool>((ref) => false);

class PromptWidget extends ConsumerWidget {
  const PromptWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isKeyboardVisible = ref.watch(keyboardVisibleProvider);
    final screenSize = MediaQuery.of(context).size;

    final maxHeight = screenSize.height * 0.4;
    final minHeight = screenSize.height * 0.15;

    return InkWell(
      onTap: () {
        ref.read(isDropdownExpandedProvider.notifier).state = false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Enter Prompt",
            style: AppTextstyle.interBold(
                color: theme.colorScheme.onSurface, fontSize: 14),
          ),
          12.spaceY,
          Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: minHeight,
                  maxHeight: maxHeight,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1.5,
                    style: BorderStyle.solid,
                    color: Colors.transparent,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary
                    ],
                    stops: [0.0, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.5),
                    color: theme.colorScheme.surface,
                  ),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: minHeight - 3,
                        ),
                        child: IntrinsicHeight(
                          child: GestureDetector(
                            onDoubleTap: () {
                              FocusScope.of(context).unfocus();
                              ref.read(keyboardVisibleProvider.notifier).state =
                                  false;
                            },
                            child: TextField(
                              controller: ref.watch(generateImageProvider).promptTextController,
                              maxLines: null,
                              minLines: null,
                              expands: true,
                              onChanged: (value) {
                                ref.watch(generateImageProvider).checkSexualWords(value);
                              },
                              onTap: () {
                                ref.read(keyboardVisibleProvider.notifier).state = true;
                              },
                              style: AppTextstyle.interMedium(
                                color: theme.colorScheme.onSurface,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 16, top: 16, right: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: theme.colorScheme.surface,
                                hintText: "Describe the image you want to generate...",
                                hintStyle: AppTextstyle.interMedium(
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // "Fix It" button positioned at bottom right
              // Positioned(
              //   bottom: 12,
              //   right: 12,
              //   child: GestureDetector(
              //     onTap: () {
              //       // Add your fix it functionality here
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //       width: 100,
              //       decoration: BoxDecoration(
              //         gradient: RadialGradient(
              //           colors: [
              //             theme.colorScheme.surfaceVariant!,
              //             theme.colorScheme.primary,
              //           ],
              //           radius: 0.9,
              //           center: Alignment.center,
              //         ),
              //         borderRadius: BorderRadius.circular(7),
              //       ),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Icon(Icons.auto_fix_high,
              //               size: 18, color: theme.colorScheme.onPrimary),
              //           6.spaceX,
              //           Text(
              //             "Fix It",
              //             style: AppTextstyle.interMedium(
              //                 color: theme.colorScheme.onPrimary,
              //                 fontSize: 14),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
