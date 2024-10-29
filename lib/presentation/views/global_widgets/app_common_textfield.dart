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
      height: 46,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: AppColors.black.withOpacity(0.2), width: 0.50)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8, bottom: 8),
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: AppTextstyle.interMedium(
                color: AppColors.black.withOpacity(0.5), fontSize: 14)),
      ),
    );
  }
}
