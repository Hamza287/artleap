import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
