import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/base_widgets/scaffold_background.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_common_button.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/signup_section/signup_screen.dart';
import 'package:Artleap.ai/presentation/views/login_or_signup_screen/login_or_signup_screen_widgets/login_or_signup_button.dart';
import 'package:Artleap.ai/presentation/views/login_or_signup_screen/login_or_signup_screen_widgets/login_or_signup_text.dart';
import 'package:Artleap.ai/presentation/views/login_or_signup_screen/login_or_signup_screen_widgets/or_widget.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';

class LoginORsignUpScreen extends ConsumerStatefulWidget {
  static const String routeName = "login_or_signup_Screen";

  const LoginORsignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginORsignUpScreenState();
}

class _LoginORsignUpScreenState extends ConsumerState<LoginORsignUpScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var useriD = AppLocal.ins.getUSerData(Hivekey.userId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (useriD != null) {
        Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ref.watch(authprovider).isLoading(LoginMethod.email)
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
