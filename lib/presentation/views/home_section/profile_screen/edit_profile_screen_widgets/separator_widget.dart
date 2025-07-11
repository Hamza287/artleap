import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/shared.dart';

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
            width: 200,
            color: AppColors.white.withOpacity(0.5),
          )
        ],
      ),
    );
  }
}
