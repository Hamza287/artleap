import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/edit_profile_widget.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';

import '../../../../../shared/navigation/screen_params.dart';

class UserInfoAndEditWidget extends ConsumerWidget {
  final EditProfileSreenParams? params;

  const UserInfoAndEditWidget({super.key, this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(top: 70),
      decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          EditProfileWidget(
            params: params,
          )
        ],
      ),
    );
  }
}
