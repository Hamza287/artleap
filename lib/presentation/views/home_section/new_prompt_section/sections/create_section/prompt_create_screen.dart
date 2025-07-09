import 'package:Artleap.ai/presentation/firebase_analyitcs_singleton/firebase_analtics_singleton.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_background_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/new_prompt_section/result/result_prompt_screen.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/providers/refresh_provider.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../prompt_or_ref_screen/promp_ref_screen_widgets/prompt_screen_button.dart';
import 'create_section_widget/ImageControlWidget.dart';
import 'create_section_widget/prompt_widget.dart';

class PromptCreateScreen extends ConsumerStatefulWidget {
  const PromptCreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PromptOrReferenceScreenState();
}

class _PromptOrReferenceScreenState extends ConsumerState<PromptCreateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.instance.logScreenView(screenName: 'generating screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).userProfileData;
    final generateImageProviderState = ref.watch(generateImageProvider);
    final shouldRefresh = ref.watch(refreshProvider);

    if (shouldRefresh && UserData.ins.userId != null) {
      Future.microtask(() {
        ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId!);
      });
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          ref.watch(bottomNavBarProvider).setPageIndex(0);
        }
      },
      child: AppBackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(left: 15, right: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.spaceY,
                const PromptWidget(),
                40.spaceY,
                ImageControlsWidget(
                  onImageSelected: () {
                    ref.read(generateImageProvider).pickImage();
                    AnalyticsService.instance.logButtonClick(
                        buttonName: 'picking image from gallery button event');
                  },
                ),
                40.spaceY,
                PromptScreenButton(
                  height: 55,
                  width: double.infinity,
                  imageIcon: AppAssets.generateicon,
                  title: "Generate",
                  suffixRow: true,
                  onpress: (userProfile == null || userProfile.user.dailyCredits == 0) ? () {
                    appSnackBar("Oops!", "You have reached your daily limit. Thank you!", AppColors.indigo);}
                      : generateImageProviderState.containsSexualWords ? () {
                              appSnackBar("Warning!","Your prompt contains sexual words.", AppColors.redColor);}
                          : () {if (generateImageProviderState.selectedImageNumber == null && generateImageProviderState.images.isEmpty) {
                                appSnackBar("Error", "Please select number of images", AppColors.redColor);
                              } else if (generateImageProviderState.promptTextController.text.isEmpty) {
                                appSnackBar("Error", "Please write your prompt", AppColors.redColor);
                              } else if (generateImageProviderState.images.isNotEmpty) {
                                ref.watch(generateImageProvider).generateImgToImg();
                              } else {
                                AnalyticsService.instance.logButtonClick(buttonName: 'Generate button event');
                                ref.read(generateImageProvider).generateTextToImage();
                                Navigation.pushNamed(ResultScreenRedesign.routeName);
                              }
                            },
                  isLoading: generateImageProviderState.isGenerateImageLoading,
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
