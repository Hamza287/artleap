import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../../providers/favrourite_provider.dart';
import '../../../../../providers/user_profile_provider.dart';
import '../../../../../shared/constants/user_data.dart';

class ProfileInfoWidget extends ConsumerWidget {
  final String? profileName;
  final String? userId;
  const ProfileInfoWidget({super.key, this.profileName, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ref.watch(userProfileProvider).otherUserPersonalInfo != null
                  ? Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(ref
                                  .watch(userProfileProvider)
                                  .otherUserPersonalInfo!["profile_image"])),
                          shape: BoxShape.circle,
                          color: AppColors.white),
                    )
                  : Container(
                      height: 55,
                      width: 55,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.white),
                    ),
              10.spaceY,
              Text(
                profileName ?? "User Name",
                style: AppTextstyle.interRegular(
                    color: AppColors.white, fontSize: 14),
              )
            ],
          ),
          Column(
            children: [
              Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Creations",
                            style: AppTextstyle.interRegular(
                                fontSize: 12, color: AppColors.white),
                          ),
                          Text(
                            ref
                                .watch(userProfileProvider)
                                .otherUserProfileData["userData"]
                                .length
                                .toString(),
                            style: AppTextstyle.interMedium(
                                fontSize: 14, color: AppColors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Follower",
                            style: AppTextstyle.interRegular(
                                fontSize: 12, color: AppColors.white),
                          ),
                          Text(
                            ref
                                        .watch(userProfileProvider)
                                        .otherUserProfileData["followers"] ==
                                    null
                                ? "0"
                                : ref
                                    .watch(userProfileProvider)
                                    .otherUserProfileData["followers"]
                                    .length
                                    .toString(),
                            style: AppTextstyle.interMedium(
                                fontSize: 14, color: AppColors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Following",
                            style: AppTextstyle.interRegular(
                                fontSize: 12, color: AppColors.white),
                          ),
                          Text(
                            ref
                                        .watch(userProfileProvider)
                                        .otherUserProfileData["following"] ==
                                    null
                                ? "0"
                                : ref
                                    .watch(userProfileProvider)
                                    .otherUserProfileData["following"]
                                    .length
                                    .toString(),
                            style: AppTextstyle.interMedium(
                                fontSize: 14, color: AppColors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              20.spaceY,
              ref
                      .watch(userProfileProvider)
                      .userFollowingData
                      .any((user) => user["userid"] == userId)
                  ? GestureDetector(
                      onTap: () {
                        ref.read(userProfileProvider).userUnfollowRequest(
                            UserData.ins.userId!,
                            userId!,
                            profileName!,
                            UserData.ins.userName!);
                      },
                      child: Container(
                        height: 30,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.seaBlue,
                            border: Border.all(
                                color: AppColors.seaBlue, width: 0.5)),
                        child: ref.watch(userProfileProvider).isloading
                            ? LoadingAnimationWidget.threeArchedCircle(
                                color: AppColors.white,
                                size: 20,
                              )
                            : Center(
                                child: Text(
                                  "Following",
                                  style: AppTextstyle.interRegular(
                                      color: AppColors.white, fontSize: 12),
                                ),
                              ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ref.read(userProfileProvider).userFollowRequest(
                            UserData.ins.userId!,
                            userId!,
                            profileName!,
                            UserData.ins.userName!);
                      },
                      child: Container(
                        height: 30,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: AppColors.white, width: 0.5)),
                        child: ref.watch(userProfileProvider).isloading
                            ? LoadingAnimationWidget.threeArchedCircle(
                                color: AppColors.white,
                                size: 20,
                              )
                            : Center(
                                child: Text(
                                  "Follow",
                                  style: AppTextstyle.interRegular(
                                      color: AppColors.white, fontSize: 12),
                                ),
                              ),
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }
}
