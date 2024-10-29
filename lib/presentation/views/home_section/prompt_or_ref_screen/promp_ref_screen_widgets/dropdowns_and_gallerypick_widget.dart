import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../../domain/api_models/models_list_model.dart';
import '../../../../../providers/generate_image_provider.dart';
import '../../../../../providers/models_list_provider.dart';
import '../../../../../shared/constants/app_assets.dart';
import '../../../../../shared/constants/app_static_data.dart';
import 'prompt_screen_button.dart';

// ignore: must_be_immutable
class DropDownsAndGalleryPickWidget extends ConsumerWidget {
  VoidCallback onpress;
  DropDownsAndGalleryPickWidget({super.key, required this.onpress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelsList = ref.watch(modelsListProvider).dataOfModels;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PromptScreenButton(
          imageIcon: AppAssets.galleryicon,
          height: 35,
          width: 40,
          onpress: onpress,
          isLoading: ref.watch(generateImageProvider).isImageReferenceLoading,
        ),

        // Dropdown for Number of Images
        Container(
          height: 35,
          width: 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: AppColors.indigo),
          child: Center(
            child: DropdownButton<int>(
              isExpanded: true,
              dropdownColor: AppColors.indigo,
              value: ref.watch(generateImageProvider).selectedImageNumber,
              hint: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Number of Images',
                  style: AppTextstyle.interRegular(
                      fontSize: 10, color: AppColors.white),
                ),
              ),
              icon: Icon(
                Icons.arrow_drop_down_sharp,
                color: AppColors.white,
              ),
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (int? newValue) {
                ref.read(generateImageProvider).selectedImageNumber = newValue!;
              },
              items: ref
                  .watch(generateImageProvider)
                  .imageNumber
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      value.toString(),
                      style: AppTextstyle.interMedium(
                          fontSize: 16, color: AppColors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        Container(
          height: 35,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.indigo,
          ),
          child: Center(
            child: Consumer(
              builder: (context, watch, child) {
                return DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: AppColors.indigo,
                  value: ref.watch(generateImageProvider).selectedStyle,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Select Category',
                      style: AppTextstyle.interRegular(
                        fontSize: 10,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down_sharp,
                    color: AppColors.white,
                  ),
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    ref.watch(generateImageProvider).selectedStyle = newValue;
                  },
                  items: freePikStyles.map<DropdownMenuItem<String>>(
                      (Map<String, String> style) {
                    return DropdownMenuItem<String>(
                      value: style['title'],
                      child: Text(
                        style['title']!,
                        style: AppTextstyle.interMedium(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
