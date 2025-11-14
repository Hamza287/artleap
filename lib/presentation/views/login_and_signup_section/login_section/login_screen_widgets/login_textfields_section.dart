import 'package:Artleap.ai/widgets/common/app_common_textfield.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class LoginScreenTextfieldsSection extends ConsumerWidget {
  const LoginScreenTextfieldsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCommonTextfield(
          hintText: "Email",
          controller: ref.watch(authprovider).emailController,
        ),
        10.spaceY,
        AppCommonTextfield(
            hintText: "Password",
            controller: ref.watch(authprovider).passwordController,
            obsecureTextType: ObsecureText.loginPassword)
      ],
    );
  }
}
