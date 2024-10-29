import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/providers/auth_provider.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_textstyle.dart';
import '../../../global_widgets/app_common_textfield.dart';

class SignupTextfieldSection extends ConsumerWidget {
  const SignupTextfieldSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sign Up",
          style: AppTextstyle.interBold(color: AppColors.black, fontSize: 32),
        ),
        30.spaceY,
        AppCommonTextfield(
          hintText: "Username",
          controller: ref.watch(authprovider).userNameController,
        ),
        20.spaceY,
        AppCommonTextfield(
          hintText: "Email",
          controller: ref.watch(authprovider).emailController,
        ),
        20.spaceY,
        AppCommonTextfield(
          hintText: "Password",
          controller: ref.watch(authprovider).passwordController,
        ),
        20.spaceY,
        AppCommonTextfield(
          hintText: "Confirm Password",
          controller: ref.watch(authprovider).confirmPasswordController,
        )
      ],
    );
  }
}
