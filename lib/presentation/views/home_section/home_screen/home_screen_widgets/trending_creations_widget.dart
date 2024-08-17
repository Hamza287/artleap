import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:photoroomapp/shared/constants/app_assets.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_static_data.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';

class TrendingCreationsWidget extends ConsumerWidget {
  const TrendingCreationsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color(0xffAD90FF),
                  Color(0xffEA6BFF),
                  Color(0xffFFA869)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'TRENDING CREATIONS',
                style: TextStyle(
                  color: Colors
                      .white, // This color must be here but it's not visible
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        15.spaceY,
        GridView.custom(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: [
              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              // QuiltedGridTile(1, 2),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate((context, index) {
            var image = artsStyleImagesLIst[index % artsStyleImagesLIst.length];
            return GestureDetector(
              onTap: () {
                Navigation.pushNamed(SeePictureScreen.routeName,
                    arguments: SeePictureParams(
                        image: image["image"] == ""
                            ? AppAssets.artstyle3
                            : image["image"]));
              },
              child: Container(
                  // height: 150,
                  // width: 200,
                  decoration: BoxDecoration(
                      // color: AppColors.t,
                      borderRadius: BorderRadius.circular(5),
                      image: image["image"] == ""
                          ? DecorationImage(
                              image: AssetImage(AppAssets.artstyle3))
                          : DecorationImage(image: AssetImage(image["image"]))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AppAssets.downloadicon,
                          height: 25,
                          width: 25,
                        ),
                        Image.asset(
                          AppAssets.saveicon,
                          height: 25,
                          width: 25,
                        )
                      ],
                    ),
                  )),
            );
          }, childCount: artsStyleImagesLIst.length),
        ),
      ],
    );
  }
}
