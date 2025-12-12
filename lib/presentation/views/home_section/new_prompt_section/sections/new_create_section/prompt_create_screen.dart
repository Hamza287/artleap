import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:Artleap.ai/shared/route_export.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);
final adPreloadedProvider = StateProvider<bool>((ref) => false);

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

class _PromptCreateScreenRedesignState
    extends ConsumerState<PromptCreateScreenRedesign>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _adDialogShown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AnalyticsService.instance.logScreenView(screenName: 'generating screen');

      // Preload ad when screen opens using AdHelper
      await AdHelper.preloadRewardedAd(ref);

      final userProfile = ref.read(userProfileProvider).value!.userProfile;
      if (userProfile != null && userProfile.user.totalCredits == 0) {
        _showCreditsDialog();
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

  bool _isValidPrompt(String prompt) {
    final trimmedPrompt = prompt.trim();
    return trimmedPrompt.isNotEmpty && trimmedPrompt.length >= 2;
  }

  void _handleGenerate() async {
    final theme = Theme.of(context);
    final userProfile = ref.watch(userProfileProvider).value!.userProfile;
    final generateImageProviderState = ref.watch(generateImageProvider);

    if (userProfile == null || userProfile.user.totalCredits <= 0) {
      // If user has no credits, show the credits dialog
      if (!_adDialogShown) {
        _adDialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showCreditsDialog();
        });
      }
      return;
    }

    final isNetworkAvailable = await _checkNetworkAvailability();
    if (!isNetworkAvailable) {
      appSnackBar(
        "No Internet Connection",
        "Please check your network connection and try again",
        backgroundColor: theme.colorScheme.error,
      );
      return;
    }

    if (generateImageProviderState.containsSexualWords) {
      appSnackBar(
        "Warning!",
        "Your prompt contains sexual words.",
        backgroundColor: theme.colorScheme.error,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    ref.read(keyboardVisibleProvider.notifier).state = false;

    if (generateImageProviderState.selectedImageNumber == null &&
        generateImageProviderState.images.isEmpty) {
      appSnackBar(
        "Error",
        "Please select number of images",
        backgroundColor: theme.colorScheme.error,
      );
      return;
    }

    final promptText = generateImageProviderState.promptTextController.text;
    if (!_isValidPrompt(promptText)) {
      appSnackBar(
        "Error",
        "Please write a meaningful prompt",
        backgroundColor: theme.colorScheme.error,
      );
      return;
    }

    final isTextToImage = generateImageProviderState.images.isEmpty;
    final requiredCredits = generateImageProviderState.selectedImageNumber! *
        (isTextToImage ? 2 : 24);

    if (userProfile.user.totalCredits < requiredCredits) {
      appSnackBar(
        "Insufficient Credits",
        "You need $requiredCredits credits to generate ${generateImageProviderState.selectedImageNumber} ${isTextToImage ? 'images' : 'variations'}",
        backgroundColor: theme.colorScheme.error,
      );
      return;
    }

    AnalyticsService.instance
        .logButtonClick(buttonName: 'Generate button event');
    ref.read(isLoadingProvider.notifier).state = true;
    _animationController.forward();

    bool success = false;

    if (isTextToImage) {
      success =
      await ref.read(generateImageProvider.notifier).generateTextToImage();
      if (!success) {
        success = await ref
            .read(generateImageProvider.notifier)
            .generateLeonardoTxt2Image();
      }
    } else {
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
        backgroundColor: theme.colorScheme.error,
      );
    }
  }

  void _showCreditsDialog() {
    final userProfile = ref.read(userProfileProvider).value!.userProfile;
    final planName = userProfile?.user.planName ?? 'Free';
    final isFreePlan = planName.toLowerCase() == 'free';

    // Get ad state
    final adState = ref.read(rewardedAdNotifierProvider);
    final adNotifier = ref.read(rewardedAdNotifierProvider.notifier);

    showCreditsDialog(
      context: context,
      ref: ref,
      isFreePlan: isFreePlan,
      adState: adState,
      onWatchAd: () {
        Navigator.of(context).pop();
        _showRewardedAd();
      },
      onUpgrade: () {
        Navigator.of(context).pop();
        Navigation.pushNamed(ChoosePlanScreen.routeName);
      },
      onLater: () {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) Navigator.of(context).pop();
        });

      },
      onLoadAd: () {
        adNotifier.loadAd();
      },
      adDialogShown: _adDialogShown,
      onDialogShownChanged: (value) {
        _adDialogShown = value;
      },
    );
  }

  Future<void> _showRewardedAd() async {
    await AdHelper.showRewardedAd(
      ref: ref,
      onRewardEarned: (coins) {
        AdHelper.showRewardSuccessSnackbar(context, coins);
        AdHelper.refreshUserProfileAfterReward(ref);
      },
      onAdDismissed: () {
        final adNotifier = ref.read(rewardedAdNotifierProvider.notifier);
        adNotifier.loadAd();
      },
      onAdFailed: () {
        AdHelper.showAdErrorSnackbar(
          context,
          'Failed to show ad. Please try again.',
        );

        Future.delayed(const Duration(seconds: 2), () {
          final adNotifier = ref.read(rewardedAdNotifierProvider.notifier);
          adNotifier.loadAd();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shouldRefresh = ref.watch(refreshProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final screenSize = getScreenSizeCategory(context);
    final planName =
        ref.watch(userProfileProvider).value!.userProfile!.user.planName ?? 'Free';
    final isFreePlan = planName.toLowerCase() == 'free';
    final isKeyboardVisible = ref.watch(keyboardVisibleProvider);

    if (shouldRefresh && UserData.ins.userId != null) {
      Future.microtask(() {
        ref.read(userProfileProvider.notifier).getUserProfileData(UserData.ins.userId!);
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