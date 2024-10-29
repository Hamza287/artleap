import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/providers/user_profile_provider.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';

class UserProfileMatricsWidget extends ConsumerWidget {
  final int followersCount;
  final int followingCount;
  final int creationsCount;

  const UserProfileMatricsWidget({
    Key? key,
    required this.followersCount,
    required this.followingCount,
    required this.creationsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.lightIndigo, AppColors.darkIndigo])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: MatricsTextWidget(
              title: "Creations",
              count: ref
                  .watch(userProfileProvider)
                  .usersCreations
                  .length
                  .toString(),
            ),
          ),
          MatricsTextWidget(
            title: "Followers",
            count: ref
                .watch(userProfileProvider)
                .userFollowerData
                .length
                .toString(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: MatricsTextWidget(
              title: "Followings",
              count: ref
                  .watch(userProfileProvider)
                  .userFollowingData
                  .length
                  .toString(),
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
