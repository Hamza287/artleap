import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/shared.dart';

import '../../../../../shared/utilities/safe_network_image.dart';

class ResultForPromptWidget extends ConsumerWidget {
  const ResultForPromptWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "Results",
                  style: AppTextstyle.interMedium(
                      fontSize: 16, color: AppColors.white)),
            ])),
            GestureDetector(
              onTap: () {
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return PublicPrivateDialog();
                //   },
                // );
              },
              child: Container(
                child: Row(
                  children: [
                    Text("Public",
                        style: AppTextstyle.interMedium(
                            fontSize: 16, color: AppColors.white)),
                    5.spaceX,
                    Image.asset(
                      AppAssets.questionmark,
                      scale: 2,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        10.spaceY,
        if (ref
            .watch(generateImageProvider)
            .generatedTextToImageData
            .isNotEmpty)
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.darkIndigo),
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 10, left: 10, bottom: 10),
                  child: ref.watch(generateImageProvider).generatedTextToImageData.length == 1
                      ? GestureDetector(
                          onTap: () {
                            Navigation.pushNamed(SeePictureScreen.routeName,
                                arguments: SeePictureParams(
                                  profileName: UserData.ins.userName,
                                  userId: UserData.ins.userId,
                                  imageId: ref
                                      .watch(generateImageProvider)
                                      .generatedTextToImageData[0]!
                                      .id,
                                  modelName: ref
                                      .watch(generateImageProvider)
                                      .selectedStyle,
                                  prompt: ref
                                      .watch(generateImageProvider)
                                      .promptTextController
                                      .text,
                                  image: ref
                                      .watch(generateImageProvider)
                                      .generatedTextToImageData[0]!
                                      .imageUrl,
                                  // isHomeScreenNavigation: false
                                ));
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.darkIndigo),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, right: 10, left: 10, bottom: 10),
                              child: Container(
                                height: 380,
                                margin:
                                    const EdgeInsets.only(left: 0, right: 0),
                                // decoration: BoxDecoration(
                                //     image: DecorationImage(
                                //         image: NetworkImage(ref
                                //             .watch(generateImageProvider)
                                //             .generatedTextToImageData[0]!
                                //             .imageUrl),
                                //         fit: BoxFit.fill),
                                // ),
                                child: SafeNetworkImage(
                                  imageUrl: ref.watch(generateImageProvider).generatedTextToImageData[0]!.imageUrl,
                                  placeholder: (_, __) => Center(child: CircularProgressIndicator()),
                                  errorWidget: (_, __, error) => Icon(Icons.error_outline, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap:
                              true, // Required if GridView is inside a scrollable parent
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio:
                                1, // Square items; adjust as needed
                          ),
                          itemCount: ref
                              .watch(generateImageProvider)
                              .generatedTextToImageData
                              .length,
                          itemBuilder: (context, index) {
                            var e = ref
                                .watch(generateImageProvider)
                                .generatedTextToImageData[index];
                            return GestureDetector(
                              onTap: () {
                                print(UserData.ins.userName);
                                Navigation.pushNamed(SeePictureScreen.routeName,
                                    arguments: SeePictureParams(
                                      profileName: UserData.ins.userName,
                                      // othersUserId: UserData.ins.userId,
                                      // isRecentGeneration: true,
                                      userId: UserData.ins.userId,
                                      imageId: ref
                                          .watch(generateImageProvider)
                                          .generatedTextToImageData[index]!
                                          .id,
                                      modelName: ref
                                          .watch(generateImageProvider)
                                          .selectedStyle,
                                      prompt: ref
                                          .watch(generateImageProvider)
                                          .promptTextController
                                          .text,
                                      image: e.imageUrl,
                                      // isHomeScreenNavigation: false
                                    ));
                              },
                              child: Container(
                                height: 155,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    // image: DecorationImage(
                                    //     image: NetworkImage(e!.imageUrl),
                                    //     fit: BoxFit.fill),
                                ),
                                child: SafeNetworkImage(
                                  imageUrl: e!.imageUrl,
                                  placeholder: (_, __) => Center(child: CircularProgressIndicator()),
                                  errorWidget: (_, __, error) => Icon(Icons.error_outline, color: Colors.red),
                                ),
                              ),
                            );
                          },
                        ))),

        10.spaceY,
        if (ref.watch(generateImageProvider).generatedImage.isNotEmpty &&
            ref.watch(generateImageProvider).generatedImage.length == 1)
          GestureDetector(
            onTap: () {
              // Uint8List bytes = base64Decode(
              //     ref.watch(generateImageProvider).generatedImage[0].);
              print(UserData.ins.userName);
              Navigation.pushNamed(SeePictureScreen.routeName,
                  arguments: SeePictureParams(
                      profileName: UserData.ins.userName,
                      // isRecentGeneration: true,
                      imageId: ref
                          .watch(generateImageProvider)
                          .generatedImage[0]!
                          .id,
                      modelName: ref
                          .watch(generateImageProvider)
                          .generatedImage[0]!
                          .presetStyle,
                      prompt: ref
                          .watch(generateImageProvider)
                          .generatedImage[0]!
                          .prompt,
                      image: ref
                          .watch(generateImageProvider)
                          .generatedImage[0]!
                          .imageUrl
                      // uint8ListImage: bytes,
                      // isHomeScreenNavigation: false
                      ));
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.blue),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, right: 10, left: 10, bottom: 10),
                child: Container(
                  height: 300,
                  margin: const EdgeInsets.only(left: 0, right: 0),
                  // child: CachedNetworkImage(
                  //     imageUrl: ref
                  //         .watch(generateImageProvider)
                  //         .generatedImage[0]!
                  //         .imageUrl),
                  child: SafeNetworkImage(
                    imageUrl: ref.watch(generateImageProvider).generatedImage[0]!.imageUrl,
                    placeholder: (_, __) => Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, error) => Icon(Icons.error_outline, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        10.spaceY,
        if (ref.watch(generateImageProvider).generatedImage.length > 1)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: AppColors.blue),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 10, left: 10, bottom: 10),
              child: GridView.builder(
                shrinkWrap:
                    true, // Required if GridView is inside a scrollable parent
                physics:
                    const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1, // Square items; adjust as needed
                ),
                itemCount:
                    ref.watch(generateImageProvider).generatedImage.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigation.pushNamed(SeePictureScreen.routeName,
                          arguments: SeePictureParams(
                              profileName: UserData.ins.userName,
                              imageId: ref
                                  .watch(generateImageProvider)
                                  .generatedImage[index]!
                                  .id,
                              // isRecentGeneration: true,
                              modelName: ref
                                  .watch(generateImageProvider)
                                  .generatedImage[index]!
                                  .presetStyle,
                              prompt: ref
                                  .watch(generateImageProvider)
                                  .generatedImage[index]!
                                  .prompt,
                              image: ref
                                  .watch(generateImageProvider)
                                  .generatedImage[index]!
                                  .imageUrl
                              // uint8ListImage: bytes,
                              // isHomeScreenNavigation: false
                              ));
                    },
                    child: Container(
                      height: 155,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(ref
                                  .watch(generateImageProvider)
                                  .generatedImage[index]!
                                  .imageUrl),
                              fit: BoxFit.fill)),
                    ),
                  );
                },
              ),
            ),
          ),
        80.spaceY,
      ],
    );
  }
}

Widget displayBase64Image(String base64String) {
  Uint8List bytes = base64Decode(base64String); // Decode base64 string
  return Image.memory(
    bytes,
    fit: BoxFit.fill,
  ); // Display image using Image.memory
}
