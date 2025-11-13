import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/widgets/common/sized_box.dart';

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
