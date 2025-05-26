import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';

class PictureInfoWidget extends ConsumerWidget {
  final String? styleName;
  final String? createdAt;
  const PictureInfoWidget({super.key, this.styleName, this.createdAt});

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
              InfoText(
                title: "Art Style",
                info: styleName,
              ),
              20.spaceX,
              InfoText(
                title: "Created on",
                info: createdAt ?? "Unknown",
              ),
            ],
          ),
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
