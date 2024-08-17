import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/shared.dart';

class ProfileButton extends ConsumerWidget {
  final String? title;
  final Color? color;
  const ProfileButton({super.key, this.title, this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 30,
      width: 100,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(3), color: color),
      child: Center(
        child: Text(
          title!,
          style:
              AppTextstyle.interRegular(fontSize: 12, color: AppColors.white),
        ),
      ),
    );
  }
}
