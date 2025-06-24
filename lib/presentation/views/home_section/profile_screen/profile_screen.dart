import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/profile_screen_widgets/my_creations_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_background_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_pic_info_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/profile_screen_widgets/user_profile_metrics_widget.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserData.ins.userId != null) {
        ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId!);
      }
      AnalyticsService.instance.logScreenView(screenName: 'profile screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).userProfileData;
    final userId = UserData.ins.userId;
    final userName = UserData.ins.userName;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          ref.watch(bottomNavBarProvider).setPageIndex(0);
        }
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.lightIndigo, AppColors.darkIndigo],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileBackgroundWidget(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (userProfile != null) {
                            Navigation.pushNamed(
                              EditProfileScreen.routeName,
                              arguments: EditProfileSreenParams(
                                userName: userProfile.user.username,
                                profileImage: userProfile.user.profilePic,
                                userEmail: userProfile.user.email,
                              ),
                            );
                          }
                        },
                        child: const ProfilePicAndInfoWidget(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (userProfile != null)
                      UserProfileMatricsWidget(
                        followersCount: userProfile.user.followers.length,
                        followingCount: userProfile.user.following.length,
                        creationsCount: userProfile.user.images.length,
                      )
                    else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    MyCreationsWidget(
                      listofCreations: userProfile?.user.images ?? [],
                      userName: userName ?? 'User',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}