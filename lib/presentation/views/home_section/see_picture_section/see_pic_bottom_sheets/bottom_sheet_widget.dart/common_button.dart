import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';

// ignore: must_be_immutable
class ReportCommonButton extends ConsumerWidget {
  final String? title;
  final VoidCallback? onpress;
  final Color? color;
  final Color? borderColor;
  final double? width;
  final double? height;
  final Color? buttonTextColor;
  final IconData? icon;
  final double? iconsize;

  final Color? iconColor;
  ReportCommonButton({
    super.key,
    this.title,
    this.onpress,
    this.color,
    this.borderColor,
    this.width,
    this.height,
    this.buttonTextColor,
    this.icon,
    this.iconsize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onpress,
      child: Container(
        height: 46,
        width: width ?? 285,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor ?? color!, width: 0.40)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title!,
                style: AppTextstyle.interBold(
                    fontSize: 14, color: buttonTextColor ?? AppColors.white),
              ),
              if (icon != null) 10.spaceX,
              if (icon != null)
                Icon(
                  icon,
                  size: iconsize,
                  color: iconColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
