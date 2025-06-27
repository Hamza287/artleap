import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/delete_account_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/user_info_widget.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../../../providers/user_profile_provider.dart';
import 'separator_widget.dart';

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

          // 30.spaceY,
          GestureDetector(
            onTap: () {
              Navigation.pop();
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.white,
            ),
          ),
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
          SeparatorWidget(
            title: "General",
          ),
          20.spaceY,

          GestureDetector(
            onTap: () {
              ref.read(userProfileProvider).launchAnyUrl(
                  "https://x-r.digital/privacy-policy/artleap-ai/");
            },
            child: IconWithTextTile(
              imageIcon: AppAssets.privacyicon,
              title: "Privacy Policy",
            ),
          ),
          50.spaceY,
          SeparatorWidget(
            title: "About",
          ),
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
          ),
          20.spaceY,
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const DeleteAccountDialog(),
              );
            },
            child: IconWithTextTile(
              imageIcon: AppAssets.deleteicon,
              title: "Delete Account",
              titleColor: AppColors.redColor,
            ),
          ),
          80.spaceY,

          // NativeAdWidget()
        ],
      ),
    );
  }
}
