import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/constants/app_assets.dart';

class RegistrationBackgroundWidget extends ConsumerWidget {
  final Widget widget;
  const RegistrationBackgroundWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    AppAssets.backgroundImage,
                  ),
                  fit: BoxFit.cover)),
          child: widget,
        ),
      ),
    );
  }
}
