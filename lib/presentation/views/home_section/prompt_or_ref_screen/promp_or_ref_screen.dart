import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/dropdowns_and_gallerypick_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/promp_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/prompt_screen_button.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/result_for_prompt_widget.dart';
import 'package:photoroomapp/providers/freepik_ai_gen_provider.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';
import 'package:photoroomapp/providers/img_to_img_provider.dart';
import 'package:photoroomapp/shared/app_snack_bar.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../shared/app_persistance/app_local.dart';
import '../../../../shared/constants/app_assets.dart';
import '../../../../shared/constants/app_local_keys.dart';

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref
    //       .read(generateImageProvider)
    //       .getUserId(); // Call your method here safely
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundWidget(
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
                  if (ref
                      .watch(generateImageProvider)
                      .promptTextController
                      .text
                      .isEmpty) {
                    appSnackBar("Alert", "Please write your prompt",
                        AppColors.redColor);
                  } else {
                    ref.read(generateImageProvider).pickImage();
                  }
                },
              ),
              20.spaceY,
              PromptScreenButton(
                height: 45,
                width: double.infinity,
                imageIcon: AppAssets.generateicon,
                title: "Generate Image",
                onpress: () {
                  // ref.read(freePikProvider).generateImage();
                  if (ref.watch(generateImageProvider).selectedImageNumber ==
                      null) {
                    appSnackBar("Error", "Please select number of images",
                        AppColors.redColor);
                  } else if (ref
                      .watch(generateImageProvider)
                      .promptTextController
                      .text
                      .isEmpty) {
                    appSnackBar("Error", "Please write your prompt",
                        AppColors.redColor);
                  } else {
                    ref.read(generateImageProvider).generateFreePikImage();
                  }
                },
                isLoading:
                    ref.watch(generateImageProvider).isGenerateImageLoading,
              ),
              20.spaceY,
              const ResultForPromptWidget()
            ],
          ),
        ),
      ),
    );
  }
}
