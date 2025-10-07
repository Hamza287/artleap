import 'package:Artleap.ai/shared/extensions/sized_box.dart';
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
      filteredCreations = widget.listofCreations.asMap().entries.toList();
    } else {
      filteredCreations = widget.listofCreations.asMap().entries.where((entry) => entry.value.privacy == 'public').toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16),
            child: Text(
              "Gallery",
              style: AppTextstyle.interMedium(
                fontSize: 18,
                color: AppColors.darkBlue,
              ),
            ),
          ),
          _buildCreationsGrid(),
        ],
      ),
    );
  }

  Widget _buildCreationsGrid() {
    if (filteredCreations.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              12.spaceY,
              Text(
                'No creations yet',
                style: AppTextstyle.interMedium(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              4.spaceY,
              Text(
                'Start creating amazing AI art!',
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: filteredCreations.length,
      itemBuilder: (context, index) {
        final entry = filteredCreations[index];
        final reverseIndex = filteredCreations.length - 1 - index;
        final e = entry.value;

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
                privacy: e.privacy,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: e.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        );
      },
    );
  }
}