import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';

class PremiumButton extends ConsumerWidget {
  const PremiumButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 35,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors  : [
            AppColors.indigo,
            AppColors.matepink,
            AppColors.seaBlue
          ])),
      child: Center(
        child: Text(
          "Get Premium Plan",
          style: AppTextstyle.interMedium(color: AppColors.white, fontSize: 11),
        ),
      ),
    );
  }
}
