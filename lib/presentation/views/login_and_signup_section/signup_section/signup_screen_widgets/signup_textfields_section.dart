import '../../../../../widgets/common/app_common_textfield.dart';
import 'package:Artleap.ai/shared/route_export.dart';


class SignupTextfieldSection extends ConsumerWidget {
  const SignupTextfieldSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( 
          "Sign Up",
          style: AppTextstyle.interBold(color: theme.onSurface, fontSize: 32),
        ),
        30.spaceY,
        AppCommonTextfield(
          hintText: "Username",
          controller: ref.watch(authprovider).userNameController,
        ),
        20.spaceY,
        AppCommonTextfield(
          hintText: "Email",
          controller: ref.watch(authprovider).emailController,
        ),
        20.spaceY,
        AppCommonTextfield(
          hintText: "Password",
          controller: ref.watch(authprovider).passwordController,
          obsecureTextType: ObsecureText.signupPassword,
        ),
        20.spaceY,
        AppCommonTextfield(
          hintText: "Confirm Password",
          controller: ref.watch(authprovider).confirmPasswordController,
          obsecureTextType: ObsecureText.confirmPassword,
        )
      ],
    );
  }
}
