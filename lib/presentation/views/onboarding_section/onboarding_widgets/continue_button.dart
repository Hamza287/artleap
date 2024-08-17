import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/shared.dart';

class ContinueButton extends ConsumerWidget {
  final VoidCallback? onpress;
  const ContinueButton({super.key, this.onpress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onpress,
      child: Container(
        height: 40,
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.indigo,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Continue",
              style: AppTextstyle.interMedium(
                  fontSize: 16, color: AppColors.white),
            ),
            5.spaceX,
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
