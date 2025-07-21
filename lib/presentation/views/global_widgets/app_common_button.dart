import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/shared.dart';

class CommonButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onpress;
  final Color? color;
  final LinearGradient? gradient;
  final Color? borderColor;
  final double? width;
  final double? height;
  final Color? buttonTextColor;
  final IconData? icon;
  final String? imageicon;
  final double? titlefontsize;
  final double? iconsize;
  final Color? iconColor;

  const CommonButton(
      {super.key,
      this.title,
      this.onpress,
      this.color,
      this.gradient,
      this.borderColor,
      this.width,
      this.height,
      this.buttonTextColor,
      this.icon,
      this.imageicon,
      this.titlefontsize,
      this.iconsize,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        height: 46,
        width: 285,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            gradient: gradient,
            border: Border.all(color: borderColor ?? color!, width: 0.40)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: iconsize,
                  color: iconColor,
                ),
              if (imageicon != null)
                Image.asset(
                  imageicon!,
                  scale: 5,
                ),
              if (icon != null || imageicon != null) 10.spaceX,
              Text(
                title!,
                style: AppTextstyle.interMedium(
                    fontSize: titlefontsize ?? 14,
                    color: buttonTextColor ?? AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
