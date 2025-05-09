import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_background_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/other_userprofile_widgets/profile_info_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/profile_screen_widgets/my_creations_widget.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';

import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';

// ignore: must_be_immutable
class OtherUserProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = 'other_profile_screen';
  OtherUserProfileParams? params;

  OtherUserProfileScreen({super.key, this.params});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState
    extends ConsumerState<OtherUserProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref
        .read(userProfileProvider)
        .getOtherUserProfileData(widget.params!.userId!);
    AnalyticsService.instance
        .logScreenView(screenName: 'others profile screen');
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundWidget(
      widget: ref.watch(userProfileProvider).otherUserProfileData == null
          ? Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.white,
                size: 35,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  25.spaceY,
                  Row(
                    children: [
                      20.spaceX,
                      const Icon(Icons.arrow_back_ios_new_outlined,
                          color: AppColors.white, size: 20),
                    ],
                  ),
                  20.spaceY,
                  ProfileInfoWidget(
                    profileName: widget.params!.profileName,
                    userId: widget.params!.userId,
                  ),
                  50.spaceY,
                  MyCreationsWidget(
                    userName: widget.params!.profileName,
                    listofCreations: ref
                        .watch(userProfileProvider)
                        .otherUserProfileData!
                        .user
                        .images,
                  )
                ],
              ),
            ),
    );
  }
}
