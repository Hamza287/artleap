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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF0A0A0A) : Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          _buildCustomAppBar(theme, isDark),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
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
                    _buildImageSection(theme, isDark),
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

  Widget _buildCustomAppBar(ThemeData theme, bool isDark) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Navigation.pop();
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: isDark ? Colors.white : Colors.black,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Title
            Expanded(
              child: Center(
                child: Text(
                  "AI Artwork Details",
                  style: AppTextstyle.interMedium(
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Close Button
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Navigation.pop();
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: isDark ? Colors.white : Colors.black,
                  size: 20,
                ),
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

  Widget _buildImageSection(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1E1E1E) : Color(0xFFF5F5F5),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.params!.image!,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [Color(0xFF2D2D2D), Color(0xFF1E1E1E)]
                              : [Color(0xFFF0F0F0), Color(0xFFE5E5E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo,
                          color: isDark ? Colors.white38 : Colors.grey.shade400,
                          size: 50,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: isDark ? Color(0xFF2D2D2D) : Color(0xFFF5F5F5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.error_outline,
                              color: isDark ? Colors.white38 : Colors.grey.shade400,
                              size: 48
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load image',
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                              fontSize: 14,
                            ),
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
                    splashColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),

              // View Fullscreen Hint
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          Icons.fullscreen_rounded,
                          size: 14,
                          color: isDark ? Colors.white70 : Colors.black54
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'View fullscreen',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}