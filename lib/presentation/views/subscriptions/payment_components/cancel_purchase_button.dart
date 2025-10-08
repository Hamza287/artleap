import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class CancelPurchaseButton extends StatelessWidget {
  final VoidCallback onCancel;

  const CancelPurchaseButton({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: onCancel,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cancel_rounded,
              size: 18,
              color: AppColors.red,
            ),
            const SizedBox(width: 8),
            Text(
              'Cancel Purchase',
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: AppColors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}