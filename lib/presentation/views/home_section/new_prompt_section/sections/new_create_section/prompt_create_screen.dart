import 'dart:io';
import 'package:Artleap.ai/ads/rewarded_ads/rewarded_ad_button.dart';
import 'package:Artleap.ai/providers/keyboard_provider.dart';
import 'package:flutter/rendering.dart';
import '../../prompt_screen_widgets/prompt_top_bar.dart';
import 'components/generation_footer_redesign.dart';
import 'components/image_control_section.dart';
import 'components/loading_overlay_redesign.dart';
import 'components/prompt_input_section.dart';
import 'components/privacy_selection_section.dart';
import 'package:Artleap.ai/shared/route_export.dart';

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

class _PromptCreateScreenRedesignState
    extends ConsumerState<PromptCreateScreenRedesign>
    with SingleTickerProviderStateMixin {
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
        _showCreditsDialog(ref, context);
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
    final userProfile = ref.watch(userProfileProvider).userProfileData;
    final generateImageProviderState = ref.watch(generateImageProvider);

    if (userProfile == null || userProfile.user.totalCredits <= 0) {
      appSnackBar(
        "Oops!",
        "You have reached your daily limit. Thank you!",
        backgroundColor: theme.colorScheme.primary,
      );
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

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final shouldRefresh = ref.watch(refreshProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final screenSize = getScreenSizeCategory(context);
    final planName =
        ref.watch(userProfileProvider).userProfileData?.user.planName ?? 'Free';
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

  void _showCreditsDialog(WidgetRef ref, BuildContext context) {
    final userProfile = ref.read(userProfileProvider).userProfileData;
    final planName = userProfile?.user.planName ?? 'Free';
    final isFreePlan = planName.toLowerCase() == 'free';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Need More Credits?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You\'ve run out of credits!',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFreePlan
                  ? 'Watch a short ad to earn free credits or upgrade to premium for unlimited credits.'
                  : 'Upgrade your plan for unlimited credits.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            if (isFreePlan) const RewardedAdButton(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Maybe Later',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ChoosePlanScreen.routeName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Upgrade Plan'),
          ),
        ],
      ),
    );
  }
}
