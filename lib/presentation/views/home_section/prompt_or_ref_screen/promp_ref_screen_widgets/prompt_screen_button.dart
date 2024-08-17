import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';

class PromptScreenButton extends ConsumerWidget {
  final String? title;
  final String? imageIcon;
  final VoidCallback? onpress;
  const PromptScreenButton(
      {super.key, this.title, this.imageIcon, this.onpress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        height: 35,
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.lightIndigo),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              imageIcon!,
              scale: 5,
            ),
            Text(
              title!,
              style:
                  AppTextstyle.interBold(color: AppColors.white, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
