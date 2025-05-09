import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/user_info_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_pic_bottom_sheets/bottom_sheet_widget.dart/common_button.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_pic_bottom_sheets/bottom_sheet_widget.dart/other_textfield.dart';
import 'package:Artleap.ai/shared/shared.dart';

import '../../../../../providers/report_provider.dart';
import '../../../../../shared/constants/app_colors.dart';
import 'bottom_sheet_widget.dart/header_text.dart';

class OthersBottomSheet extends ConsumerWidget {
  final VoidCallback? onpress;
  const OthersBottomSheet({super.key, this.onpress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        height: 690,
        width: double.infinity,
        // margin: EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: InkWell(
                  onTap: () {
                    Navigation.pop();
                  },
                  child: const SizedBox(
                    height: 25,
                    width: 25,
                    child: Icon(
                      Icons.cancel,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          10.spaceY,
          const HeaderText(),
          // 20.spaceY,
          const OthersTextfield(),
          20.spaceY,
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ReportCommonButton(
              color: AppColors.indigo,
              width: double.infinity,
              title: "Send Report",
              icon: Icons.arrow_forward_ios,
              iconColor: AppColors.white,
              iconsize: 18,
              onpress: onpress,
            ),
          )
        ]));
  }
}
