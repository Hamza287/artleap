import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/utilities/pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:permission_handler/permission_handler.dart';
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
        40.spaceY,
        Text(
          "Number of Images",
          style: AppTextstyle.interMedium(fontSize: 14, color: Colors.black),
        ),
        8.spaceY,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.imageNumber.map((number) {
            return RatioSelectionCard(
              text: number.toString(),
              isSelected: number == selectedImageNumber,
              onTap: () => ref.read(generateImageProvider.notifier).selectedImageNumber = number,
            );
          }).toList(),
        ),
        24.spaceY,
        Text(
          "Aspect Ratio",
          style: AppTextstyle.interMedium(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: freePikAspectRatio.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
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
        ),
        24.spaceY,
        Text(
          "Style",
          style: AppTextstyle.interMedium(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.normal,
                )
              ]
          ),
          child: Center(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: (images.isEmpty ? freePikStyles : textToImageStyles).map((style) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: StyleSelectionCard(
                    title: style['title'] ?? '',
                    icon: style['icon'] ?? '',
                    isSelected: style['title'] == selectedStyle,
                    onTap: () => ref.read(generateImageProvider.notifier).selectedStyle = style['title'],
                  ),
                );
              }).toList(),
            ),
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