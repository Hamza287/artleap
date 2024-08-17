import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/profile_pic_info_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/user_profile_metrics_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackgroundWidget(
        widget: Column(
      children: [
        ProfileBackgroundWidget(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePicAndInfoWidget(),
            ],
          ),
        ),
        UserProfileMatricsWidget()
      ],
    ));
  }
}
