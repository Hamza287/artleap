import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/promp_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/prompt_screen_button.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_ref_screen_widgets/result_for_prompt_widget.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';
import 'package:photoroomapp/providers/img_to_img_provider.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../shared/constants/app_assets.dart';

class PrompOrReferenceScreen extends ConsumerWidget {
  const PrompOrReferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PromptScreenButton(
                    imageIcon: AppAssets.cameraicon,
                    title: "Image Reference",
                    onpress: () {
                      ref.read(generateImageProvider).pickImage();
                    },
                  ),
                  PromptScreenButton(
                    imageIcon: AppAssets.generateicon,
                    title: "Generate Image",
                    onpress: () {
                      ref.read(generateImageProvider).generateImage();
                    },
                  ),
                ],
              ),
              20.spaceY,
              ResultForPromptWidget()
            ],
          ),
        ),
      ),
    );
  }
}
