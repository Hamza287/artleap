import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class UserProfileMatricsWidget extends ConsumerWidget {
  final int followersCount;
  final int followingCount;
  final int creationsCount;

  const UserProfileMatricsWidget({
    super.key,
    required this.followersCount,
    required this.followingCount,
    required this.creationsCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        theme.colorScheme.primary,
        theme.colorScheme.primaryContainer
      ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: MatricsTextWidget(
              title: "Creations",
              count: ref
                  .watch(userProfileProvider)
                  .userProfileData!
                  .user
                  .images
                  .length
                  .toString(),
            ),
          ),
          MatricsTextWidget(
            title: "Followers",
            count: ref
                .watch(userProfileProvider)
                .userProfileData!
                .user
                .followers
                .length
                .toString(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: MatricsTextWidget(
              title: "Followings",
              count: ref
                  .watch(userProfileProvider)
                  .userProfileData!
                  .user
                  .following
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
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title!,
          style: AppTextstyle.interMedium(
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
              fontSize: 14),
        ),
        Text(
          count!,
          style: AppTextstyle.interMedium(
              color: theme.colorScheme.onPrimary, fontSize: 15),
        )
      ],
    );
  }
}
