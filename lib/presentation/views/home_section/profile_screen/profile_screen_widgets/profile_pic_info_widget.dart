import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/user_data.dart';
import 'package:photoroomapp/shared/shared.dart';
import '../../../../../providers/user_profile_provider.dart';

class ProfilePicAndInfoWidget extends ConsumerWidget {
  const ProfilePicAndInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ref
                .watch(userProfileProvider)
                .userProfileData!
                .user
                .profilePic
                .isNotEmpty
            ? Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(ref
                            .watch(userProfileProvider)
                            .userProfileData!
                            .user
                            .profilePic)),
                    shape: BoxShape.circle,
                    color: AppColors.white),
              )
            : Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppAssets.artstyle1),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                    color: AppColors.white),
              ),
        10.spaceY,
        Text(
          UserData.ins.userName.toString(),
          style: AppTextstyle.interMedium(color: AppColors.white, fontSize: 14),
        ),

        20.spaceY,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ProfileButton(
        //       title: "Share",
        //       color: AppColors.blueColor,
        //     ),
        //     5.spaceX,
        //     ProfileButton(
        //       title: "Edit",
        //       color: AppColors.indigo.withOpacity(0.5),
        //     )
        //   ],
        // )
      ],
    );
  }
}
