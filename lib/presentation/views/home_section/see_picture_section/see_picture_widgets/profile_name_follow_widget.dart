import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/other_user_profile_screen.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import '../../../../../shared/constants/user_data.dart';

class ProfileNameFollowWidget extends ConsumerWidget {
  final String? profileName;
  final String? userId;
  const ProfileNameFollowWidget({super.key, this.profileName, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(userId);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigation.pushNamed(OtherUserProfileScreen.routeName,
                  arguments: OtherUserProfileParams(
                      userId: userId, profileName: profileName));
            },
            child: Container(
              child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.black),
                  ),
                  10.spaceX,
                  Text(
                    profileName ?? "Jack Bolt",
                    style: AppTextstyle.interMedium(
                        color: AppColors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          ref.watch(userProfileProvider).userProfileData!.user.following.any(
            (user) {
              return user.id == userId;
            },
          )
              ? GestureDetector(
                  onTap: () {
                    ref
                        .read(userProfileProvider)
                        .followUnfollowUser(UserData.ins.userId!, userId!);
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                        color: AppColors.seaBlue,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.seaBlue)),
                    child: Center(
                      child: ref.watch(userProfileProvider).isloading
                          ? LoadingAnimationWidget.threeArchedCircle(
                              color: AppColors.white,
                              size: 20,
                            )
                          : Text(
                              "Following",
                              style: AppTextstyle.interMedium(
                                  color: AppColors.white, fontSize: 14),
                            ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    ref
                        .read(userProfileProvider)
                        .followUnfollowUser(UserData.ins.userId!, userId!);
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.white)),
                    child: Center(
                      child: ref.watch(userProfileProvider).isloading
                          ? LoadingAnimationWidget.threeArchedCircle(
                              color: AppColors.white,
                              size: 20,
                            )
                          : Text(
                              "Follow",
                              style: AppTextstyle.interMedium(
                                  color: AppColors.white, fontSize: 14),
                            ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
