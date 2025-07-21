import 'package:flutter/material.dart';
import '../../../shared/auth_exception_handler/auth_exception_handler.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/constants/app_textstyle.dart';

class CustomErrorWidget extends StatelessWidget {
  final bool isShow;
  final String? message;
  final AuthResultStatus? authResultState;
  final VoidCallback? onTap;
  const CustomErrorWidget(
      {super.key,
      required this.isShow,
      this.message,
      required this.authResultState,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: isShow
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message ?? '',
                    style: AppTextstyle.interRegular(color: AppColors.redColor),
                    maxLines: 2,
                  ),
                  if (authResultState == AuthResultStatus.emailNotVerified)
                    InkWell(
                        onTap: () => onTap!(),
                        child: Text(
                          " Resend Email",
                          style:
                              AppTextstyle.interRegular(color: AppColors.green),
                        ))
                ],
              )
            : SizedBox());
  }
}
