import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/constants/app_colors.dart';

class AppBackgroundWidget extends ConsumerWidget {
  final Widget widget;
  const AppBackgroundWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: AssetImage(
              //       AppAssets.appHomeBg,
              //     ),
              // fit: BoxFit.cover)
              color: AppColors.darkBlue),
          child: widget,
        ),
      ),
    );
  }
}
