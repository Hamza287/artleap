import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
// import 'package:Artleap.ai/domain/api_models/Image_to_Image_model.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';

class MyCreationsWidget extends StatelessWidget {
  final String? userName;
  final List<Images> listofCreations;

  const MyCreationsWidget({
    super.key,
    this.userName,
    required this.listofCreations,
  });

  @override
  Widget build(BuildContext context) {
    print("listofCreations: $listofCreations");
    print("userName: $userName");
    print("gggggggggggggggggggg");
    return Container(
      decoration: const BoxDecoration(
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
                        "Creations",
                        style: AppTextstyle.interMedium(
                            color: AppColors.white, fontSize: 14),
                      ),
                // Your dropdown widget here (if needed)
              ],
            ),
            const SizedBox(height: 20),
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
                        const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1, // Square items, adjust as needed
                    ),
                    itemCount: listofCreations.length,
                    itemBuilder: (context, index) {
                      var reverseIndex = listofCreations.length - 1 - index;
                      var e = listofCreations[reverseIndex];
                      return GestureDetector(
                        onTap: () {
                          Navigation.pushNamed(
                            SeePictureScreen.routeName,
                            arguments: SeePictureParams(
                                // isHomeScreenNavigation: false,
                                imageId: e.id,
                                image: e.imageUrl,
                                prompt: e.prompt,
                                // isRecentGeneration: false,
                                modelName: e.modelName,
                                profileName: e.username,
                                userId: UserData.ins.userId,
                                index: reverseIndex,
                                creatorEmail: e.creatorEmail),
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
                              imageUrl: e.imageUrl,
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
