import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class PromptTextWidget extends ConsumerWidget {
  final String? prompt;
  const PromptTextWidget({super.key, this.prompt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Prompt details",
                style: AppTextstyle.interBold(
                    color: AppColors.white, fontSize: 14),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: prompt!));
                },
                child: Image.asset(
                  AppAssets.copyicon,
                  scale: 2.50,
                ),
              )
            ],
          ),
        ),
        10.spaceY,
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.blueColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 250,
              width: double.infinity,
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.darkBlue),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 7),
                child: Text(
                  prompt!,
                  style: AppTextstyle.interRegular(
                      color: AppColors.lightgrey, fontSize: 11),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
