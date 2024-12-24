import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/edit_profile_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/my_creations_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_pic_info_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/user_profile_metrics_widget.dart';
import 'package:photoroomapp/providers/bottom_nav_bar_provider.dart';
import 'package:photoroomapp/providers/user_profile_provider.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/user_data.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';

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
      ref.read(userProfileProvider).getUserProfiledata();
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
              decoration: BoxDecoration(
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
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                        future: ref
                            .read(userProfileProvider)
                            .fetchUserPersonalData(UserData.ins.userId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: SizedBox());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            DocumentSnapshot<Map<String, dynamic>>?
                                userPersonalData = snapshot.data;

                            if (userPersonalData == null ||
                                userPersonalData.data() == null) {
                              return Center(
                                child: Text(
                                  "No data yet",
                                  style: AppTextstyle.interBold(
                                      fontSize: 15, color: AppColors.black),
                                ),
                              );
                            } else {
                              Map<String, dynamic> data =
                                  userPersonalData.data()!;
                              String userName = data['username'] ?? '';
                              String profileImage = data['profile_image'] ?? '';
                              String userEmail = data['email'] ?? '';

                              return ProfileBackgroundWidget(
                                widget: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigation.pushNamed(
                                              EditProfileScreen.routeName,
                                              arguments: EditProfileSreenParams(
                                                  userName: userName,
                                                  profileImage: profileImage,
                                                  userEmail: userEmail));
                                        },
                                        child: ProfilePicAndInfoWidget()),
                                  ],
                                ),
                              );
                            }
                          }
                        }),
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                      future:
                          ref.read(userProfileProvider).fetchUserProfileData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LoadingAnimationWidget.threeArchedCircle(
                              color: AppColors.white,
                              size: 30,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          // Initialize default values
                          int followersCount = 0;
                          int followingCount = 0;
                          int creationsCount = 0;
                          List<dynamic> usersCreations = [];
                          DocumentSnapshot<Map<String, dynamic>>?
                              userProfiledata = snapshot.data;
                          if (userProfiledata != null &&
                              userProfiledata.data() != null) {
                            Map<String, dynamic> data = userProfiledata.data()!;
                            followersCount = data['Followers'] ?? 0;
                            followingCount = data['Followings'] ?? 0;
                            creationsCount = data['Creations'] ?? 0;
                            usersCreations = data['userData'] ?? [];
                          }
                          return Column(
                            children: [
                              UserProfileMatricsWidget(
                                followersCount: followersCount,
                                followingCount: followingCount,
                                creationsCount: creationsCount,
                              ),
                              SizedBox(height: 20),
                              MyCreationsWidget(
                                listofCreations: usersCreations,
                                userName: UserData.ins.userName,
                              ),
                            ],
                          );
                        }
                      },
                    )
                  ],
                ),
              ))),
    );
  }
}
