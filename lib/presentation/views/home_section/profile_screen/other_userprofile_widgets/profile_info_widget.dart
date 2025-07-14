import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
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
              ref
                      .watch(userProfileProvider)
                      .otherUserProfileData!
                      .user
                      .profilePic
                      .isNotEmpty
                  ? Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(ref
                                  .watch(userProfileProvider)
                                  .otherUserProfileData!
                                  .user
                                  .profilePic)),
                          shape: BoxShape.circle,
                          color: AppColors.darkBlue),
                    )
                  : Container(
                      height: 55,
                      width: 55,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.darkBlue),
                      child: Image.asset(AppAssets.profilepic),
                    ),
              10.spaceY,
              Text(
                profileName ?? "User Name",
                style: AppTextstyle.interRegular(
                    color: AppColors.darkBlue, fontSize: 14),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
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
                                fontSize: 12, color: AppColors.darkBlue),
                          ),
                          Text(
                            ref
                                .watch(userProfileProvider)
                                .otherUserProfileData!
                                .user
                                .images
                                .length
                                .toString(),
                            style: AppTextstyle.interMedium(
                                fontSize: 14, color: AppColors.darkBlue),
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
                                fontSize: 12, color: AppColors.darkBlue),
                          ),
                          Text(
                            ref
                                    .watch(userProfileProvider)
                                    .otherUserProfileData!
                                    .user
                                    .followers
                                    .isEmpty
                                ? "0"
                                : ref
                                    .watch(userProfileProvider)
                                    .otherUserProfileData!
                                    .user
                                    .followers
                                    .length
                                    .toString(),
                            style: AppTextstyle.interMedium(
                                fontSize: 14, color: AppColors.darkBlue),
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
                                fontSize: 12, color: AppColors.darkBlue),
                          ),
                          Text(
                            ref
                                    .watch(userProfileProvider)
                                    .otherUserProfileData!
                                    .user
                                    .following
                                    .isEmpty
                                ? "0"
                                : ref
                                    .watch(userProfileProvider)
                                    .otherUserProfileData!
                                    .user
                                    .following
                                    .length
                                    .toString(),
                            style: AppTextstyle.interMedium(
                                fontSize: 14, color: AppColors.darkBlue),
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
                      .userProfileData!
                      .user
                      .following
                      .any(
                        (user) => user.id == userId,
                      )
                  ? GestureDetector(
                      onTap: () {
                        ref
                            .read(userProfileProvider)
                            .followUnfollowUser(UserData.ins.userId!, userId!);
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
                                color:AppColors.darkBlue,
                                size: 20,
                              )
                            : Center(
                                child: Text(
                                  "Following",
                                  style: AppTextstyle.interMedium(
                                      color: AppColors.white, fontSize: 12),
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
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: AppColors.darkBlue, width: 0.5)),
                        child: ref.watch(userProfileProvider).isloading
                            ? LoadingAnimationWidget.threeArchedCircle(
                                color: AppColors.darkBlue,
                                size: 20,
                              )
                            : Center(
                                child: Text(
                                  "Follow",
                                  style: AppTextstyle.interMedium(
                                      color: AppColors.darkBlue, fontSize: 12),
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
