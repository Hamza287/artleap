import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/other_userprofile_widgets/profile_info_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen_widgets/my_creations_widget.dart';
import 'package:photoroomapp/providers/user_profile_provider.dart';
import 'package:photoroomapp/shared/shared.dart';

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
        .getOtherUserProfiledata(widget.params!.userId!);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundWidget(
      widget: ref.watch(userProfileProvider).otherUserProfileData.isEmpty
          ? Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.white,
                size: 35,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  40.spaceY,
                  ProfileInfoWidget(
                    profileName: widget.params!.profileName,
                    userId: widget.params!.userId,
                  ),
                  50.spaceY,
                  MyCreationsWidget(
                    userName: widget.params!.profileName,
                    listofCreations: ref
                        .watch(userProfileProvider)
                        .otherUserProfileData["userData"],
                  )
                ],
              ),
            ),
    );
  }
}
