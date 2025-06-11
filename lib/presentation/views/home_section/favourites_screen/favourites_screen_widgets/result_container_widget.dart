import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/domain/api_models/user_favourites_model.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/providers/favrourite_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';

class ResultContainerWidget extends ConsumerWidget {
  final List<dynamic> data;
  const ResultContainerWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.blue,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
        child: GridView.builder(
          shrinkWrap: true, // Makes GridView take only necessary space
          physics:
              const NeverScrollableScrollPhysics(), // Disables GridView scrolling
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var reverseIndex = data.length - 1 - index;
            Favorites e = data[reverseIndex];
            return GestureDetector(
              onTap: () {
                Navigation.pushNamed(SeePictureScreen.routeName,
                    arguments: SeePictureParams(
                        // isHomeScreenNavigation: false,
                        // isRecentGeneration: false,
                        imageId: e.id,
                        image: e.imageUrl,
                        modelName: e.modelName,
                        profileName: e.username,
                        prompt: e.prompt,
                        userId: e.userId,
                        creatorEmail: e.creatorEmail));
              },
              child: Container(
                height: 155,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: AppColors.indigo,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: e.imageUrl,
                    fit: BoxFit.fill,
                    fadeInDuration: Duration.zero,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
