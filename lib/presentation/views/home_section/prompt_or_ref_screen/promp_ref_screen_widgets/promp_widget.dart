import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';
import 'package:photoroomapp/providers/img_to_img_provider.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class PromptWidget extends ConsumerWidget {
  const PromptWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Write your prompt for the image",
          style:
              AppTextstyle.interRegular(color: AppColors.white, fontSize: 12),
        ),
        8.spaceY,
        Container(
          height: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.darkBlue,
              border: Border.all(color: AppColors.white.withOpacity(0.4))),
          child: TextField(
            controller: ref.watch(generateImageProvider).promptTextController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, bottom: 10),
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Type a prompt",
                hintStyle: AppTextstyle.interMedium(
                    color: AppColors.white.withOpacity(0.4), fontSize: 12)),
          ),
        )
      ],
    );
  }
}
