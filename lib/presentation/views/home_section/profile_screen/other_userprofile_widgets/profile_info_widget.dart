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
    final userProfile = ref.watch(userProfileProvider);
    final otherUser = userProfile.otherUserProfileData?.user;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildProfileAvatar(userProfile),
              16.spaceX,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileName ?? "User Name",
                      style: AppTextstyle.interMedium(
                        color: AppColors.darkBlue,
                        fontSize: 18,
                      ),
                    ),
                    6.spaceY,
                    Text(
                      "AI Artist",
                      style: AppTextstyle.interRegular(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.spaceY,
          _buildStatsRow(otherUser),
          20.spaceY,
          _buildFollowButton(userProfile,ref),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(dynamic userProfile) {
    final hasProfilePic = userProfile.otherUserProfileData?.user.profilePic.isNotEmpty ?? false;

    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: ClipOval(
        child: hasProfilePic
            ? Image.network(
          userProfile.otherUserProfileData!.user.profilePic,
          fit: BoxFit.cover,
        )
            : Container(
          color: Colors.grey.shade100,
          child: Icon(
            Icons.person_rounded,
            color: Colors.grey.shade400,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(dynamic otherUser) {
    final creations = otherUser?.images.length ?? 0;
    final followers = otherUser?.followers.length ?? 0;
    final following = otherUser?.following.length ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Creations", creations.toString()),
          Container(height: 30, width: 1, color: Colors.grey.shade300),
          _buildStatItem("Followers", followers.toString()),
          Container(height: 30, width: 1, color: Colors.grey.shade300),
          _buildStatItem("Following", following.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextstyle.interMedium(
            fontSize: 16,
            color: AppColors.darkBlue,
          ),
        ),
        4.spaceY,
        Text(
          label,
          style: AppTextstyle.interRegular(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildFollowButton(dynamic userProfile,WidgetRef ref) {
    final isFollowing = userProfile.userProfileData?.user.following.any((user) => user.id == userId) ?? false;
    final isLoading = userProfile.isLoading;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(userProfileProvider).followUnfollowUser(UserData.ins.userId!, userId!);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isFollowing ? Colors.white : AppColors.darkBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFollowing ? Colors.grey.shade400 : AppColors.darkBlue,
                width: 1.5,
              ),
            ),
            child: Center(
              child: isLoading
                  ? LoadingAnimationWidget.threeArchedCircle(
                color: isFollowing ? AppColors.darkBlue : Colors.white,
                size: 20,
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFollowing ? Icons.check_rounded : Icons.add_rounded,
                    color: isFollowing ? AppColors.darkBlue : Colors.white,
                    size: 18,
                  ),
                  8.spaceX,
                  Text(
                    isFollowing ? "Following" : "Follow",
                    style: AppTextstyle.interMedium(
                      color: isFollowing ? AppColors.darkBlue : Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}