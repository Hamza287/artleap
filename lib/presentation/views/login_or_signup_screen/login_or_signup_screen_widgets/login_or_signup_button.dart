import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class OnboardingButton extends ConsumerWidget {
  final String? title;
  final VoidCallback? onpress;
  const OnboardingButton({super.key, this.title, this.onpress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        height: 35,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: AppColors.indigo),
        child: Center(
            child: Text(
          title!,
          style: AppTextstyle.interRegular(
            color: AppColors.white,
            fontSize: 14,
          ),
        )),
      ),
    );
  }
}
