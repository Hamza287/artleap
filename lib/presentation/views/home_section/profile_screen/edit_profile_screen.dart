import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/user_info_and_edit_widget.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/navigation/screen_params.dart';

class EditProfileScreen extends ConsumerWidget {
  static const String routeName = "edit_profile_screen";
  final EditProfileSreenParams? params;
  const EditProfileScreen({super.key, this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0x990A0025),
        ),
        child: UserInfoAndEditWidget(
          params: params,
        ),
      ),
    );
  }
}
