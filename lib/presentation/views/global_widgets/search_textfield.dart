import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/providers/home_screen_provider.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';

class SearchTextfield extends ConsumerWidget {
  const SearchTextfield({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 35,
      width: 320,
      // margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7), color: AppColors.greyBlue),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 4, bottom: 15),
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
        ),
        onChanged: (value) {
          ref.read(homeScreenProvider).searchByPrompt(value);
        },
      ),
    );
  }
}
