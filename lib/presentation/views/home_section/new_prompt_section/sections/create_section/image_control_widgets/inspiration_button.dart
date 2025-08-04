import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class InspirationButton extends StatelessWidget {
  const InspirationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Coming Soon',
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lightbulb_outline, color: AppColors.purple),
            const SizedBox(width: 8),
            Text(
              "Inspiration",
              style: AppTextstyle.interMedium(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}