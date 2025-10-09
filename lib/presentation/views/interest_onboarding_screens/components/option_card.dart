import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? const Color(0xFF875EFF) : Colors.grey.shade300,
              width: isSelected ? 2.0 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12.0),
            color: isSelected ? const Color(0xFF875EFF).withOpacity(0.05) : Colors.white,
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: const Color(0xFF875EFF).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ]
                : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextstyle.interMedium(
                    fontSize: 16.0,
                    color: isSelected ? const Color(0xFF875EFF) : Colors.black,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF875EFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}