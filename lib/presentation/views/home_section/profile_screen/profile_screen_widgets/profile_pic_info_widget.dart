import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_button.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/shared.dart';

class ProfilePicAndInfoWidget extends ConsumerWidget {
  const ProfilePicAndInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppAssets.profilepic,
          scale: 5,
        ),
        Text(
          "User Name",
          style: AppTextstyle.interMedium(color: AppColors.white, fontSize: 14),
        ),
        Text(
          "@useremail",
          style:
              AppTextstyle.interRegular(color: AppColors.white, fontSize: 11),
        ),
        20.spaceY,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileButton(
              title: "Share",
              color: AppColors.blueColor,
            ),
            5.spaceX,
            ProfileButton(
              title: "Edit",
              color: AppColors.indigo.withOpacity(0.5),
            )
          ],
        )
      ],
    );
  }
}
