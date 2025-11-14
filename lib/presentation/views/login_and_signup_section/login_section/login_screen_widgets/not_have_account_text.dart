import 'package:Artleap.ai/shared/route_export.dart';

class NotHaveAccountText extends ConsumerWidget {
  const NotHaveAccountText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        RichText(
            text: TextSpan(
                style: AppTextstyle.interRegular(
                    color: AppColors.white, fontSize: 12),
                text: "Don’t have an account?  ",
                children: [
              TextSpan(
                  text: "Sign up",
                  style: AppTextstyle.interMedium(
                      color: AppColors.indigo, fontSize: 13),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigation.pushNamed(SignUpScreen.routeName);
                    })
            ])),
      ],
    );
  }
}
