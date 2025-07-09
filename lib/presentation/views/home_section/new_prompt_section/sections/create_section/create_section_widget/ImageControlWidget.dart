import 'dart:io';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageControlsWidget extends ConsumerWidget {
  final VoidCallback onImageSelected;

  const ImageControlsWidget({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(generateImageProvider).images;
    final selectedRatio = ref.watch(generateImageProvider).aspectRatio;
    final selectedImageNumber =
        ref.watch(generateImageProvider).selectedImageNumber;
    final selectedStyle = ref.watch(generateImageProvider).selectedStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildImageSelectionButton(context, ref, images),
            ),
            12.spaceX,
            Expanded(
              child: _buildInspirationButton(context),
            ),
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
          children: ref.watch(generateImageProvider).imageNumber.map((number) {
            return _buildSelectionCard(
              context,
              number.toString(),
              isSelected: number == selectedImageNumber,
              onTap: () =>
              ref.read(generateImageProvider).selectedImageNumber = number,
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
                  return _buildRatioOption(
                    ratio['title'] ?? '',
                    isSelected: ratio['value'] == selectedRatio,
                    onTap: () => ref.read(generateImageProvider).aspectRatio = ratio['value'],
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
                  blurStyle: BlurStyle.normal, // Ensures shadow only appears at bottom
                )
            ]
          ),
          child: Center(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: (images.isEmpty ? freePikStyles : textToImageStyles).map((style) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _buildEnhancedStyleCard(
                    style['title'] ?? '',
                    style['icon'] ?? '',
                    isSelected: style['title'] == selectedStyle,
                    onTap: () => ref.read(generateImageProvider).selectedStyle = style['title'],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSelectionButton(
      BuildContext context, WidgetRef ref, List<File> images) {
    return ElevatedButton(
      onPressed: () => _handleImagePick(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            images.isEmpty ? Icons.add_photo_alternate : Icons.image,
            color: AppColors.purple,
          ),
          const SizedBox(width: 8),
          Text(
            images.isEmpty ? "Add Reference" : "Change Image",
            style: AppTextstyle.interMedium(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInspirationButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle inspiration button press
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.purple),
          const SizedBox(width: 8),
          Text(
            "Inspiration",
            style: AppTextstyle.interMedium(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard(
      BuildContext context,
      String text, {
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 60,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xD8923CFF) : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Center(
            child: Text(
              text,
              style: AppTextstyle.interMedium(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatioOption(
      String title, {
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 73,
        decoration: BoxDecoration(
          color: isSelected ? Color(0x98923CFF) : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Center(
          child: Text(
            title,
            style: AppTextstyle.interMedium(
              fontSize: 12,
              color: isSelected ? Colors.white: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStyleCard(
      String title,
      String icon, {
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.purple.withValues(),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Container with refined shadow
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.white : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.purple : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Image.asset(
                icon,
                width: 60,
                height: 60,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          // Title Text
          SizedBox(
            width: 100,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextstyle.interMedium(
                fontSize: 14,
                color: isSelected ? AppColors.purple : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _handleImagePick(BuildContext context, WidgetRef ref) async {
    try {
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

        if (shouldOpen == true) await openAppSettings();
        return;
      }

      if (!status.isGranted) {
        status = await Permission.photos.request();
        if (!status.isGranted) {
          if (context.mounted) {
            appSnackBar(
                'Error',
                'Gallery access is needed to select reference images. '
                    'Please enable it in app settings.',
                Colors.red);
          }
          return;
        }
      }

      if (status.isGranted && context.mounted) {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);
        if (image != null && context.mounted) {
          onImageSelected();
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
}