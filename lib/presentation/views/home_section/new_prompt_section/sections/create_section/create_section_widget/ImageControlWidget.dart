import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../../shared/utilities/photo_permission_helper.dart';
import '../../../prompt_screen_widgets/styles_bottom_sheet.dart';
import '../image_control_widgets/image_preview_widget.dart';
import '../image_control_widgets/image_selection_button.dart';
import '../image_control_widgets/inspiration_button.dart';
import '../image_control_widgets/ratio_selection_card.dart';
import '../image_control_widgets/style_selection_card.dart';

class ImageControlsWidget extends ConsumerWidget {
  final VoidCallback onImageSelected;
  final bool isPremiumUser;

  const ImageControlsWidget({
    super.key,
    required this.onImageSelected,
    this.isPremiumUser = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final provider = ref.watch(generateImageProvider);
    final images = provider.images;
    final selectedRatio = provider.aspectRatio;
    final selectedImageNumber = provider.selectedImageNumber;
    final selectedStyle = provider.selectedStyle;

    final styles = images.isEmpty ? freePikStyles : textToImageStyles;

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
                showPremiumIcon: !isPremiumUser,
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
            side: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.2)
            )
          ),
          color: theme.cardColor,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Number of Images",
                  style: AppTextstyle.interMedium(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
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
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
                side: BorderSide(
                    color: theme.colorScheme.onSurface.withOpacity(0.2)
                )
            ),
            color: theme.cardColor,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Aspect Ratio",
                    style: AppTextstyle.interMedium(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface
                    ),
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
                        controller: ScrollController(),
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => const SizedBox(width: 5),
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
        ),
        24.spaceY,
        Container(
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
                    // Add "View All" card
                    // if (styles.length > 3)
                    //   GestureDetector(
                    //     onTap: () => showStylesBottomSheet(context, ref),
                    //     child: Container(
                    //       width: 120,
                    //       margin: const EdgeInsets.only(right: 8),
                    //       decoration: BoxDecoration(
                    //         color: theme.colorScheme.surfaceVariant,
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(Icons.more_horiz, size: 24, color: theme.colorScheme.onSurface),
                    //           const SizedBox(height: 8),
                    //           Text(
                    //             "View All",
                    //             style: AppTextstyle.interMedium(
                    //               fontSize: 12,
                    //               color: theme.colorScheme.onSurface,
                    //             ),
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

  // In ImageControlsWidget
  Future<void> _handleImagePick(BuildContext context, WidgetRef ref) async {
    try {
      if (!isPremiumUser) {
        await _showPremiumFeatureDialog(context);
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

  Future<void> _showPremiumFeatureDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.workspace_premium, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Premium Feature',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
        content: Text(
          'Image selection is a premium feature. Upgrade to premium to access this functionality.',
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
              Navigator.of(context).pushNamed("choose_plan_screen");
            },
            child: Text(
              'Upgrade',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}