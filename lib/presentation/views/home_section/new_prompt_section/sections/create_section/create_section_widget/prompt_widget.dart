import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';

class PromptWidget extends ConsumerWidget {
  const PromptWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Write your prompt for the image",
          style: AppTextstyle.interRegular(
              color: Colors.black,
              fontSize: 14),
        ),
        12.spaceY,
        Stack(
          children: [
            Container(
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1.5,
                  style: BorderStyle.solid,
                  color: Colors.transparent,
                ),
                // Actual gradient border
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF875EFF),
                    Color(0xFFFC24F5)
                  ],
                  stops: const [0.0, 1.0],
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
                child: TextField(
                  controller: ref.watch(generateImageProvider).promptTextController,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  onChanged: (value) {
                    ref.watch(generateImageProvider).checkSexualWords(value);
                  },
                  style: AppTextstyle.interMedium(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 16, bottom: 60, top: 16, right: 16),
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
            Positioned(
              bottom: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  // Add your fix it functionality here
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.grey.shade400,
                        Color(0xD8923CFF),
                      ],
                      radius: 0.9,
                      center: Alignment.center,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_fix_high,
                          size: 18, color: Colors.white),
                      6.spaceX,
                      Text(
                        "Fix It",
                        style: AppTextstyle.interMedium(
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}