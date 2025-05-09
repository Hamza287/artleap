import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/base_widgets/scaffold_background.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_common_button.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/login_screen_text.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/login_textfields_section.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/not_have_account_text.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/remember_me_forgot_widget.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/social_logins_widget.dart';
import 'package:Artleap.ai/presentation/views/login_or_signup_screen/login_or_signup_screen_widgets/or_widget.dart';
import 'package:Artleap.ai/presentation/views/onboarding_section/onboarding_screen.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/shared.dart';

import '../../global_widgets/error_widget.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeName = "login_screen";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RegistrationBackgroundWidget(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          130.spaceY,
          const LoginScreenText(),
          20.spaceY,
          const Padding(
            padding: EdgeInsets.only(left: 36, right: 36),
            child: LoginScreenTextfieldsSection(),
          ),
          15.spaceY,
          const RememberMeForgotPassWidget(),
          20.spaceY,
          CustomErrorWidget(
              isShow: true,
              message: ref.watch(authprovider).authError?.message,
              authResultState:
                  ref.watch(authprovider).authError?.authResultState),
          ref.watch(authprovider).isLoading(LoginMethod.email)
              ? const CircularProgressIndicator(
                  color: AppColors.indigo,
                )
              : CommonButton(
                  title: "Log In",
                  color: AppColors.indigo,
                  onpress: () {
                    ref.read(authprovider).signInWithEmail();
                  },
                ),

          20.spaceY,
          ORwidget(),
          20.spaceY,
          SocialLoginsWidget(),
          20.spaceY,
          NotHaveAccountText(),
          // 180.spaceY
        ],
      ),
    );
  }
}
