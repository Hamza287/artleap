import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/base_widgets/scaffold_background.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_common_button.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/signup_section/signup_screen.dart';
import 'package:photoroomapp/presentation/views/login_or_signup_screen/login_or_signup_screen_widgets/login_or_signup_button.dart';
import 'package:photoroomapp/presentation/views/login_or_signup_screen/login_or_signup_screen_widgets/login_or_signup_text.dart';
import 'package:photoroomapp/presentation/views/login_or_signup_screen/login_or_signup_screen_widgets/or_widget.dart';
import 'package:photoroomapp/providers/auth_provider.dart';
import 'package:photoroomapp/shared/shared.dart';

class LoginORsignUpScreen extends ConsumerWidget {
  static const String routeName = "login_or_signup_Screen";
  const LoginORsignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RegistrationBackgroundWidget(
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const OnboardingScreenText(),
            20.spaceY,
            OnboardingButton(
                title: "Login",
                onpress: () => Navigation.pushNamed(LoginScreen.routeName)),
            20.spaceY,
            OnboardingButton(
              title: "Sign Up",
              onpress: () => Navigation.pushNamed(SignUpScreen.routeName),
            ),
            20.spaceY,
            const ORwidget(),
            50.spaceY,
            ref.watch(authprovider).isLoading
                ? CircularProgressIndicator(
                    backgroundColor: AppColors.indigo,
                  )
                : CommonButton(
                    title: "Continue with Google",
                    color: AppColors.indigo,
                    imageicon: AppAssets.googleicon,
                    onpress: () {
                      ref.read(authprovider).signInWithGoogle();
                    }),
            100.spaceY,
          ],
        ),
      ),
    );
  }
}
