import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:Artleap.ai/widgets/state_widgets/custom_error_state.dart';
import 'package:Artleap.ai/widgets/state_widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/widgets/common/scaffold_background.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import '../../global_widgets/app_common_button.dart';
import 'signup_screen_widgets/already_have_account_text.dart';
import 'signup_screen_widgets/go_back_widget.dart';
import 'signup_screen_widgets/signup_textfields_section.dart';

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
    final authState = ref.watch(authprovider);
    final isLoading = authState.isLoading(LoginMethod.signup);
    final authError = authState.authError;

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
                    const SignupTextfieldSection(),
                    20.spaceY,
                    if (authError != null)
                      CompactErrorState(
                        message: authError.message ?? 'Sign up failed',
                        onRetry: () {
                          ref.read(authprovider).clearError();
                          ref.read(authprovider).signUpWithEmail();
                        },
                        icon: Icons.person_add_disabled,
                      ),
                    if (isLoading)
                      const LoadingState(
                        message: 'Creating account...',
                      )
                    else
                      CommonButton(
                        title: "Sign Up",
                        color: AppColors.indigo,
                        onpress: () {
                          ref.read(authprovider).signUpWithEmail();
                        },
                      ),
                    20.spaceY,
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AlreadyHaveAccountText(),
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