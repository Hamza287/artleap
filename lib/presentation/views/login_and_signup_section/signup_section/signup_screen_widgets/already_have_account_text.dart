import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';

import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_textstyle.dart';
import '../../../../../shared/navigation/navigation.dart';

class AlreadyHaveAccountText extends ConsumerWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        RichText(
            text: TextSpan(
                style: AppTextstyle.interRegular(
                    color: theme.onSurface, fontSize: 12),
                text: "Already have an account?  ",
                children: [
              TextSpan(
                  text: "Login",
                  style: AppTextstyle.interMedium(
                      color: AppColors.indigo, fontSize: 12),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
                    })
            ])),
      ],
    );
  }
}
