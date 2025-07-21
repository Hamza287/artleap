import 'dart:io';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../shared/navigation/navigation.dart';

class DeleteAccountDialog extends ConsumerWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: Platform.isIOS
          ? EdgeInsets.only(left: 22, right: 22, top: 270, bottom: 200)
          : EdgeInsets.only(left: 22, right: 22, top: 270, bottom: 280),
      decoration: BoxDecoration(
        color: AppColors.darkIndigo,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          25.spaceY,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.deleteicon, height: 30, width: 30),
              15.spaceX,
              Container(
                height: 30,
                width: 200,
                child: Text(
                  "Are you sure you want to Delete your account?",
                  // textAlign: TextAlign.center,
                  maxLines: 3,
                  style: AppTextstyle.interMedium(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
          40.spaceY,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  ref
                      .read(userProfileProvider)
                      .deActivateAccount(UserData.ins.userId!);
                },
                child: Container(
                  height: 30,
                  width: 110,
                  decoration: BoxDecoration(
                    color: AppColors.redColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: ref.watch(userProfileProvider).isloading
                        ? LoadingAnimationWidget.threeArchedCircle(
                            color: AppColors.white,
                            size: 30,
                          )
                        : Text(
                            "Delete",
                            style: AppTextstyle.interRegular(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ),
              10.spaceX,
              GestureDetector(
                onTap: () {
                  // Call the method to clear user data and navigate back
                  // AppLocal.ins.clearUSerData(Hivekey.userId);

                  Navigation.pop();
                },
                child: Container(
                  height: 30,
                  width: 110,
                  decoration: BoxDecoration(
                    // color: AppColors.redColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: AppColors.white,
                      width: 0.50,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: AppTextstyle.interRegular(
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
