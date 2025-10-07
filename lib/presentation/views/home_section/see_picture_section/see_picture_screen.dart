import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/full_image_viewer_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_widgets/picture_info_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_widgets/picture_options_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_widgets/profile_name_follow_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/see_picture_section/see_picture_widgets/prompt_text_widget.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:Artleap.ai/shared/navigation/screen_params.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';

class SeePictureScreen extends ConsumerStatefulWidget {
  static const routeName = "see_picture_screen";
  final SeePictureParams? params;
  const SeePictureScreen({super.key, this.params,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeePictureScreenState();
}

class _SeePictureScreenState extends ConsumerState<SeePictureScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreenView(screenName: 'see image screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Column(
        children: [
          _buildCustomAppBar(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    if (widget.params!.userId != UserData.ins.userId)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ProfileNameFollowWidget(
                          profileName: widget.params!.profileName,
                          userId: widget.params!.userId,
                        ),
                      ),

                    const SizedBox(height: 24),
                    _buildImageSection(),
                    const SizedBox(height: 24),
                    PictureOptionsWidget(
                      imageId: widget.params!.imageId,
                      creatorName: widget.params!.profileName,
                      imageUrl: widget.params!.image ?? "",
                      prompt: widget.params!.prompt,
                      modelName: widget.params!.modelName,
                      uint8ListImage: widget.params!.uint8ListImage,
                      currentUserId: UserData.ins.userId,
                      index: widget.params!.index,
                      creatorEmail: widget.params!.creatorEmail,
                      otherUserId: widget.params!.userId,
                      privacy: widget.params!.privacy,
                    ),

                    const SizedBox(height: 28),
                    PromptTextWidget(
                      prompt: widget.params!.prompt,
                    ),
                    const SizedBox(height: 28),
                    PictureInfoWidget(
                      styleName: widget.params!.modelName,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button with Gradient
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigation.pop();
                },
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Title with Gradient Text
            Expanded(
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    "AI Artwork Details",
                    style: AppTextstyle.interMedium(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Close Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  Navigation.pop();
                },
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Main Image
              GestureDetector(
                onTap: () {
                  Navigation.pushNamed(FullImageViewerScreen.routeName,
                      arguments: FullImageScreenParams(
                        Image: widget.params!.image!,
                      ));
                },
                child: Container(
                  height: 380,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.params!.image!,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey[300]!, Colors.grey[200]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.grey[400], size: 48),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Tap to View Overlay
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigation.pushNamed(FullImageViewerScreen.routeName,
                          arguments: FullImageScreenParams(
                            Image: widget.params!.image!,
                          ));
                    },
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),
              //
              // // View Fullscreen Hint
              // Positioned(
              //   bottom: 16,
              //   right: 16,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //     decoration: BoxDecoration(
              //       color: Colors.black.withOpacity(0.7),
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(Icons.fullscreen_rounded, size: 16, color: Colors.white),
              //         const SizedBox(width: 4),
              //         Text(
              //           'Tap to view fullscreen',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}