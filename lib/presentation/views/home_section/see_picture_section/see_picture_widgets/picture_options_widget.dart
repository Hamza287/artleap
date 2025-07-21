import 'dart:typed_data';
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
        this.imageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.white.withOpacity(0.4))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: LikeButton(
                    isLiked:
                    ref.watch(favouriteProvider).usersFavourites != null
                        ? ref
                        .watch(favouriteProvider)
                        .usersFavourites!
                        .favorites
                        .any((img) => img.id == imageId)
                        ? true
                        : false
                        : false,
                    bubblesColor: const BubblesColor(
                        dotPrimaryColor: AppColors.redColor,
                        dotSecondaryColor: AppColors.redColor),
                    onTap: (isLiked) async {
                      AnalyticsService.instance
                          .logButtonClick(buttonName: 'Generate button event');
                      try {
                        await ref
                            .read(favouriteProvider)
                            .addToFavourite(currentUserId!, imageId!);
                        // Return the opposite of current state since the action toggles the favorite status
                        return !isLiked;
                      } catch (e) {
                        return isLiked; // Return current state if error occurs
                      }
                    },
                  ),
                ),
                2.spaceY,
                Text(
                  "Save",
                  style: AppTextstyle.interRegular(
                      color: AppColors.white, fontSize: 6.5),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              uint8ListImage != null
                  ? ref
                  .read(favProvider)
                  .downloadImage(imageUrl!, uint8ListObject: uint8ListImage)
                  : ref.read(favProvider).downloadImage(imageUrl!);
              AnalyticsService.instance
                  .logButtonClick(buttonName: 'download button event');
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.white.withOpacity(0.4))),
              child: ref.watch(favProvider).isDownloading == true
                  ? Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.white,
                  size: 30,
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.downloadicon,
                    scale: 2.3,
                  ),
                  2.spaceY,
                  Text(
                    "Download",
                    style: AppTextstyle.interRegular(
                        color: AppColors.white, fontSize: 6.5),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Share.shareUri(Uri.parse(imageUrl!));
              AnalyticsService.instance
                  .logButtonClick(buttonName: 'share button event');
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.white.withOpacity(0.4))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.shareicon,
                    scale: 2.3,
                  ),
                  2.spaceY,
                  Text(
                    "Share",
                    style: AppTextstyle.interRegular(
                        color: AppColors.white, fontSize: 6.5),
                  )
                ],
              ),
            ),
          ),
          if (otherUserId == UserData.ins.userId)
            GestureDetector(
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
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                    Border.all(color: AppColors.redColor.withOpacity(0.4))),
                child: ref.watch(imageActionsProvider).isDeleting
                    ? Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    color: AppColors.white,
                    size: 30,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.trashicon,
                      scale: 2.3,
                    ),
                    2.spaceY,
                    Text(
                      "Delete",
                      style: AppTextstyle.interRegular(
                          color: AppColors.white, fontSize: 6.5),
                    )
                  ],
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return ReportImageBottomSheet(
                    imageId: imageId,
                    creatorId: otherUserId,
                  );
                },
              );
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.redColor)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.reporticon,
                    scale: 2.7,
                  ),
                  2.spaceY,
                  Text(
                    "Report",
                    style: AppTextstyle.interRegular(
                        color: AppColors.redColor, fontSize: 6.5),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}