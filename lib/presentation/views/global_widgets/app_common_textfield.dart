import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';

class AppCommonTextfield extends ConsumerWidget {
  final String? hintText;
  final TextEditingController? controller;
  const AppCommonTextfield({super.key, this.hintText, this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 35,
      width: 240,
      decoration: BoxDecoration(
          color: AppColors.lightIndigo.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.white, width: 0.50)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8, bottom: 15),
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: AppTextstyle.interRegular(
                color: AppColors.white, fontSize: 14)),
      ),
    );
  }
}
