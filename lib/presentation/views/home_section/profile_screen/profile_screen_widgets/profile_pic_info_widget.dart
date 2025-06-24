import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../../../providers/user_profile_provider.dart';

class ProfilePicAndInfoWidget extends ConsumerWidget {
  const ProfilePicAndInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final user = userProfile.userProfileData?.user;
    final profilePic = user?.profilePic;
    final userName = user?.username ?? 'Guest';

    if (user == null) {
      return const CircularProgressIndicator(); // or placeholder widget
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            image: profilePic != null && profilePic.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(profilePic),
              fit: BoxFit.cover,
            )
                : const DecorationImage(
              image: AssetImage(AppAssets.artstyle1),
              fit: BoxFit.cover,
            ),
          ),
        ),
        10.spaceY,
        Text(
          userName,
          style: AppTextstyle.interMedium(
            color: AppColors.white,
            fontSize: 14,
          ),
        ),
        20.spaceY,
      ],
    );
  }
}