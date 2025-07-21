import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_common_textfield.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import '../../../../../providers/auth_provider.dart';

class LoginScreenTextfieldsSection extends ConsumerWidget {
  const LoginScreenTextfieldsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCommonTextfield(
          hintText: "Email",
          controller: ref.watch(authprovider).emailController,
        ),
        10.spaceY,
        AppCommonTextfield(
            hintText: "Password",
            controller: ref.watch(authprovider).passwordController,
            obsecureTextType: ObsecureText.loginPassword)
      ],
    );
  }
}
