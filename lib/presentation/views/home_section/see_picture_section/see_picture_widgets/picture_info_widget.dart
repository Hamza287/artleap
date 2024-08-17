import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/shared.dart';

class PictureInfoWidget extends ConsumerWidget {
  const PictureInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: AppColors.lightIndigo),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InfoText(
            title: "Present",
            info: "Dynamic",
          ),
          InfoText(
            title: "Resolution",
            info: "512 × 984px",
          ),
          InfoText(
            title: "Pipeline",
            info: "Alchemy",
          )
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
          style: AppTextstyle.interRegular(
              fontSize: 11, color: AppColors.lightgrey),
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
