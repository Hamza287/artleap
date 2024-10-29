import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/providers/favrourite_provider.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../shared/constants/app_assets.dart';
import '../../../../../shared/constants/user_data.dart';

// ignore: must_be_immutable
class PictureOptionsWidget extends ConsumerWidget {
  String? imageUrl;
  String? prompt;
  String? modelName;
  String? creatorName;
  Uint8List? uint8ListImage;
  bool? isGeneratedScreenNavigation;
  bool? isRecentGeneration;
  String? currentUserId;
  PictureOptionsWidget(
      {super.key,
      this.imageUrl,
      this.prompt,
      this.modelName,
      this.creatorName,
      this.isGeneratedScreenNavigation,
      this.isRecentGeneration,
      this.uint8ListImage,
      this.currentUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(imageUrl);
    print("dddddddddddddddddddddd");
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
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
                    isLiked: imageUrl != null
                        ? ref
                                .watch(favouriteProvider)
                                .usersFavourites
                                .any((value) => value["imageUrl"] == imageUrl)
                            ? true
                            : false
                        : false,
                    bubblesColor: BubblesColor(
                        dotPrimaryColor: AppColors.indigo,
                        dotSecondaryColor: AppColors.lightIndigo),
                    onTap: (isLiked) {
                      if (isLiked) {
                        return ref
                            .read(favouriteProvider)
                            .removeImageFromFavourite(
                                creatorName!, imageUrl!, prompt!, modelName!);
                      } else {
                        return ref.read(favouriteProvider).addImageToFavourite(
                              creatorName!,
                              prompt!,
                              modelName!,
                              imageUrl: imageUrl!,
                              imagesBytes: uint8ListImage,
                              isRecentGeneration!,
                            );
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
              ref.read(favouriteProvider).downloadImage(imageUrl!);
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.white.withOpacity(0.4))),
              child: ref.watch(favouriteProvider).isDownloading == true
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
          if (currentUserId == UserData.ins.userId)
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.redColor.withOpacity(0.4))),
                child: Column(
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
        ],
      ),
    );
  }
}
