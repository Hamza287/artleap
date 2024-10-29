import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:photoroomapp/providers/user_profile_provider.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/constants/user_data.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import 'package:photoroomapp/shared/navigation/navigation.dart';
import 'package:photoroomapp/shared/navigation/screen_params.dart';

class MyCreationsWidget extends StatelessWidget {
  final String? userName;
  final List listofCreations;

  MyCreationsWidget({
    Key? key,
    this.userName,
    required this.listofCreations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 30, right: 15, left: 15, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                userName != null
                    ? Text(
                        "$userName Creations",
                        style: AppTextstyle.interMedium(
                            color: AppColors.white, fontSize: 14),
                      )
                    : Text(
                        "My Creations",
                        style: AppTextstyle.interMedium(
                            color: AppColors.white, fontSize: 14),
                      ),
                // Your dropdown widget here (if needed)
              ],
            ),
            SizedBox(height: 20),
            // Display "No data yet" or the creations
            listofCreations.isEmpty
                ? Center(
                    child: Text(
                      "No data yet",
                      style: AppTextstyle.interBold(
                          fontSize: 15, color: AppColors.white),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap:
                        true, // Needed if GridView is inside a scrollable parent

                    physics:
                        NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1, // Square items, adjust as needed
                    ),
                    itemCount: listofCreations.length,
                    itemBuilder: (context, index) {
                      var reverIndex = listofCreations.length - 1 - index;
                      var e = listofCreations[reverIndex];
                      return GestureDetector(
                        onTap: () {
                          Navigation.pushNamed(
                            SeePictureScreen.routeName,
                            arguments: SeePictureParams(
                              isHomeScreenNavigation: false,
                              image: e["imageUrl"],
                              prompt: e["prompt"],
                              isRecentGeneration: false,
                              modelName: e["model_name"],
                              profileName: e["creator_name"],
                              userId: UserData.ins.userId,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: e["imageUrl"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
