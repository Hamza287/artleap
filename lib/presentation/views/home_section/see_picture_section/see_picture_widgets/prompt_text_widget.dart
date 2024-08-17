import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class PromptTextWidget extends ConsumerWidget {
  const PromptTextWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Prompt",
            style: AppTextstyle.interBold(color: AppColors.white, fontSize: 14),
          ),
        ),
        5.spaceY,
        Container(
          height: 80,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.lightIndigo),
          child: Padding(
            padding: const EdgeInsets.only(left: 7, right: 7, top: 5),
            child: Text(
              "oil painting, ultra detailed illustration of a gorgeous water muse, long brunette hair, extremely detailed and beautiful face, gracefully sitting on a rock in a lake, water particles surrounding her, forest at background,",
              style: AppTextstyle.interRegular(
                  color: AppColors.lightgrey, fontSize: 11),
            ),
          ),
        )
      ],
    );
  }
}
