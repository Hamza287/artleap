import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen_widgets/art_style_dialog.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../google_ads/native_add.dart';

class TrendingCreationsWidget extends ConsumerStatefulWidget {
  const TrendingCreationsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrendingCreationsWidgetState();
}

class _TrendingCreationsWidgetState
    extends ConsumerState<TrendingCreationsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      if (ref.watch(homeScreenProvider).page == 0) {
        ref.read(homeScreenProvider).getUserCreations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {  
    final filteredList =
        ref.watch(homeScreenProvider).filteredCreations.isNotEmpty
            ? ref.watch(homeScreenProvider).filteredCreations
            : ref.watch(homeScreenProvider).communityImagesList;

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask( 
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xffAD90FF), Color(0xffEA6BFF), Color(0xffFFA869)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Text(
              'Community Creations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const ArtStyleDilog(),
                );
              },
              child: Image.asset(
                AppAssets.selecticon,
                scale: 2.5,
              ),
            ),
          ),
        ],
      ),
      15.spaceY,
      ref.watch(homeScreenProvider).usersData == null
          ? Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.white,
                size: 30,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: AppColors.darkIndigo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  cacheExtent: 2000.0,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 5,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: [
                      const QuiltedGridTile(2, 2), 
                      const QuiltedGridTile(1, 1),
                      const QuiltedGridTile(1, 1),
                    ],
                  ),
                  itemCount: filteredList.length + 1,
                  itemBuilder: (context, index) {
                    final adIndex = 10;
                    // if (index == adIndex) {
                    //   return const NativeAdWidget();
                    // }
                    final imageIndex = index > adIndex ? index - 1 : index;
                    if (imageIndex >= filteredList.length) {
                      return const SizedBox.shrink();
                    }

                    final image = filteredList[imageIndex];
                    if (image == null) {
                      return const SizedBox.shrink();
                    }
                    return VisibilityDetector(
                      key: Key('image-${image!.id}'),
                      onVisibilityChanged: (info) {
                        if (!mounted) return;
                        const double bufferZone = 300.0;
                        final bool isInBufferZone =
                            info.visibleBounds.top - bufferZone < 0 &&
                                info.visibleBounds.bottom + bufferZone > 0;
                        if (isInBufferZone) {
                          ref
                              .read(homeScreenProvider)
                              .visibilityInfo(info, image.imageUrl);
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigation.pushNamed(
                            SeePictureScreen.routeName,
                            arguments: SeePictureParams(
                              imageId: image.id,
                              userId: image.userId,
                              profileName: image.username,
                              image: image.imageUrl,
                              prompt: image.prompt,
                              modelName: image.modelName,
                              createdDate: image.createdAt,
                              index: index,
                              creatorEmail: image.userEmail,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ref
                                    .watch(homeScreenProvider)
                                    .visibleImages
                                    .contains(image.imageUrl)
                                ? CachedNetworkImage(
                                    imageUrl: image.imageUrl,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,

                                    // memCacheHeight: 400,
                                    // memCacheWidth: 400,
                                    fadeInDuration: Duration.zero,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: AppColors.lightIndigo,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: AppColors.lightIndigo,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      print("❌ Failed to load: $url");
                                      print("🛠 Error: $error");
                                      return Container(
                                        color: Colors.red.withOpacity(0.2),
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: AppColors.darkIndigo,
                                    height: 200,
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    ]);
  }
}
