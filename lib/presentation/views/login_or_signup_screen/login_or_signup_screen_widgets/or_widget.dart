import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class ORwidget extends ConsumerWidget {
  const ORwidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1,
          width: 120,
          color: AppColors.white.withOpacity(0.5),
        ),
        5.spaceX,
        Text(
          "or",
          style: AppTextstyle.interRegular(
              color: AppColors.white.withOpacity(0.5)),
        ),
        5.spaceX,
        Container(
          height: 1,
          width: 120,
          color: AppColors.white.withOpacity(0.5),
        ),
      ],
    );
  }
}
