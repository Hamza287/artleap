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
    final userProfile = ref.watch(userProfileProvider);
    final currentUserId = UserData.ins.userId;

    // Check if user is following the profile
    final isFollowing = userProfile.userProfileData?.user.following
        .any((user) => user.id == userId) ?? false;

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: userId != null ? () {
              Navigation.pushNamed(
                OtherUserProfileScreen.routeName,
                arguments: OtherUserProfileParams(
                  userId: userId,
                  profileName: profileName,
                ),
              );
            } : null,
            child: Container(
              child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.black,
                    ),
                  ),
                  10.spaceX,
                  Text(
                    profileName ?? "Jack Bolt",
                    style: AppTextstyle.interMedium(
                      color: AppColors.darkBlue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (userId != null && currentUserId != null)
            isFollowing
                ? GestureDetector(
              onTap: () {
                ref.read(userProfileProvider)
                    .followUnfollowUser(currentUserId, userId!);
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xff3586f1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.seaBlue),
                ),
                child: Center(
                  child: userProfile.isloading
                      ? LoadingAnimationWidget.threeArchedCircle(
                    color: AppColors.darkBlue,
                    size: 20,
                  )
                      : Text(
                    "Following",
                    style: AppTextstyle.interMedium(
                      color: AppColors.darkBlue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                ref.read(userProfileProvider)
                    .followUnfollowUser(currentUserId, userId!);
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xff3586f1)),
                  color: Color(0xff3586f1),
                ),
                child: Center(
                  child: userProfile.isloading
                      ? LoadingAnimationWidget.threeArchedCircle(
                    color: AppColors.white,
                    size: 20,
                  )
                      : Text(
                    "Follow",
                    style: AppTextstyle.interMedium(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(), // Show empty container if userId or currentUserId is null
        ],
      ),
    );
  }
}