import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/utilities/pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../prompt_screen_widgets/styles_bottom_sheet.dart';
import '../image_control_widgets/image_preview_widget.dart';
import '../image_control_widgets/image_selection_button.dart';
import '../image_control_widgets/inspiration_button.dart';
import '../image_control_widgets/ratio_selection_card.dart';
import '../image_control_widgets/style_selection_card.dart';

class ImageControlsWidget extends ConsumerWidget {
  final VoidCallback onImageSelected;

  const ImageControlsWidget({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(generateImageProvider);
    final images = provider.images;
    final selectedRatio = provider.aspectRatio;
    final selectedImageNumber = provider.selectedImageNumber;
    final selectedStyle = provider.selectedStyle;

    // Get styles list based on image presence
    final styles = images.isEmpty ? freePikStyles : textToImageStyles;

    // Sort to show selected style first and take first 4
    final displayedStyles = List.from(styles)
      ..sort((a, b) => a['title'] == selectedStyle ? -1 : 1)
      ..take(4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (images.isNotEmpty) ...[
          ImagePreviewWidget(
            imageFile: images.first,
            onRemove: () => ref.read(generateImageProvider.notifier).clearImagesList(),
          ),
          16.spaceY,
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ImageSelectionButton(
                hasImage: images.isNotEmpty,
                onPressed: () => _handleImagePick(context, ref),
              ),
            ),
            10.spaceX,
            const Expanded(
              child: InspirationButton(),
            ),
            7.spaceX,
          ],
        ),
        20.spaceY,
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Number of Images",
                  style: AppTextstyle.interMedium(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: provider.imageNumber.map((number) {
                    return RatioSelectionCard(
                      text: number.toString(),
                      isSelected: number == selectedImageNumber,
                      onTap: () => ref.read(generateImageProvider.notifier).selectedImageNumber = number,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        24.spaceY,
        SizedBox(
          height: 90,
          width: double.infinity,
          child: Stack(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Aspect Ratio",
                        style: AppTextstyle.interMedium(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            return true;
                          },
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: freePikAspectRatio.length,
                            controller: ScrollController(), // Add controller if needed
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => const SizedBox(width: 0),
                            itemBuilder: (context, index) {
                              final ratio = freePikAspectRatio[index];
                              return RatioSelectionCard(
                                text: ratio['title'] ?? '',
                                isSelected: ratio['value'] == selectedRatio,
                                onTap: () => ref.read(generateImageProvider.notifier).aspectRatio = ratio['value'],
                                isSmall: true,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        24.spaceY,
        Container(
          height: 180,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Style",
                    style: AppTextstyle.interMedium(fontSize: 14, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () => showStylesBottomSheet(context, ref),
                    child: Text(
                      "View All",
                      style: AppTextstyle.interMedium(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...displayedStyles.take(3).map((style) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 13),
                        child: StyleSelectionCard(
                          title: style['title'] ?? '',
                          icon: style['icon'] ?? '',
                          isSelected: style['title'] == selectedStyle,
                          onTap: () => ref.read(generateImageProvider.notifier).selectedStyle = style['title'],
                        ),
                      );
                    }),
                    // Add "View All" card
                    // if (styles.length > 3)
                    //   GestureDetector(
                    //     onTap: () => showStylesBottomSheet(context, ref),
                    //     child: Container(
                    //       width: 120,
                    //       margin: const EdgeInsets.only(right: 8),
                    //       decoration: BoxDecoration(
                    //         color: Colors.grey[100],
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           const Icon(Icons.more_horiz, size: 24),
                    //           const SizedBox(height: 8),
                    //           Text(
                    //             "View All",
                    //             style: AppTextstyle.interMedium(fontSize: 12),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleImagePick(BuildContext context, WidgetRef ref) async {
    try {
      final status = await Permission.photos.request();

      if (status.isGranted) {
        final imagePath = await Pickers.ins.pickImage();
        if (imagePath != null) {
          ref.read(generateImageProvider.notifier).pickImage();
          onImageSelected();
        }
      } else if (status.isPermanentlyDenied && context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text('Please enable photos access in settings'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}