import 'package:Artleap.ai/presentation/views/common/dialog_box/upgrade_info_dialog.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/utilities/photo_permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:permission_handler/permission_handler.dart';
import 'styles_bottom_sheet.dart';
import 'style_selection_card.dart';
import 'image_preview_redesign.dart';
import 'image_selection_button_redesign.dart';
import 'inspiration_button_redesign.dart';
import 'ratio_selection_redesign.dart';

class ImageControlsRedesign extends ConsumerWidget {
  final VoidCallback onImageSelected;
  final bool isPremiumUser;

  const ImageControlsRedesign({
    super.key,
    required this.onImageSelected,
    this.isPremiumUser = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final provider = ref.watch(generateImageProvider);
    final images = provider.images;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (images.isNotEmpty) ...[
          ImagePreviewRedesign(
            imageFile: images.first,
            onRemove: () => ref.read(generateImageProvider.notifier).clearImagesList(),
          ),
          20.spaceY,
        ],
        _buildControlsGrid(context, ref, theme),
        24.spaceY,
        _buildStyleSelection(context, ref, theme),
      ],
    );
  }

  Widget _buildControlsGrid(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ImageSelectionButtonRedesign(
                  hasImage: ref.watch(generateImageProvider).images.isNotEmpty,
                  onPressed: () => _handleImagePick(context, ref),
                  showPremiumIcon: !isPremiumUser,
                ),
              ),
              12.spaceX,
              const Expanded(
                child: InspirationButtonRedesign(),
              ),
            ],
          ),
          20.spaceY,
          _buildNumberSelection(ref, theme),
          20.spaceY,
          _buildAspectRatioSelection(ref, theme),
        ],
      ),
    );
  }

  Widget _buildNumberSelection(WidgetRef ref, ThemeData theme) {
    final provider = ref.watch(generateImageProvider);
    final selectedImageNumber = provider.selectedImageNumber;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Number of Images",
          style: AppTextstyle.interMedium(
            fontSize: 13,
            color: theme.colorScheme.onSurface,
          ),
        ),
        12.spaceY,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: provider.imageNumber.map((number) {
            return RatioSelectionRedesign(
              text: number.toString(),
              isSelected: number == selectedImageNumber,
              onTap: () => ref.read(generateImageProvider.notifier).selectedImageNumber = number,
              credits: ref.watch(generateImageProvider).images.isEmpty ? number * 2 : number * 24,
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget _buildAspectRatioSelection(WidgetRef ref, ThemeData theme) {
    final selectedRatio = ref.watch(generateImageProvider).aspectRatio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Aspect Ratio",
          style: AppTextstyle.interMedium(
            fontSize: 13,
            color: theme.colorScheme.onSurface,
          ),
        ),
        12.spaceY,
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: freePikAspectRatio.length,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => 8.spaceX,
            itemBuilder: (context, index) {
              final ratio = freePikAspectRatio[index];
              return RatioSelectionRedesign(
                text: ratio['title'] ?? '',
                isSelected: ratio['value'] == selectedRatio,
                onTap: () => ref.read(generateImageProvider.notifier).aspectRatio = ratio['value'],
                isAspectRatio: true,
                aspectRatio: ratio['value'],
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _buildStyleSelection(BuildContext context, WidgetRef ref, ThemeData theme) {
    final provider = ref.watch(generateImageProvider);
    final images = provider.images;
    final selectedStyle = provider.selectedStyle;

    final styles = images.isEmpty ? freePikStyles : textToImageStyles;
    final displayedStyles = List.from(styles).take(4);

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.3),
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
                style: AppTextstyle.interMedium(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface
                ),
              ),
              TextButton(
                onPressed: () => showStylesBottomSheet(context, ref),
                child: Text(
                  "View All",
                  style: AppTextstyle.interMedium(
                    fontSize: 14,
                    color: theme.colorScheme.primary,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImagePick(BuildContext context, WidgetRef ref) async {
    try {
      if (!isPremiumUser) {
        PremiumUpgradeDialog.show(
          context: context,
          featureName: "Reference Image",
          customDescription: "Add Reference Image to Make it with Ai",
        );
        return;
      }

      final ok = await PhotoPermissionHelper.ensurePhotosPermission();

      if (!ok) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Permission Required',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Text(
              'Please enable photos access in settings',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: Text(
                  'Open Settings',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        );
        return;
      }

      final status = await Permission.photos.status;
      if (!status.isGranted && !status.isLimited) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photos permission is required to select images')),
          );
        }
        return;
      }

      await ref.read(generateImageProvider.notifier).pickImage();
      onImageSelected();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}