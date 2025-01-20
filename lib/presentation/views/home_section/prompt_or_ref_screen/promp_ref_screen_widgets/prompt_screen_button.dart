import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class PromptScreenButton extends ConsumerWidget {
  final String? title;
  final String? imageIcon;
  final VoidCallback? onpress;
  final bool isLoading;
  final double? height;
  final double? width;
  final double? imageIconSize;
  final bool? suffixRow;
  const PromptScreenButton(
      {super.key,
      this.title,
      this.imageIcon,
      this.onpress,
      required this.isLoading,
      this.height,
      this.width,
      this.imageIconSize,
      this.suffixRow});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: isLoading ? () {} : onpress,
      child: Container(
        height: height ?? 35,
        width: width ?? 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [AppColors.indigo, AppColors.lightPurple],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.white,
                  size: 30,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  55.spaceX,
                  Container(
                    child: Row(
                      children: [
                        Image.asset(
                          imageIcon!,
                          scale: imageIconSize ?? 2,
                        ),
                        if (title != null) 10.spaceX,
                        if (title != null)
                          Text(
                            title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (suffixRow == true)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            AppAssets.stackofcoins,
                            scale: 1.70,
                          ),
                          Text(
                            "25",
                            style: AppTextstyle.interMedium(
                                color: AppColors.white, fontSize: 12),
                          )
                        ],
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
