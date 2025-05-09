import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/signup_section/signup_screen.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';

import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_textstyle.dart';

class NotHaveAccountText extends ConsumerWidget {
  const NotHaveAccountText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        RichText(
            text: TextSpan(
                style: AppTextstyle.interRegular(
                    color: AppColors.white, fontSize: 12),
                text: "Not have an account?  ",
                children: [
              TextSpan(
                  text: "Sign up",
                  style: AppTextstyle.interBold(
                      color: AppColors.indigo, fontSize: 13),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigation.pushNamed(SignUpScreen.routeName);
                    })
            ])),
      ],
    );
  }
}
