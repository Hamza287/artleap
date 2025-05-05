import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/edit_profile_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/my_creations_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_pic_info_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/user_profile_metrics_widget.dart';
import 'package:photoroomapp/providers/bottom_nav_bar_provider.dart';
import 'package:photoroomapp/providers/user_profile_provider.dart';
import 'package:photoroomapp/shared/constants/user_data.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';
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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId!);
      AnalyticsService.instance.logScreenView(screenName: 'profile screen');
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      colors: [AppColors.lightIndigo, AppColors.darkIndigo])),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 20),
                    //       child: Image.asset(
                    //         AppAssets.notificationicon,
                    //         scale: 2.4,
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                    //     future: ref
                    //         .read(userProfileProvider)
                    //         .fetchUserPersonalData(UserData.ins.userId!),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return const Center(child: SizedBox());
                    //       } else if (snapshot.hasError) {
                    //         return Center(
                    //             child: Text('Error: ${snapshot.error}'));
                    //       } else {
                    //         DocumentSnapshot<Map<String, dynamic>>?
                    //             userPersonalData = snapshot.data;

                    //         if (userPersonalData == null ||
                    //             userPersonalData.data() == null) {
                    //           return Center(
                    //             child: Text(
                    //               "No data yet",
                    //               style: AppTextstyle.interBold(
                    //                   fontSize: 15, color: AppColors.black),
                    //             ),
                    //           );
                    //         } else {
                    // Map<String, dynamic> data =
                    //     userPersonalData.data()!;
                    // String userName = data['username'] ?? '';
                    // String profileImage = data['profile_image'] ?? '';
                    // String userEmail = data['email'] ?? '';

                    ProfileBackgroundWidget(
                      widget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigation.pushNamed(
                                    EditProfileScreen.routeName,
                                    arguments: EditProfileSreenParams(
                                      userName: ref
                                          .watch(userProfileProvider)
                                          .userProfileData!
                                          .user
                                          .username,
                                      profileImage: ref
                                          .watch(userProfileProvider)
                                          .userProfileData!
                                          .user
                                          .profilePic,
                                      userEmail: ref
                                          .watch(userProfileProvider)
                                          .userProfileData!
                                          .user
                                          .email,
                                    ));
                              },
                              child: const ProfilePicAndInfoWidget()),
                        ],
                      ),
                    ),
                    // }
                    //   }
                    // }),
                    Column(
                      children: [
                        UserProfileMatricsWidget(
                          followersCount: ref
                              .watch(userProfileProvider)
                              .userProfileData!
                              .user
                              .followers
                              .length,
                          followingCount: ref
                              .watch(userProfileProvider)
                              .userProfileData!
                              .user
                              .following
                              .length,
                          creationsCount: ref
                              .watch(userProfileProvider)
                              .userProfileData!
                              .user
                              .images
                              .length,
                        ),
                        const SizedBox(height: 20),
                        MyCreationsWidget(
                          listofCreations: ref
                              .watch(userProfileProvider)
                              .userProfileData!
                              .user
                              .images,
                          userName: UserData.ins.userName,
                        ),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}
