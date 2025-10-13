import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';

final keyboardVisibleProvider = StateProvider<bool>((ref) => false);

class PromptInputRedesign extends ConsumerWidget {
  const PromptInputRedesign({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ref.watch(keyboardVisibleProvider);
    final screenSize = MediaQuery.of(context).size;

    final maxHeight = screenSize.height * 0.4;
    final minHeight = 140.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Enter Prompt",
              style: AppTextstyle.interMedium(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            _buildCharacterCounter(ref, theme),
          ],
        ),
        12.spaceY,
        Container(
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxHeight: maxHeight,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
              width: 1.5,
            ),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
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
                fontSize: 13,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                border: InputBorder.none,
                hintText: "Describe the image you want to generate..'",
                hintStyle: AppTextstyle.interMedium(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintMaxLines: 5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterCounter(WidgetRef ref, ThemeData theme) {
    final promptText = ref.watch(generateImageProvider).promptTextController.text;
    final characterCount = promptText.length;

    return Text(
      "$characterCount/1000",
      style: AppTextstyle.interMedium(
        color: characterCount > 800
            ? theme.colorScheme.error
            : theme.colorScheme.onSurface.withOpacity(0.5),
        fontSize: 12,
      ),
    );
  }
}