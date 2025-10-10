import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';
import 'other_userprofile_widgets/profile_info_widget.dart';
import 'profile_screen_widgets/my_creations_widget.dart';

class OtherUserProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = 'other_profile_screen';
  final OtherUserProfileParams? params;

  const OtherUserProfileScreen({super.key, this.params});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends ConsumerState<OtherUserProfileScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(userProfileProvider).getOtherUserProfileData(widget.params!.userId!);
    AnalyticsService.instance.logScreenView(screenName: 'others profile screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: ref.watch(userProfileProvider).otherUserProfileData == null
          ? Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: theme.colorScheme.primary,
          size: 35,
        ),
      )
          : Column(
        children: [
          _buildAppBar(theme),
          20.spaceY,
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ProfileInfoWidget(
                    profileName: widget.params!.profileName,
                    userId: widget.params!.userId,
                  ),
                  24.spaceY,
                  MyCreationsWidget(
                    userName: widget.params!.profileName,
                    listofCreations: ref.watch(userProfileProvider).otherUserProfileData!.user.images,
                    userId: '9y37',
                  ),
                  20.spaceY,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAppBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.primary, size: 18),
            ),
          ),
          12.spaceX,
          Text(
            "Artist Profile",
            style: AppTextstyle.interMedium(
              color: theme.colorScheme.onBackground,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}