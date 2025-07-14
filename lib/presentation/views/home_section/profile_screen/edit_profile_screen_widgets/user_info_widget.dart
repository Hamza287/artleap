import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';

class IconWithTextTile extends ConsumerWidget {
  final String? imageIcon;
  final String? title;
  final Color? titleColor;
  const IconWithTextTile(
      {super.key, this.imageIcon, this.title, this.titleColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Container(
          width: 25,
          child: Image.asset(
            imageIcon!,
            scale: 1,
          ),
        ),
        12.spaceX,
        Text(
          title!,
          style: AppTextstyle.interMedium(
              fontSize: 13, color: titleColor ?? AppColors.white),
        ),
      ],
    );
  }
}
