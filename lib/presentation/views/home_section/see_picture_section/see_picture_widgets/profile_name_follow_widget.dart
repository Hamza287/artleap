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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
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
            child: Container(
              child: Row(
                children: [
                  // Profile Avatar with Gradient Border
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.darkBlue,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 20,
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
                          color: Colors.grey[600]!,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profileName ?? "Jack Bolt",
                        style: AppTextstyle.interMedium(
                          color: AppColors.darkBlue,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Follow Button
          if (userId != null && currentUserId != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: isFollowing
                    ? [
                  BoxShadow(
                    color: const Color(0xff3586f1).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : [
                  BoxShadow(
                    color: const Color(0xff3586f1).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
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
                  child: Container(
                    height: 40,
                    width: 110,
                    decoration: BoxDecoration(
                      gradient: isFollowing
                          ? const LinearGradient(
                        colors: [Color(0xff3586f1), Color(0xff2b6cdb)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : const LinearGradient(
                        colors: [Color(0xff3586f1), Color(0xff2b6cdb)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: userProfile.isLoading
                          ? LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.white,
                        size: 20,
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isFollowing ? Icons.check_rounded : Icons.add_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isFollowing ? "Following" : "Follow",
                            style: AppTextstyle.interMedium(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}