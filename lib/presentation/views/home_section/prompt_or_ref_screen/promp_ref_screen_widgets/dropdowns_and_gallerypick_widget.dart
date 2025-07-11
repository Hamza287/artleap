import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../providers/generate_image_provider.dart';
import '../../../../../shared/constants/app_assets.dart';
import '../../../../../shared/constants/app_static_data.dart';

class DropDownsAndGalleryPickWidget extends ConsumerWidget {
  final VoidCallback onpress;

  const DropDownsAndGalleryPickWidget({super.key, required this.onpress});

  Future<void> _handleImagePick(BuildContext context, WidgetRef ref) async {
    try {
      // Check permission status
      var status = await Permission.photos.status;

      if (status.isPermanentlyDenied) {
        bool? shouldOpen = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Gallery access is needed to select reference images. '
                  'Please enable it in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );

        if (shouldOpen == true) {
          await openAppSettings();
        }
        return;
      }

      if (!status.isGranted) {
        status = await Permission.photos.request();
        if (!status.isGranted) {
          if (context.mounted) {
            appSnackBar('Error', 'Gallery access is needed to select reference images. '
                'Please enable it in app settings.', Colors.red);
          }
          return;
        }
      }

      // Only proceed if permission is granted
      if (status.isGranted && context.mounted) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

        if (image != null && context.mounted) {
          onpress(); // Call the original onpress callback
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(generateImageProvider).images;
    // final isImagesNotEmpty = images.isNotEmpty;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // First Dropdown (Number of Images)
            Container(
              height: 40,
              width: 145,
              decoration: BoxDecoration(
                color: AppColors.daisyBrush,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: DropdownButton<int>(
                  isExpanded: true,
                  dropdownColor: AppColors.daisyBrush,
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

            if (ref.watch(generateImageProvider).images.isEmpty)
              Container(
                height: 40,
                width: 175,
                decoration: BoxDecoration(
                  color: AppColors.daisyBrush,
                  borderRadius: BorderRadius.circular(5),
                ),
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
                    items: freePikStyles.map<DropdownMenuItem<String>>(
                            (Map<String, String> styles) {
                          return DropdownMenuItem<String>(
                            value: styles['title'],
                            child: Row(
                              children: [
                                5.spaceX,
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
            if (ref.watch(generateImageProvider).images.isNotEmpty)
              Container(
                height: 40,
                width: 175,
                decoration: BoxDecoration(
                  color: AppColors.daisyBrush,
                  borderRadius: BorderRadius.circular(5),
                ),
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
                    items: textToImageStyles.map<DropdownMenuItem<String>>(
                            (Map<String, String> style) {
                          return DropdownMenuItem<String>(
                            value: style['title'],
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                Container(
                                  height: 37,
                                  width: 37,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(style['icon']!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    style['title']!,
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
              )
          ],
        ),
        10.spaceY,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _handleImagePick(context, ref),
              child: SizedBox(
                height: 40,
                width: 192,
                child: Container(
                    height: 40,
                    width: 187,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.daisyBrush,
                    ),
                    child: images.isEmpty
                        ? Row(
                      children: [
                        Image.asset(
                          AppAssets.galleryicon,
                          scale: 2,
                        ),
                        20.spaceX,
                        Text(
                          'Reference Image',
                          style: AppTextstyle.interRegular(
                            fontSize: 10,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(
                                  images[0],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              if (ref
                                  .watch(generateImageProvider)
                                  .images
                                  .isNotEmpty)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .watch(generateImageProvider)
                                          .selectedStyle = "photo";
                                      ref
                                          .watch(generateImageProvider)
                                          .clearImagesList();
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
                        20.spaceX,
                        Text(
                          'Reference Image',
                          style: AppTextstyle.interRegular(
                            fontSize: 10,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Container(
              height: 40,
              width: 128,
              decoration: BoxDecoration(
                color: AppColors.daisyBrush,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: AppColors.indigo,
                  value: ref.watch(generateImageProvider).aspectRatio,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Select Ratio',
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
                    ref.read(generateImageProvider).aspectRatio = newValue;
                    print(ref.read(generateImageProvider).aspectRatio);
                  },
                  items: freePikAspectRatio.map<DropdownMenuItem<String>>(
                        (Map<String, String> ratio) {
                      return DropdownMenuItem<String>(
                        value: ratio['value'],
                        child: Row(
                          children: [
                            5.spaceX,
                            Container(
                              height: 35,
                              width: 37,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                      ratio['icon']!,
                                    ),
                                    scale: 2
                                  // fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            5.spaceX,
                            SizedBox(
                              width: 40,
                              child: Text(
                                ratio['title']!,
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
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}