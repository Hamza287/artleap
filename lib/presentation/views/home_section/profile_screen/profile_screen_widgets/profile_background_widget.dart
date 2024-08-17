import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';

class ProfileBackgroundWidget extends ConsumerWidget {
  final Widget widget;
  const ProfileBackgroundWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppAssets.profilebackground),
              fit: BoxFit.cover)),
      child: widget,
    );
  }
}
