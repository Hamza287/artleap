import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/user_info_widget.dart';
import 'package:photoroomapp/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:photoroomapp/shared/app_persistance/app_local.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:photoroomapp/shared/shared.dart';

import '../../../../../shared/constants/app_assets.dart';
import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_textstyle.dart';

class EditProfileWidget extends ConsumerWidget {
  final EditProfileSreenParams? params;
  const EditProfileWidget({super.key, this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.spaceY,
          Row(
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: params!.profileImage == ''
                            ? AssetImage(
                                AppAssets.profilepic,
                              )
                            : NetworkImage(
                                params!.profileImage ?? AppAssets.profilepic,
                              ),
                        fit: BoxFit.cover)),
              ),
              20.spaceX,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    params!.userName ?? "user name",
                    style: AppTextstyle.interMedium(
                        color: AppColors.white, fontSize: 14),
                  ),
                  10.spaceY,
                  Text(
                    params!.userEmail ?? "username@gmail.com",
                    style: AppTextstyle.interMedium(
                        color: AppColors.white, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          10.spaceY,
          50.spaceY,
          // IconWithTextTile(
          //   imageIcon: AppAssets.userinfoicon,
          //   title: "Personal Information",
          //   // titleColor: AppColors.redColor,
          // ),
          // 20.spaceY,
          // IconWithTextTile(
          //   imageIcon: AppAssets.privacyicon,
          //   title: "Privacy Policy",
          //   // titleColor: AppColors.redColor,
          // ),
          // 20.spaceY,
          // IconWithTextTile(
          //   imageIcon: AppAssets.abouticon,
          //   title: "About Artleap.AI",
          //   // titleColor: AppColors.redColor,
          // ),
          20.spaceY,
          InkWell(
            onTap: () {
              AppLocal.ins.clearUSerData(Hivekey.userId);
              Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
            },
            child: IconWithTextTile(
              imageIcon: AppAssets.logouticon,
              title: "Logout",
              titleColor: AppColors.redColor,
            ),
          )
        ],
      ),
    );
  }
}
