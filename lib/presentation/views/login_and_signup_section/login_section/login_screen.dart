import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/base_widgets/scaffold_background.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_common_button.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/login_section/login_screen_widgets/login_screen_text.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/login_section/login_screen_widgets/login_textfields_section.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/login_section/login_screen_widgets/not_have_account_text.dart';
import 'package:photoroomapp/presentation/views/onboarding_section/onboarding_screen.dart';
import 'package:photoroomapp/providers/auth_provider.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/shared.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeName = "login_screen";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RegistrationBackgroundWidget(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          100.spaceY,
          LoginScreenText(),
          20.spaceY,
          LoginScreenTextfieldsSection(),
          20.spaceY,
          ref.watch(authprovider).isLoading
              ? const CircularProgressIndicator(
                  color: AppColors.indigo,
                )
              : CommonButton(
                  title: "Login",
                  color: AppColors.indigo,
                  onpress: () {
                    ref.read(authprovider).signInWithEmail();
                  },
                ),
          20.spaceY,
          NotHaveAccountText(),
          // 180.spaceY
        ],
      ),
    );
  }
}
