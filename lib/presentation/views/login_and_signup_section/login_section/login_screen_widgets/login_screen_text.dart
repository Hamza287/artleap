import 'package:Artleap.ai/shared/route_export.dart';


class LoginScreenText extends ConsumerWidget {
  const LoginScreenText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        5.spaceY,
        AppText(
          "Enter your email and password to log in ",
          color: AppColors.white, size: 12,
        )
      ],
    );
  }
}
