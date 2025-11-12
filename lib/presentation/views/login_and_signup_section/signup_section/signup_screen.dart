import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/widgets/common/scaffold_background.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/signup_section/signup_screen_widgets/go_back_widget.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/signup_section/signup_screen_widgets/signup_textfields_section.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../global_widgets/app_common_button.dart';
import '../../global_widgets/error_widget.dart';
import 'signup_screen_widgets/already_have_account_text.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const String routeName = 'signup_screen';
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authprovider).clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return RegistrationBackgroundWidget(
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 650,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    30.spaceY,
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              ref.read(authprovider).clearError();
                              Navigation.pop();
                            },
                            child: GoBackWidget()),
                      ],
                    ),
                    30.spaceY,
                    SignupTextfieldSection(),
                    20.spaceY,
                    CustomErrorWidget(
                        isShow: ref.watch(authprovider).authError != null,
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
          ],
        ));
  }
}