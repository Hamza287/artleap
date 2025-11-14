import 'package:Artleap.ai/shared/route_export.dart';

class AlreadyHaveAccountText extends ConsumerWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        RichText(
            text: TextSpan(
                style: AppTextstyle.interRegular(
                    color: theme.onSurface, fontSize: 12),
                text: "Already have an account?  ",
                children: [
              TextSpan(
                  text: "Login",
                  style: AppTextstyle.interMedium(
                      color: AppColors.indigo, fontSize: 12),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
                    })
            ])),
      ],
    );
  }
}
