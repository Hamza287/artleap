import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/base_widgets/scaffold_background.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_common_button.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_common_textfield.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  static const String routeName = "forgot_password_screen";

  const ForgotPasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RegistrationBackgroundWidget(
        bgImage: AppAssets.forgotbg,
        widget: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            100.spaceY,
            Text(
              "Forgot your Password?",
              style:
                  AppTextstyle.interBold(color: AppColors.white, fontSize: 22),
            ),
            10.spaceY,
            Text(
              "Dont worry just enter your registered email \n to receive the reset password link",
              style: AppTextstyle.interMedium(
                  color: AppColors.white, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            50.spaceY,
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: AppCommonTextfield(
                hintText: "Loisbecket@gmail.com",
                controller: ref.watch(authprovider).emailController,
              ),
            ),
            15.spaceY,
            ref.watch(authprovider).isLoading(LoginMethod.forgotPassword)
                ? const CircularProgressIndicator(
                    color: AppColors.indigo,
                  )
                : CommonButton(
                    color: AppColors.indigo,
                    title: "Send",
                    onpress: () {
                      ref.read(authprovider).forgotPassword();
                    },
                  ),
            20.spaceY,
            RichText(
                text: TextSpan(
                    style: AppTextstyle.interRegular(
                        color: AppColors.white, fontSize: 12),
                    text: "Remember password?  ",
                    children: [
                  TextSpan(
                      text: "Login",
                      style: AppTextstyle.interBold(
                          color: AppColors.indigo, fontSize: 13),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigation.pushNamedAndRemoveUntil(
                              LoginScreen.routeName);
                        })
                ])),
          ],
        ));
  }
}
