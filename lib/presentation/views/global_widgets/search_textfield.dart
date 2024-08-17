import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';

class SearchTextfield extends ConsumerWidget {
  const SearchTextfield({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 35,
      // margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors.mediumIndigo),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 4, bottom: 15),
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: "Search AI Creations",
            hintStyle:
                AppTextstyle.interRegular(fontSize: 14, color: AppColors.white),
            prefixIcon: Image.asset(
              AppAssets.searchicon,
              scale: 4.5,
            ),
            suffixIcon: Image.asset(
              AppAssets.micicon,
              scale: 4.5,
            )),
      ),
    );
  }
}
