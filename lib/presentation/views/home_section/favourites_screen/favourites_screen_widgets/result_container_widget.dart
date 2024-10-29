import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:photoroomapp/providers/favrourite_provider.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';

class ResultContainerWidget extends ConsumerWidget {
  final List<dynamic> data;
  const ResultContainerWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.blue),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
        child: RefreshIndicator(
          backgroundColor: AppColors.darkBlue,
          onRefresh: () {
            return ref.read(favouriteProvider).fetchUserFavourites();
          },
          child: GridView.builder(
            shrinkWrap:
                true, // Required if GridView is inside a scrollable parent
            // Disable GridView's own scrolling
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1, // Square items; adjust as needed
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var reverseIndex = data.length - 1 - index;
              var e = data[reverseIndex];
              return GestureDetector(
                onTap: () {
                  Navigation.pushNamed(SeePictureScreen.routeName,
                      arguments: SeePictureParams(
                          isHomeScreenNavigation: false,
                          isRecentGeneration: false,
                          image: e["imageUrl"],
                          modelName: e["model_name"],
                          profileName: e["creator_name"],
                          prompt: e["prompt"],
                          userId: e["userid"]));
                },
                child: Container(
                  height: 155,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.indigo),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: e["imageUrl"],
                        fit: BoxFit.fill,
                      )),
                ),
              );
            },
          ),
        ),

        // Container(
        //   height: 155,
        //   width: 150,
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       color: AppColors.indigo),
        // )
      ),
    );
  }
}
