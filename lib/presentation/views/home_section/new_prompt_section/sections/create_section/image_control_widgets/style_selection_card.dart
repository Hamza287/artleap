import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class StyleSelectionCard extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const StyleSelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.purple.withValues(),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.white : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.purple : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Image.asset(
                icon,
                width: 60,
                height: 60,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: isSelected ? AppColors.purple : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}