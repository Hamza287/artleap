import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/image_actions_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class OthersTextfield extends ConsumerWidget {
  const OthersTextfield({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 218,
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: ref.watch(imageActionsProvider).othersTextController,
        style: AppTextstyle.interMedium(color: AppColors.white),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(8.0),
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
