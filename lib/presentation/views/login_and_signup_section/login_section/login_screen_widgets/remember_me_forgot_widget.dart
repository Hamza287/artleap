import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/forgot_password_section/forgot_password_screen.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';

class RememberMeForgotPassWidget extends ConsumerWidget {
  const RememberMeForgotPassWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 285,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: Row(
            children: [
              Container(
                  height: 15,
                  width: 15,
                  child: Transform.scale(
                      scale: 0.8,
                      child: Checkbox(value: true, onChanged: (val) {}))),
              5.spaceX,
              Text(
                "Remember me",
                style: AppTextstyle.interMedium(
                  color: AppColors.white,
                  fontSize: 12,
                ),
              ),
            ],
          )),
          GestureDetector(
            onTap: () {
              Navigation.pushNamed(ForgotPasswordScreen.routeName);
            },
            child: Text(
              "Forgot Password ?",
              style: AppTextstyle.interMedium(
                  color: AppColors.white, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
