import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';

import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_textstyle.dart';

class SignupScreenText extends ConsumerWidget {
  const SignupScreenText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        5.spaceY,
        Text(
          "Sign up to convert your imagination into reality",
          style:
              AppTextstyle.interRegular(color: AppColors.white, fontSize: 10),
        )
      ],
    );
  }
}
