import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class PromptScreenButton extends StatelessWidget {
  final String? title;
  final String? imageIcon;
  final VoidCallback? onpress;
  final bool isLoading;
  final double? height;
  final double? width;
  final double? imageIconSize;

  const PromptScreenButton(
      {super.key,
      this.title,
      this.imageIcon,
      this.onpress,
      required this.isLoading,
      this.height,
      this.width,
      this.imageIconSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        height: height ?? 35,
        width: width ?? 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.indigo, // Set your desired button color here
        ),
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.white,
                  size: 30,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imageIcon!,
                    scale: imageIconSize ?? 2,
                  ),
                  if (title != null) 10.spaceX,
                  if (title != null)
                    Text(
                      title!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
