import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import '../../../prompt_screen_widgets/prompt_top_bar.dart';

// Create a provider to track keyboard visibility state
final keyboardVisibleProvider = StateProvider<bool>((ref) => false);

class PromptWidget extends ConsumerWidget {
  const PromptWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          SizedBox(height: 10,),
          Text(
            "Enter Prompt",
            style: AppTextstyle.interBold(
                color: Colors.black,
                fontSize: 14),
          ),
          12.spaceY,
          Stack(
            children: [
              // Outer container with gradient border
              Container(
                constraints: BoxConstraints(
                  minHeight: minHeight,
                  maxHeight: maxHeight, // Responsive maximum height
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1.5,
                    style: BorderStyle.solid,
                    color: Colors.transparent,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF875EFF),
                      Color(0xFFFC24F5)
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
                    color: Colors.white,
                  ),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 60), // Space for the "Fix It" button
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: minHeight - 3, // Adjusted for border
                        ),
                        child: IntrinsicHeight(
                          child: GestureDetector(
                            onDoubleTap: () {
                              // Hide keyboard on double tap
                              FocusScope.of(context).unfocus();
                              ref.read(keyboardVisibleProvider.notifier).state = false;
                            },
                            child: TextField(
                              controller: ref.watch(generateImageProvider).promptTextController,
                              maxLines: null, // Allows infinite lines
                              minLines: null,
                              expands: true, // Expands to fill available space
                              onChanged: (value) {
                                ref.watch(generateImageProvider).checkSexualWords(value);
                              },
                              onTap: () {
                                ref.read(keyboardVisibleProvider.notifier).state = true;
                              },
                              style: AppTextstyle.interMedium(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 16, top: 16, right: 16),
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "Describe the image you want to generate...",
                                hintStyle: AppTextstyle.interMedium(
                                    color: Colors.grey.shade500,
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
              //             Colors.grey.shade400,
              //             Color(0xD8923CFF),
              //           ],
              //           radius: 0.9,
              //           center: Alignment.center,
              //         ),
              //         borderRadius: BorderRadius.circular(7),
              //       ),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           const Icon(Icons.auto_fix_high,
              //               size: 18, color: Colors.white),
              //           6.spaceX,
              //           Text(
              //             "Fix It",
              //             style: AppTextstyle.interMedium(
              //                 color: Colors.white,
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