import 'package:Artleap.ai/presentation/firebase_analyitcs_singleton/firebase_analtics_singleton.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_background_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/new_prompt_section/result/result_prompt_screen.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/providers/refresh_provider.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../prompt_screen_widgets/prompt_screen_button.dart';
import '../../prompt_screen_widgets/prompt_top_bar.dart';
import 'create_section_widget/ImageControlWidget.dart';
import 'create_section_widget/prompt_widget.dart';

// Define a provider for managing the loader state
final isLoadingProvider = StateProvider<bool>((ref) => false);

class PromptCreateScreen extends ConsumerStatefulWidget {
  const PromptCreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PromptOrReferenceScreenState();
}

class _PromptOrReferenceScreenState extends ConsumerState<PromptCreateScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.instance.logScreenView(screenName: 'generating screen');
    });

    // Initialize animation controller for fade effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Add listener to scroll controller to hide keyboard on scroll
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    // Hide keyboard when user starts scrolling
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      FocusScope.of(context).unfocus();
      ref.read(keyboardVisibleProvider.notifier).state = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).userProfileData;
    final generateImageProviderState = ref.watch(generateImageProvider);
    final shouldRefresh = ref.watch(refreshProvider);
    final isLoading = ref.watch(isLoadingProvider);

    if (shouldRefresh && UserData.ins.userId != null) {
      Future.microtask(() {
        ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId!);
      });
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop && !isLoading) {
          ref.read(bottomNavBarProvider).setPageIndex(0);
          ref.read(keyboardVisibleProvider.notifier).state = false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            AppBackgroundWidget(
              widget: GestureDetector(
                onTap: () {
                  ref.read(isDropdownExpandedProvider.notifier).state = false;
                  ref.read(keyboardVisibleProvider.notifier).state = false;
                  FocusScope.of(context).unfocus(); // Hide keyboard on tap outside
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.spaceY,
                        const PromptWidget(),
                        10.spaceY,
                        ImageControlsWidget(
                          onImageSelected: () {
                            ref.read(generateImageProvider).pickImage();
                            AnalyticsService.instance.logButtonClick(
                                buttonName:
                                'picking image from gallery button event');
                          },
                        ),
                        70.spaceY,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // White background container for the button area
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.9),
                      Colors.white,
                    ],
                  ),
                ),
                // Fixed: Maintain consistent bottom padding regardless of keyboard
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0
                      ? MediaQuery.of(context).viewInsets.bottom + 10 // Add extra padding when keyboard is visible
                      : 20, // Normal padding when no keyboard
                ),
                child: PromptScreenButton(
                  height: 55,
                  width: double.infinity,
                  imageIcon: AppAssets.generateicon,
                  title: "Generate",
                  suffixRow: true,
                  credits: generateImageProviderState.images.isNotEmpty ? '24' : '2',
                  onpress: (userProfile == null ||
                      userProfile.user.totalCredits <= 0)
                      ? () {
                    appSnackBar(
                        "Oops!",
                        "You have reached your daily limit. Thank you!",
                        AppColors.indigo);
                  }
                      : generateImageProviderState.containsSexualWords
                      ? () {
                    appSnackBar(
                        "Warning!",
                        "Your prompt contains sexual words.",
                        AppColors.redColor);
                  }
                      : () async {
                    // Hide keyboard before generating
                    FocusScope.of(context).unfocus();
                    ref.read(keyboardVisibleProvider.notifier).state = false;

                    // Common validation checks
                    if (generateImageProviderState.selectedImageNumber ==
                        null &&
                        generateImageProviderState.images.isEmpty) {
                      appSnackBar("Error", "Please select number of images",
                          AppColors.redColor);
                    } else if (generateImageProviderState
                        .promptTextController.text.isEmpty) {
                      appSnackBar("Error", "Please write your prompt",
                          AppColors.redColor);
                    }
                    // Credit validation for text-to-image
                    else if (generateImageProviderState.images.isEmpty) {
                      final requiredCredits =
                          generateImageProviderState.selectedImageNumber! * 2;
                      if (userProfile.user.totalCredits < requiredCredits) {
                        appSnackBar(
                            "Insufficient Credits",
                            "You need $requiredCredits credits to generate ${generateImageProviderState.selectedImageNumber} images",
                            AppColors.redColor);
                      } else {
                        AnalyticsService.instance
                            .logButtonClick(buttonName: 'Generate button event');
                        ref.read(isLoadingProvider.notifier).state = true;
                        _animationController.forward();
                        final success = await ref
                            .read(generateImageProvider.notifier)
                            .generateTextToImage();
                        ref.read(isLoadingProvider.notifier).state = false;
                        _animationController.reverse();
                        if (success && mounted) {
                          Navigation.pushNamed(ResultScreenRedesign.routeName);
                        } else if (mounted) {
                          appSnackBar("Error", "Failed to Generate Image",
                              AppColors.redColor);
                        }
                      }
                    }
                    // Credit validation for image-to-image
                    else {
                      final requiredCredits =
                          generateImageProviderState.selectedImageNumber! * 24;
                      if (userProfile.user.totalCredits < requiredCredits) {
                        appSnackBar(
                            "Insufficient Credits",
                            "You need $requiredCredits credits to generate ${generateImageProviderState.selectedImageNumber} variations",
                            AppColors.redColor);
                      } else {
                        AnalyticsService.instance
                            .logButtonClick(buttonName: 'Generate button event');
                        ref.read(isLoadingProvider.notifier).state = true;
                        _animationController.forward();
                        final success = await ref
                            .read(generateImageProvider.notifier)
                            .generateImgToImg();
                        ref.read(isLoadingProvider.notifier).state = false;
                        _animationController.reverse();
                        if (success && mounted) {
                          Navigation.pushNamed(ResultScreenRedesign.routeName);
                        } else if (mounted) {
                          appSnackBar("Error", "Failed to Generate Image",
                              AppColors.redColor);
                        }
                      }
                    }
                  },
                  isLoading: false, // Remove button-specific loading
                ),
              ),
            ),
            // Full-screen loader overlay
            if (isLoading)
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.indigo),
                              strokeWidth: 5,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Generating Your Art...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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