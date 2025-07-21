import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/full_image_viewer_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_widgets/picture_info_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_widgets/picture_options_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_widgets/profile_name_follow_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_widgets/prompt_text_widget.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';

class SeePictureScreen extends ConsumerStatefulWidget {
  static const routeName = "see_picture_screen";
  final SeePictureParams? params;
  const SeePictureScreen({super.key, this.params});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeePictureScreenState();
}

class _SeePictureScreenState extends ConsumerState<SeePictureScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AnalyticsService.instance.logScreenView(screenName: 'see image screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [AppColors.lightIndigo, AppColors.darkIndigo])),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(top: 70),
          decoration: const BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                20.spaceY,
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("In A mystical field",
                          style: AppTextstyle.interMedium(
                              fontSize: 16, color: AppColors.white)),
                      GestureDetector(
                        onTap: () {
                          Navigation.pop();
                        },
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            AppAssets.cross,
                            scale: 1.50,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                20.spaceY,
                if (widget.params!.userId != UserData.ins.userId)
                  ProfileNameFollowWidget(
                    profileName: widget.params!.profileName,
                    userId: widget.params!.userId,
                  ),
                20.spaceY,
                GestureDetector(
                  onTap: () {
                    Navigation.pushNamed(FullImageViewerScreen.routeName,
                        arguments: FullImageScreenParams(
                          Image: widget.params!.image!,
                        ));
                  },
                  child: Container(
                    height: 350,
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: widget.params!.image!,
                        fit: BoxFit.fill,
                        fadeInDuration: Duration.zero,
                      ),
                    ),
                  ),
                ),
                20.spaceY,
                PictureOptionsWidget(
                  imageId: widget.params!.imageId,
                  creatorName: widget.params!.profileName,
                  imageUrl: widget.params!.image ?? "",
                  prompt: widget.params!.prompt,
                  modelName: widget.params!.modelName,
                  uint8ListImage: widget.params!.uint8ListImage,
                  currentUserId: UserData.ins.userId,
                  index: widget.params!.index,
                  creatorEmail: widget.params!.creatorEmail,
                  otherUserId: widget.params!.userId,
                ),
                20.spaceY,
                PromptTextWidget(
                  prompt: widget.params!.prompt,
                ),
                20.spaceY,
                PictureInfoWidget(
                  styleName: widget.params!.modelName,
                ),
                20.spaceY,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
