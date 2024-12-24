import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/forgot_password_section/forgot_password_screen.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_static_data.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class HeaderText extends ConsumerWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        25.spaceY,
        Text(
          "Report",
          style: AppTextstyle.interMedium(
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        35.spaceY,
        Text(
          "Why are you reporting this post?",
          style: AppTextstyle.interMedium(
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        20.spaceY,
        Text(
          "Help us maintain a safe and positive community by \n reporting images that violate our guidelines.",
          textAlign: TextAlign.center,
          style: AppTextstyle.interRegular(
            color: AppColors.white,
            fontSize: 13,
          ),
        ),
        40.spaceY,
      ],
    );
  }
}
