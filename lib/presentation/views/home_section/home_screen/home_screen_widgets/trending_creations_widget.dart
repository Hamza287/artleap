import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen_widgets/art_style_dialog.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:photoroomapp/providers/home_screen_provider.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../../shared/constants/app_textstyle.dart';

class TrendingCreationsWidget extends ConsumerStatefulWidget {
  const TrendingCreationsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrendingCreationsWidgetState();
}

class _TrendingCreationsWidgetState
    extends ConsumerState<TrendingCreationsWidget> {
  late Future<DocumentSnapshot<Map<String, dynamic>>?> userCreationsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the Future to be fetched only once
    userCreationsFuture = ref.read(homeScreenProvider).getUserCreations();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xffAD90FF),
                  Color(0xffEA6BFF),
                  Color(0xffFFA869)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'Community Creations',
                style: TextStyle(
                  color: Colors
                      .white, // This color must be here but it's not visible
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
                  scale: 2.50,
                ),
              ),
            )
          ],
        ),
        15.spaceY,
        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
          future: userCreationsFuture, // Use the cached Future here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.white,
                  size: 30,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data?.data() == null) {
              return Center(
                child: Text(
                  "No data yet",
                  style: AppTextstyle.interBold(
                    fontSize: 15,
                    color: AppColors.white,
                  ),
                ),
              );
            } else {
              Map<String, dynamic> data = snapshot.data!.data()!;
              List<dynamic> usersCreations = data['userData'] ?? [];
              if (usersCreations.isEmpty) {
                return Center(
                  child: Text(
                    "No creations available",
                    style: AppTextstyle.interBold(
                      fontSize: 15,
                      color: AppColors.white,
                    ),
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.darkIndigo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    right: 10,
                    left: 10,
                    bottom: 20,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    cacheExtent: 2000.0,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                      pattern: [
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                      ],
                    ),
                    itemCount: ref
                            .watch(homeScreenProvider)
                            .filteredCreations
                            .isNotEmpty
                        ? ref.watch(homeScreenProvider).filteredCreations.length
                        : usersCreations.length,
                    itemBuilder: (context, index) {
                      int reverseIndex = ref
                              .watch(homeScreenProvider)
                              .filteredCreations
                              .isNotEmpty
                          ? ref
                                  .watch(homeScreenProvider)
                                  .filteredCreations
                                  .length -
                              1 -
                              index
                          : usersCreations.length - 1 - index;
                      var image = ref
                              .watch(homeScreenProvider)
                              .filteredCreations
                              .isNotEmpty
                          ? ref
                              .watch(homeScreenProvider)
                              .filteredCreations[reverseIndex]
                          : usersCreations[reverseIndex];
                      return VisibilityDetector(
                        key: Key('image-$index'),
                        onVisibilityChanged: (VisibilityInfo info) {
                          const double bufferZone = 300.0;
                          final bool isInBufferZone =
                              info.visibleBounds.top - bufferZone < 0 &&
                                  info.visibleBounds.bottom + bufferZone > 0;
                          if (isInBufferZone) {
                            ref
                                .read(homeScreenProvider)
                                .visibilityInfo(info, image["imageUrl"]);
                          }
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigation.pushNamed(
                              SeePictureScreen.routeName,
                              arguments: SeePictureParams(
                                  userId: image["userid"],
                                  profileName: image["creator_name"],
                                  image: image["imageUrl"],
                                  prompt: image["prompt"],
                                  modelName: image["model_name"],
                                  isHomeScreenNavigation: true,
                                  isRecentGeneration: false,
                                  index: reverseIndex,
                                  creatorEmail: image["creator_email"]),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: ref
                                      .watch(homeScreenProvider)
                                      .visibleImages
                                      .contains(image["imageUrl"])
                                  ? CachedNetworkImage(
                                      imageUrl: image["imageUrl"],
                                      fit: BoxFit.cover,
                                      memCacheHeight: 400,
                                      memCacheWidth: 400,
                                      fadeInDuration: Duration.zero,
                                      placeholder: (context, url) {
                                        return Shimmer.fromColors(
                                          baseColor: AppColors.lightIndigo,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            color: AppColors.lightIndigo,
                                            height: 200,
                                            width: double.infinity,
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
              );
            }
          },
        )
      ],
    );
  }
}
