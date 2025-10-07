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

    final isFollowing = userProfile.userProfileData?.user.following
        .any((user) => user.id == userId) ??
        false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Info
          GestureDetector(
            onTap: userId != null
                ? () {
              Navigation.pushNamed(
                OtherUserProfileScreen.routeName,
                arguments: OtherUserProfileParams(
                  userId: userId,
                  profileName: profileName,
                ),
              );
            }
                : null,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                   color:  Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.darkBlue.withOpacity(0.7),
                        size: 22,
                      ),
                    ),
                  ),
                ),
                12.spaceX,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Created by",
                      style: AppTextstyle.interRegular(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profileName ?? "Jack Bolt",
                      style: AppTextstyle.interMedium(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Follow Button
          if (userId != null && currentUserId != null)
            _buildFollowButton(ref,userProfile, isFollowing, currentUserId),
        ],
      ),
    );
  }

  Widget _buildFollowButton(WidgetRef ref,dynamic userProfile, bool isFollowing, String currentUserId) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (isFollowing)
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          else
            BoxShadow(
              color: const Color(0xff3586f1).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(userProfileProvider).followUnfollowUser(currentUserId, userId!);
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 40,
            width: isFollowing ? 100 : 90,
            decoration: BoxDecoration(
              gradient: isFollowing
                  ? const LinearGradient(
                colors: [Colors.white, Colors.white],
              )
                  : const LinearGradient(
                colors: [Color(0xff3586f1), Color(0xff2b6cdb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFollowing ? Colors.grey.shade300 : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Center(
              child: userProfile.isLoading
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
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isFollowing ? "Following" : "Follow",
                    style: AppTextstyle.interMedium(
                      color: isFollowing ? AppColors.darkBlue : Colors.white,
                      fontSize: 13,
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