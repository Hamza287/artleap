import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/shared.dart';

class SeparatorWidget extends ConsumerWidget {
  final String title;
  const SeparatorWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 20,
      // width: 100,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            title,
            style:
                AppTextstyle.interRegular(color: AppColors.white, fontSize: 14),
          ),
          5.spaceX,
          Container(
            height: 1,
            width: 260,
            // width: double.infinity,
            color: AppColors.white.withOpacity(0.5),
          )
        ],
      ),
    );
  }
}
