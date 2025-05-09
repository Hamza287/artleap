import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';

class ProfileBackgroundWidget extends ConsumerWidget {
  final Widget widget;
  const ProfileBackgroundWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.lightIndigo, AppColors.darkIndigo])),
      child: widget,
    );
  }
}
