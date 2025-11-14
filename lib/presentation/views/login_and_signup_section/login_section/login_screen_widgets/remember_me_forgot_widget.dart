import 'package:Artleap.ai/shared/route_export.dart';

class RememberMeForgotPassWidget extends ConsumerWidget {
  const RememberMeForgotPassWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 285,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: Row(
            children: [
              Container(
                  height: 15,
                  width: 15,
                  child: Transform.scale(
                      scale: 0.8,
                      child: Checkbox(value: true, onChanged: (val) {}))),
              5.spaceX,
              AppText(
                "Remember me",
                  color: AppColors.white,
                  size: 12,
              ),
            ],
          )),
          GestureDetector(
            onTap: () {
              Navigation.pushNamed(ForgotPasswordScreen.routeName);
            },
            child: AppText(
              "Forgot Password ?",
               color: AppColors.white, size: 12,
            ),
          )
        ],
      ),
    );
  }
}
