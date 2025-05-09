import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';

class PictureInfoWidget extends ConsumerWidget {
  final String? styleName;
  const PictureInfoWidget({super.key, this.styleName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 120,
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          10.spaceY,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Container(
              //   height: 30,
              //   width: 30,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       color: AppColors.lightIndigo),
              // ),
              // 10.spaceX,
              Text(
                styleName ?? "Style name",
                style: AppTextstyle.interRegular(
                    fontSize: 14, color: AppColors.white),
              ),
              20.spaceX,
              InfoText(
                title: "Created on",
                info: "21 Aug 2024",
              ),
              // Image.asset(
              //   AppAssets.galleryicon,
              //   scale: 3.5,
              // ),
              // 10.spaceX,
              // Text(
              //   "Image reference",
              //   style: AppTextstyle.interRegular(
              //       fontSize: 14, color: AppColors.white),
              // ),
            ],
          ),
          // 10.spaceY,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     // InfoText(
          //     //   title: "Input Resolution",
          //     //   info: "512 × 984px",
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class InfoText extends ConsumerWidget {
  final String? title;
  final String? info;
  const InfoText({super.key, this.title, this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title!,
          style:
              AppTextstyle.interRegular(fontSize: 16, color: AppColors.white),
        ),
        Text(
          info!,
          style:
              AppTextstyle.interRegular(fontSize: 14, color: AppColors.white),
        )
      ],
    );
  }
}
