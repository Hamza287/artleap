import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:Artleap.ai/widgets/state_widgets/custom_error_state.dart';
import 'package:Artleap.ai/widgets/state_widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/widgets/common/scaffold_background.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_common_button.dart';
import 'package:Artleap.ai/providers/auth_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'login_screen_widgets/login_screen_text.dart';
import 'login_screen_widgets/login_textfields_section.dart';
import 'login_screen_widgets/not_have_account_text.dart';
import 'login_screen_widgets/or_widget.dart';
import 'login_screen_widgets/remember_me_forgot_widget.dart';
import 'login_screen_widgets/social_logins_widget.dart';

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
    final authState = ref.watch(authprovider);
    final isLoading = authState.isLoading(LoginMethod.email);
    final authError = authState.authError;

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
          if (authError != null)
            CompactErrorState(
              message: authError.message ?? 'Authentication failed',
              onRetry: () {
                ref.read(authprovider).clearError();
                ref.read(authprovider).signInWithEmail();
              },
              icon: Icons.error_outline,
            ),
          if (isLoading)
            const LoadingState(
              message: 'Signing in...',
            )
          else
            CommonButton(
              title: "Log In",
              color: AppColors.indigo,
              onpress: () {
                ref.read(authprovider).signInWithEmail();
              },
            ),
          20.spaceY,
          const ORwidget(),
          20.spaceY,
          const SocialLoginsWidget(),
          20.spaceY,
          const NotHaveAccountText(),
        ],
      ),
    );
  }
}