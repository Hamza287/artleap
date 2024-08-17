import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';

class UserProfileMatricsWidget extends ConsumerWidget {
  const UserProfileMatricsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 50,
      width: double.infinity,
      color: AppColors.indigo,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: MatricsTextWidget(
              title: "Creations",
              count: "475",
            ),
          ),
          MatricsTextWidget(
            title: "Followers",
            count: "1.2M",
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: MatricsTextWidget(
              title: "Followings",
              count: "12",
            ),
          )
        ],
      ),
    );
  }
}

class MatricsTextWidget extends ConsumerWidget {
  final String? title;
  final String? count;
  const MatricsTextWidget({super.key, this.title, this.count});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title!,
          style: AppTextstyle.interMedium(
              color: AppColors.lightgrey, fontSize: 14),
        ),
        Text(
          count!,
          style: AppTextstyle.interMedium(color: AppColors.white, fontSize: 15),
        )
      ],
    );
  }
}
