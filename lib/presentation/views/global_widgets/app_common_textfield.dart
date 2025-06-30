import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

import '../../../providers/auth_provider.dart';

class AppCommonTextfield extends ConsumerWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ObsecureText? obsecureTextType;

  const AppCommonTextfield({
    super.key,
    this.hintText,
    this.controller,
    this.obsecureTextType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authprovider);

    // Determine if text should be obscured based on the enum
    bool obscure = false;
    if (obsecureTextType == ObsecureText.loginPassword) {
      obscure = auth.loginPasswordHideShow;
    } else if (obsecureTextType == ObsecureText.signupPassword) {
      obscure = auth.signupPasswordHideShow;
    } else if (obsecureTextType == ObsecureText.confirmPassword) {
      obscure = auth.confirmPasswordHideShow;
    }

    return Container(
      height: 46,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: AppColors.black.withOpacity(0.2), width: 0.50),
      ),
      child: TextField(
        controller: controller,
        obscureText: obsecureTextType != null ? obscure : false,
        decoration: InputDecoration(
          contentPadding: obsecureTextType != null
              ? EdgeInsets.only(left: 8, bottom: 8, top: 6)
              : EdgeInsets.only(left: 8, bottom: 8),
          hintText: hintText,
          hintStyle: AppTextstyle.interMedium(
            color: AppColors.black.withOpacity(0.5),
            fontSize: 14,
          ),
          border: InputBorder.none,
          suffixIcon: obsecureTextType != null
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.black.withOpacity(0.5),
                    size: 20,
                  ),
                  onPressed: () {
                    ref.read(authprovider).obsecureTextFtn(obsecureTextType!);
                  },
                )
              : null,
        ),
      ),
    );
  }
}
