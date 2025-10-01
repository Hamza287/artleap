import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class ImageSelectionButton extends StatelessWidget {
  final bool hasImage;
  final VoidCallback onPressed;
  final bool showPremiumIcon;

  const ImageSelectionButton({
    super.key,
    required this.hasImage,
    required this.onPressed,
    this.showPremiumIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasImage ? Icons.image : Icons.add_photo_alternate,
            color: AppColors.purple,
          ),
          const SizedBox(width: 8),
          Text(
            hasImage ? "Change Image" : "Add Image",
            style: AppTextstyle.interMedium(fontSize: 14),
          ),
          if (showPremiumIcon && !hasImage) ...[
            const SizedBox(width: 4),
            Image.asset('assets/icons/upgrade_pro.png',width: 20,height: 20,)
          ],
        ],
      ),
    );
  }
}