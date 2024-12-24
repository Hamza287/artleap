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

  DropDownsAndGalleryPickWidget({Key? key, required this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(generateImageProvider).images;
    final isImagesNotEmpty = images.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Gallery Icon or Image
        GestureDetector(
          onTap: onpress,
          child: Container(
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
                      child: Icon(
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
        AbsorbPointer(
          absorbing: isImagesNotEmpty,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ImageFiltered(
              imageFilter: isImagesNotEmpty
                  ? ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)
                  : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: Container(
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
                    icon: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: AppColors.white,
                    ),
                    underline: SizedBox(),
                    onChanged: (int? newValue) {
                      ref.read(generateImageProvider).selectedImageNumber =
                          newValue!;
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
            ),
          ),
        ),
        // 5.spaceX,
        AbsorbPointer(
          absorbing: isImagesNotEmpty,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ImageFiltered(
              imageFilter: isImagesNotEmpty
                  ? ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    )
                  : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: Container(
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
                    icon: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: AppColors.white,
                    ),
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      ref.watch(generateImageProvider).selectedStyle = newValue;
                    },
                    items: freePikStyles.map<DropdownMenuItem<String>>(
                        (Map<String, String> styles) {
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
                            Container(
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
            ),
          ),
        ),
      ],
    );
  }
}
