import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/domain/api_models/user_profile_model.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_screen.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';

class MyCreationsWidget extends StatefulWidget {
  final String? userName;
  final List<Images> listofCreations;
  final String userId;

  const MyCreationsWidget({
    super.key,
    this.userName,
    required this.listofCreations,
    required this.userId,
  });

  @override
  State<MyCreationsWidget> createState() => _MyCreationsWidgetState();
}

class _MyCreationsWidgetState extends State<MyCreationsWidget> {
  late final filteredCreations;
  @override
  void initState() {
    if(widget.userId == UserData.ins.userId!){
      filteredCreations = widget.listofCreations
          .asMap()
          .entries
          .toList();
    } else {
      filteredCreations = widget.listofCreations
          .asMap()
          .entries
          .where((entry) => entry.value.privacy == 'public')
          .toList();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            filteredCreations.isEmpty
                ? Center(
              child: Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    'No Creations Yet',
                    style: AppTextstyle.interBold(
                      fontSize: 20,
                      color: AppColors.darkBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1,
              ),
              itemCount: filteredCreations.length,
              itemBuilder: (context, index) {
                // Use filteredCreations to maintain original indices
                var entry = filteredCreations[index];
                var reverseIndex = filteredCreations.length - 1 - index;
                var e = entry.value;
                return GestureDetector(
                  onTap: () {
                    Navigation.pushNamed(
                      SeePictureScreen.routeName,
                      arguments: SeePictureParams(
                        imageId: e.id,
                        image: e.imageUrl,
                        prompt: e.prompt,
                        modelName: e.modelName,
                        profileName: e.username,
                        userId: UserData.ins.userId,
                        index: reverseIndex,
                        creatorEmail: e.creatorEmail,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.darkBlue,
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