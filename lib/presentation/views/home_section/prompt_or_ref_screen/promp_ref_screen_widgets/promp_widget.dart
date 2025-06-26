import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';

import '../../../../../shared/constants/app_assets.dart';

class PromptWidget extends ConsumerWidget {
  const PromptWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Write your prompt for the image",
              style: AppTextstyle.interRegular(
                  color: AppColors.white, fontSize: 12),
            ),
            Container(
              height: 30,
              width: 95,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.white)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.stackofcoins,
                    height: 15,
                  ),
                  5.spaceX,
                  Text(
                    "${ref.watch(userProfileProvider).userProfileData?.user.dailyCredits ?? 0} Credits",
                    style: AppTextstyle.interMedium(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  )
                ],
              ),
            ),
          ],
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
            maxLines: null,
            minLines: null,
            expands: true,
            onChanged: (value) {
              ref.watch(generateImageProvider).checkSexualWords(value);
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
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
