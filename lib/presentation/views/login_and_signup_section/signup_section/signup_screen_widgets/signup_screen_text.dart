import 'package:Artleap.ai/shared/route_export.dart';

class SignupScreenText extends ConsumerWidget {
  const SignupScreenText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        5.spaceY,
        AppText(
          "Sign up to convert your imagination into reality",
           color: AppColors.white, size: 10,
        )
      ],
    );
  }
}
