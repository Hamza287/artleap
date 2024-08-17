import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_static_data.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

class ArtStyleWidget extends ConsumerWidget {
  const ArtStyleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Art Style",
              style: AppTextstyle.interBold(
                  fontSize: 15, color: AppColors.lightgrey),
            ),
            Text(
              "See All",
              style: AppTextstyle.interRegular(
                  fontSize: 13, color: AppColors.lightgrey),
            ),
            // 15.spaceY,
          ],
        ),
        10.spaceY,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...artsStyleImagesLIst.map(
                (e) {
                  return Container(
                    height: 65,
                    width: 62,
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.lightIndigo),
                    child: e["image"] == ""
                        ? Column(
                            children: [
                              Text("No Style"),
                            ],
                          )
                        : Image.asset(
                            e["image"],
                            fit: BoxFit.cover,
                          ),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
