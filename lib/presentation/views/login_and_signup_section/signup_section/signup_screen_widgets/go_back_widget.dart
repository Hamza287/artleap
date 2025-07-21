import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';

class GoBackWidget extends ConsumerWidget {
  const GoBackWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image.asset(
      AppAssets.gobackicon,
      scale: 2,
    );
  }
}
