import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_textstyle.dart';

class LoginScreenText extends ConsumerWidget {
  const LoginScreenText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        RichText(
            text: TextSpan(
                style: AppTextstyle.interRegular(
                    color: AppColors.white, fontSize: 22),
                text: "Welcome to ",
                children: [
              TextSpan(
                  text: ".Imaginary Verse",
                  style: AppTextstyle.interRegular(
                      color: AppColors.pinkColor, fontSize: 22))
            ])),
        5.spaceY,
        Text(
          "Sign in to convert your imagination into reality",
          style:
              AppTextstyle.interRegular(color: AppColors.white, fontSize: 10),
        )
      ],
    );
  }
}
