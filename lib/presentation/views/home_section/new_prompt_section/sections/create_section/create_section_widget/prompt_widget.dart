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
    ref.watch(keyboardVisibleProvider);
    final screenSize = MediaQuery.of(context).size;

    final maxHeight = screenSize.height * 0.8;
    final minHeight = screenSize.height * 0.20;

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
                color :theme.colorScheme.surface
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
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
                            contentPadding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            fillColor:theme.colorScheme.surface,
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
        ],
      ),
    );
  }
}
