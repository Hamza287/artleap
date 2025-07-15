import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class RatioSelectionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSmall;

  const RatioSelectionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSmall) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 73,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0x98923CFF) : Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Center(
            child: Text(
              text,
              style: AppTextstyle.interMedium(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 60,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xD8923CFF) : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Center(
            child: Text(
              text,
              style: AppTextstyle.interMedium(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}