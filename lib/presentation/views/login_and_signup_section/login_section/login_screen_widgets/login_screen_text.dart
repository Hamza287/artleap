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
        5.spaceY,
        Text(
          "Enter your email and password to log in ",
          style:
              AppTextstyle.interRegular(color: AppColors.white, fontSize: 12),
        )
      ],
    );
  }
}
