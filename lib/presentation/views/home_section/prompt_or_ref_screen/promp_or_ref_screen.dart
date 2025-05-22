import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/google_ads/banner_ad.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/dropdowns_and_gallerypick_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/promp_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/prompt_screen_button.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/result_for_prompt_widget.dart';
import 'package:photoroomapp/providers/user_profile_provider.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';
import 'package:photoroomapp/shared/app_snack_bar.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import '../../../../providers/bottom_nav_bar_provider.dart';
import '../../../../shared/constants/app_assets.dart';
import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';
import '../../../google_ads/interstetial_ad.dart';

class PromptOrReferenceScreen extends ConsumerStatefulWidget {
  const PromptOrReferenceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PromptOrReferenceScreenState();
}

class _PromptOrReferenceScreenState
    extends ConsumerState<PromptOrReferenceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.instance.logScreenView(screenName: 'generating screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          ref.watch(bottomNavBarProvider).setPageIndex(0);
        }
      },
      child: AppBackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.spaceY,
                const PromptWidget(),
                10.spaceY,
                DropDownsAndGalleryPickWidget(
                  onpress: () {
                    ref.read(generateImageProvider).pickImage();
                    AnalyticsService.instance.logButtonClick(
                        buttonName: 'picking image from gallery button event');
                  },
                ),
                20.spaceY,
                PromptScreenButton(
                  height: 45,
                  width: double.infinity,
                  imageIcon: AppAssets.generateicon,
                  title: "Generate",
                  suffixRow: true,
                  onpress: ref
                              .watch(userProfileProvider)
                              .userProfileData!
                              .user
                              .dailyCredits ==
                          0
                      ? () {
                          appSnackBar(
                              "Oops!",
                              "You have reached your daily limit. Thank you!",
                              AppColors.indigo);
                        }
                      : ref.read(generateImageProvider).containsSexualWords
                          ? () {
                              appSnackBar(
                                  "Warning!",
                                  "Your prompt contains sexual words.",
                                  AppColors.redColor);
                            }
                          : () {
                              if (ref
                                          .watch(generateImageProvider)
                                          .selectedImageNumber ==
                                      null &&
                                  ref
                                      .watch(generateImageProvider)
                                      .images
                                      .isEmpty) {
                                appSnackBar(
                                    "Error",
                                    "Please select number of images",
                                    AppColors.redColor);
                              } else if (ref
                                  .watch(generateImageProvider)
                                  .promptTextController
                                  .text
                                  .isEmpty) {
                                appSnackBar("Error", "Please write your prompt",
                                    AppColors.redColor);
                              } else if (ref
                                  .watch(generateImageProvider)
                                  .images
                                  .isNotEmpty) {
                                ref
                                    .watch(generateImageProvider)
                                    .generateImgToImg();
                              } else {
                                // InterstitialAdManager.instance
                                //     .showInterstitialAd();
                                AnalyticsService.instance.logButtonClick(
                                    buttonName: 'Generate button event');

                                ref
                                    .read(generateImageProvider)
                                    .generateTextToImage();
                              }
                            },
                  isLoading:
                      ref.watch(generateImageProvider).isGenerateImageLoading,
                ),
                20.spaceY,
                const ResultForPromptWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
