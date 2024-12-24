import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/base_widgets/scaffold_background.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/signup_section/signup_screen_widgets/go_back_widget.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/signup_section/signup_screen_widgets/signup_textfields_section.dart';
import 'package:photoroomapp/providers/auth_provider.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../global_widgets/app_common_button.dart';
import '../../global_widgets/error_widget.dart';
import 'signup_screen_widgets/already_have_account_text.dart';
import 'signup_screen_widgets/signup_screen_text.dart';

class SignUpScreen extends ConsumerWidget {
  static const String routeName = 'signup_screen';
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RegistrationBackgroundWidget(
        widget: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 650,
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                30.spaceY,
                GestureDetector(
                    onTap: () {
                      Navigation.pop();
                    },
                    child: GoBackWidget()),
                30.spaceY,
                SignupTextfieldSection(),
                20.spaceY,
                CustomErrorWidget(
                    isShow: true,
                    message: ref.watch(authprovider).authError?.message,
                    authResultState:
                        ref.watch(authprovider).authError?.authResultState),
                ref.watch(authprovider).isLoading(LoginMethod.signup)
                    ? const CircularProgressIndicator(
                        color: AppColors.indigo,
                      )
                    : CommonButton(
                        title: "Sign Up",
                        color: AppColors.indigo,
                        onpress: () {
                          print("dddddddddd");
                          ref.read(authprovider).signUpWithEmail();
                        },
                      ),
                20.spaceY,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AlreadyHaveAccountText(),
                  ],
                ),
              ],
            ),
          ),
        ),
        // const SignupScreenText(),
        // 20.spaceY,
        // const SignupTextfieldSection(),
        // 20.spaceY,
        // ref.watch(authprovider).isLoading
        //     ? const CircularProgressIndicator(
        //         color: AppColors.indigo,
        //       )
        //     : CommonButton(
        //         title: "Create Account",
        //         color: AppColors.indigo,
        //         onpress: () {
        //           print("dddddddddd");
        //           ref.read(authprovider).signUpWithEmail();
        //         },
        //       ),
        // 20.spaceY,
        // const AlreadyHaveAccountText(),
        // 60.spaceY
      ],
    ));
  }
}
