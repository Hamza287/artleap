import 'dart:io';

import 'package:Artleap.ai/presentation/firebase_analyitcs_singleton/firebase_analtics_singleton.dart';
import 'package:Artleap.ai/presentation/views/common/dialog_box/custom_credit_dialog.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_background_widget.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/providers/generate_image_provider.dart';
import 'package:Artleap.ai/providers/keyboard_provider.dart';
import 'package:Artleap.ai/providers/refresh_provider.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/shared/app_snack_bar.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../prompt_screen_widgets/prompt_top_bar.dart';
import '../../result/result_prompt_screen.dart';
import 'components/generation_footer_redesign.dart';
import 'components/image_control_section.dart';
import 'components/loading_overlay_redesign.dart';
import 'components/prompt_input_section.dart';
import 'components/privacy_selection_section.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);

ScreenSizeCategory getScreenSizeCategory(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 375) return ScreenSizeCategory.extraSmall;
  if (width < 414) return ScreenSizeCategory.small;
  if (width < 600) return ScreenSizeCategory.medium;
  return ScreenSizeCategory.large;
}

enum ScreenSizeCategory { extraSmall, small, medium, large }

class PromptCreateScreenRedesign extends ConsumerStatefulWidget {
  const PromptCreateScreenRedesign({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PromptCreateScreenRedesignState();
}

class _PromptCreateScreenRedesignState extends ConsumerState<PromptCreateScreenRedesign> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.instance.logScreenView(screenName: 'generating screen');
      final userProfile = ref.read(userProfileProvider).userProfileData;
      if (userProfile != null && userProfile.user.totalCredits == 0) {
        showDialog(
          context: context,
          builder: (context) => const CustomCreditDialog(),
        );
      }
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scrollController.addListener(_handleScroll);
  }

  Future<bool> _checkNetworkAvailability() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _handleScroll() {
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

  void _handleGenerate() async {
    final theme = Theme.of(context);
    final userProfile = ref.watch(userProfileProvider).userProfileData;
    final generateImageProviderState = ref.watch(generateImageProvider);

    if (userProfile == null || userProfile.user.totalCredits <= 0) {
      appSnackBar(
        "Oops!",
        "You have reached your daily limit. Thank you!",
        theme.colorScheme.primary,
      );
      return;
    }
    final isNetworkAvailable = await _checkNetworkAvailability();
    if (!isNetworkAvailable) {
      appSnackBar(
        "No Internet Connection",
        "Please check your network connection and try again",
        theme.colorScheme.error,
      );
      return;
    }

    if (generateImageProviderState.containsSexualWords) {
      appSnackBar(
        "Warning!",
        "Your prompt contains sexual words.",
        theme.colorScheme.error,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    ref.read(keyboardVisibleProvider.notifier).state = false;

    // Validation
    if (generateImageProviderState.selectedImageNumber == null &&
        generateImageProviderState.images.isEmpty) {
      appSnackBar(
        "Error",
        "Please select number of images",
        theme.colorScheme.error,
      );
      return;
    }

    if (generateImageProviderState.promptTextController.text.isEmpty) {
      appSnackBar(
        "Error",
        "Please write your prompt",
        theme.colorScheme.error,
      );
      return;
    }

    // Credit validation
    final isTextToImage = generateImageProviderState.images.isEmpty;
    final requiredCredits = generateImageProviderState.selectedImageNumber! *
        (isTextToImage ? 2 : 24);

    if (userProfile.user.totalCredits < requiredCredits) {
      appSnackBar(
        "Insufficient Credits",
        "You need $requiredCredits credits to generate ${generateImageProviderState.selectedImageNumber} ${isTextToImage ? 'images' : 'variations'}",
        theme.colorScheme.error,
      );
      return;
    }

    AnalyticsService.instance
        .logButtonClick(buttonName: 'Generate button event');
    ref.read(isLoadingProvider.notifier).state = true;
    _animationController.forward();

    // final success = isTextToImage
    //     ? await ref.read(generateImageProvider.notifier).generateTextToImage()
    //     : await ref.read(generateImageProvider.notifier).generateImgToImg();

    bool success = false;

    if(isTextToImage){
      success = await ref.read(generateImageProvider.notifier).generateTextToImage();
      if(!success){
        success = await ref.read(generateImageProvider.notifier).generateLeonardoTxt2Image();
      }
    }else{
      await ref.read(generateImageProvider.notifier).generateImgToImg();
    }


    ref.read(isLoadingProvider.notifier).state = false;
    _animationController.reverse();

    if (success && mounted) {
      Navigation.pushNamed(ResultScreenRedesign.routeName);
    } else if (mounted) {
      appSnackBar(
        "Error",
        "Failed to Generate Image",
        theme.colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final shouldRefresh = ref.watch(refreshProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final screenSize = getScreenSizeCategory(context);
    final planName = ref.watch(userProfileProvider).userProfileData?.user.planName ?? 'Free';
    final isFreePlan = planName.toLowerCase() == 'free';
    final isKeyboardVisible = ref.watch(keyboardVisibleProvider);

    if (shouldRefresh && UserData.ins.userId != null) {
      Future.microtask(() {
        ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId!);
      });
    }

    final horizontalPadding = screenSize == ScreenSizeCategory.small ||
            screenSize == ScreenSizeCategory.extraSmall
        ? 16.0
        : 24.0;
    final topPadding = screenSize == ScreenSizeCategory.small ||
            screenSize == ScreenSizeCategory.extraSmall
        ? 16.0
        : 24.0;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop && !isLoading) {
          ref.read(bottomNavBarProvider).setPageIndex(0);
          if (isKeyboardVisible) {
            ref.read(keyboardControllerProvider).hideKeyboard(context);
          }
        }
      },
      child: Stack(
          children: [
            AppBackgroundWidget(
              widget: GestureDetector(
                onTap: () {
                  ref.read(isDropdownExpandedProvider.notifier).state = false;
                  if (isKeyboardVisible) {
                    ref.read(keyboardControllerProvider).hideKeyboard(context);
                  }
                  FocusScope.of(context).unfocus();
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: topPadding,
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PromptInputRedesign(),
                        const SizedBox(height: 16),
                        PrivacySelectionSection(
                          isPremiumUser: !isFreePlan,
                        ),
                        const SizedBox(height: 16),
                        ImageControlsRedesign(
                          onImageSelected: () {
                            AnalyticsService.instance.logButtonClick(
                              buttonName:
                                  'picking image from gallery button event',
                            );
                          },
                          isPremiumUser: !isFreePlan,
                        ),
                        SizedBox(
                            height: screenSize == ScreenSizeCategory.small ||
                                    screenSize == ScreenSizeCategory.extraSmall
                                ? 100.0
                                : 120.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GenerationFooterRedesign(
              onGenerate: _handleGenerate,
              isLoading: isLoading,
            ),
            if (isLoading)
              LoadingOverlayRedesign(
                animationController: _animationController,
                fadeAnimation: _fadeAnimation,
              ),
          ],
        ),
    );
  }
}
