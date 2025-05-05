import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';

import '../../shared/constants/app_assets.dart';

class RegistrationBackgroundWidget extends ConsumerWidget {
  final Widget widget;
  final String? bgImage;
  const RegistrationBackgroundWidget(
      {super.key, required this.widget, this.bgImage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBlue,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    bgImage ?? AppAssets.backgroundImage,
                  ),
                  fit: BoxFit.cover)),
          child: widget,
        ),
      ),
    );
  }
}
