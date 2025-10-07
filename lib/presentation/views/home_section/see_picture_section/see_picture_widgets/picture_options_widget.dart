import 'dart:typed_data';
import 'package:Artleap.ai/providers/image_privacy_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/dialog_box/delete_alert_dialog.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_pic_bottom_sheets/report_pic_bottom_sheet.dart';
import 'package:Artleap.ai/providers/favrourite_provider.dart';
import 'package:Artleap.ai/providers/image_actions_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../providers/add_image_to_fav_provider.dart';
import '../../../../../shared/constants/app_assets.dart';
import '../../../../../shared/constants/user_data.dart';
import '../../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';
import '../../../global_widgets/dialog_box/set_privacy_dialog.dart';

// ignore: must_be_immutable
class PictureOptionsWidget extends ConsumerWidget {
  String? imageUrl;
  String? prompt;
  String? modelName;
  String? creatorName;
  String? creatorEmail;
  Uint8List? uint8ListImage;
  bool? isGeneratedScreenNavigation;
  bool? isRecentGeneration;
  String? currentUserId;
  String? otherUserId;
  int? index;
  String? imageId;
  String privacy;
  PictureOptionsWidget(
      {super.key,
      this.imageUrl,
      this.prompt,
      this.modelName,
      this.creatorName,
      this.creatorEmail,
      this.isGeneratedScreenNavigation,
      this.isRecentGeneration,
      this.uint8ListImage,
      this.currentUserId,
      this.otherUserId,
      this.index,
      this.imageId,
      required this.privacy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentUser = otherUserId == UserData.ins.userId;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            "Image Actions",
            style: AppTextstyle.interMedium(
              color: AppColors.darkBlue,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final buttonWidth = 72.0;
              final availableWidth = constraints.maxWidth;
              final buttonsPerRow = (availableWidth / buttonWidth).floor();
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 16,
                children: [
                  _buildActionButton(
                    icon: Icons.favorite_rounded,
                    label: "Favorite",
                    color: Colors.red,
                    isLiked:
                        ref.watch(favouriteProvider).usersFavourites != null
                            ? ref
                                .watch(favouriteProvider)
                                .usersFavourites!
                                .favorites
                                .any((img) => img.id == imageId)
                            : false,
                    onTap: () async {
                      AnalyticsService.instance
                          .logButtonClick(buttonName: 'Favorite button event');
                      try {
                        await ref
                            .read(favouriteProvider)
                            .addToFavourite(currentUserId!, imageId!);
                      } catch (e) {}
                    },
                    isLikeButton: true,
                  ),
                  _buildActionButton(
                    icon: Icons.download_rounded,
                    label: "Download",
                    color: Colors.green,
                    isLoading: ref.watch(favProvider).isDownloading == true,
                    onTap: () {
                      uint8ListImage != null
                          ? ref.read(favProvider).downloadImage(imageUrl!,
                              uint8ListObject: uint8ListImage)
                          : ref.read(favProvider).downloadImage(imageUrl!);
                      AnalyticsService.instance
                          .logButtonClick(buttonName: 'download button event');
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.share_rounded,
                    label: "Share",
                    color: Colors.blue,
                    onTap: () async {
                      await Share.shareUri(Uri.parse(imageUrl!));
                      AnalyticsService.instance
                          .logButtonClick(buttonName: 'share button event');
                    },
                  ),
                  if (isCurrentUser)
                    _buildActionButton(
                      icon: Icons.lock_rounded,
                      label: "Privacy",
                      color: Colors.purple,
                      onTap: () async {
                        await showDialog<ImagePrivacy>(
                          context: context,
                          builder: (context) => SetPrivacyDialog(
                            imageId: imageId!,
                            userId: currentUserId!,
                            initialPrivacyString: privacy,
                          ),
                        );
                      },
                    ),
                  if (isCurrentUser)
                    _buildActionButton(
                      icon: Icons.delete_rounded,
                      label: "Delete",
                      color: Colors.red,
                      isLoading: ref.watch(imageActionsProvider).isDeleting,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteAlertDialog(
                              imageId: imageId,
                            );
                          },
                        );
                        AnalyticsService.instance
                            .logButtonClick(buttonName: 'delete button event');
                      },
                    ),
                  _buildActionButton(
                    icon: Icons.flag_rounded,
                    label: "Report",
                    color: Colors.orange,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return ReportImageBottomSheet(
                            imageId: imageId,
                            creatorId: otherUserId,
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    bool isLoading = false,
    bool isLiked = false,
    bool isLikeButton = false,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: label,
      child: Container(
        width: 60,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: isLoading
                      ? Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: color,
                            size: 24,
                          ),
                        )
                      : isLikeButton
                          ? Center(
                              child: LikeButton(
                                size: 28,
                                isLiked: isLiked,
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    isLiked
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isLiked
                                        ? color
                                        : color.withOpacity(0.6),
                                    size: 28,
                                  );
                                },
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: color,
                                  dotSecondaryColor: color,
                                ),
                                onTap: (isLiked) async {
                                  onTap();
                                  return !isLiked;
                                },
                              ),
                            )
                          : Center(
                              child: Icon(
                                icon,
                                color: color,
                                size: 28,
                              ),
                            ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextstyle.interMedium(
                color: AppColors.darkBlue,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
