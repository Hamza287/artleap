import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../../domain/api_models/models_list_model.dart';
import '../../../../../providers/generate_image_provider.dart';
import '../../../../../shared/constants/app_assets.dart';
import '../../../../../shared/constants/app_static_data.dart';

class DropDownsAndGalleryPickWidget extends ConsumerWidget {
  final VoidCallback onpress;

  const DropDownsAndGalleryPickWidget({super.key, required this.onpress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(generateImageProvider).images;
    // final isImagesNotEmpty = images.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Gallery Icon or Image
        GestureDetector(
          onTap: onpress,
          child: SizedBox(
            height: 35,
            width: 45,
            child: Stack(
              children: [
                Container(
                  height: 35,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.indigo,
                  ),
                  child: images.isEmpty
                      ? Image.asset(
                          AppAssets.galleryicon,
                          scale: 2,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            images[0],
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
                if (ref.watch(generateImageProvider).images.isNotEmpty)
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        ref.watch(generateImageProvider).clearImagesList();
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: AppColors.redColor,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // First Dropdown (Number of Images)
        Container(
          height: 35,
          width: 130,
          color: AppColors.indigo,
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
                    fontSize: 10,
                    color: AppColors.white,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                color: AppColors.white,
              ),
              underline: const SizedBox(),
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
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // 5.spaceX,
        Container(
          height: 35,
          width: 150,
          color: AppColors.indigo,
          child: Center(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: AppColors.indigo,
              value: ref.watch(generateImageProvider).selectedStyle,
              hint: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Select Style',
                  style: AppTextstyle.interRegular(
                    fontSize: 10,
                    color: AppColors.white,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                color: AppColors.white,
              ),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                ref.watch(generateImageProvider).selectedStyle = newValue;
              },
              items: freePikStyles
                  .map<DropdownMenuItem<String>>((Map<String, String> styles) {
                return DropdownMenuItem<String>(
                  value: styles['title'],
                  child: Row(
                    children: [
                      Container(
                        height: 37,
                        width: 37,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(styles['icon']!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      5.spaceX,
                      SizedBox(
                        width: 80,
                        child: Text(
                          styles['title']!,
                          style: AppTextstyle.interMedium(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
