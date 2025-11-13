import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/widgets/common/sized_box.dart';
import '../../../../../shared/constants/app_textstyle.dart';
import '../../../../../widgets/common/app_common_textfield.dart';

class SignupTextfieldSection extends ConsumerWidget {
  const SignupTextfieldSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( 
          "Sign Up",
          style: AppTextstyle.interBold(color: theme.onSurface, fontSize: 32),
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
          obsecureTextType: ObsecureText.signupPassword,
        ),
        20.spaceY,
        AppCommonTextfield(
          hintText: "Confirm Password",
          controller: ref.watch(authprovider).confirmPasswordController,
          obsecureTextType: ObsecureText.confirmPassword,
        )
      ],
    );
  }
}
