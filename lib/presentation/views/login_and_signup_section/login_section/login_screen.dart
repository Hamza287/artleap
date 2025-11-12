import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/widgets/common/scaffold_background.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_common_button.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/login_screen_text.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/login_textfields_section.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/not_have_account_text.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/remember_me_forgot_widget.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen_widgets/social_logins_widget.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../global_widgets/error_widget.dart';
import 'login_screen_widgets/or_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = "login_screen";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authprovider).clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              isShow: ref.watch(authprovider).authError != null,
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
        ],
      ),
    );
  }
}