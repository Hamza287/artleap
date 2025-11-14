import 'package:Artleap.ai/domain/tutorial/tutorial_provider.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/shared/utilities/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'privacy_policy_accept.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  static const String routeName = "tutorial_screen";

  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStartedPressed() async {
    final notifier = ref.read(tutorialStateProvider.notifier);
    await notifier.completeTutorial();

    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _onSkipPressed() async {
    final notifier = ref.read(tutorialStateProvider.notifier);
    await notifier.skipTutorial();

    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() async {
    final userData = ArtleapNavigationManager.getUserDataFromStorage();
    final userId = userData['userId'] ?? "";
    final userName = userData['userName'] ?? "";
    final userProfilePicture = userData['userProfilePicture'] ?? "";
    final userEmail = userData['userEmail'] ?? "";

    final hasSeenTutorial = await ArtleapNavigationManager.getTutorialStatus(ref);

    await ArtleapNavigationManager.navigateBasedOnUserStatus(
      context: context,
      ref: ref,
      userId: userId,
      userName: userName,
      userProfilePicture: userProfilePicture,
      userEmail: userEmail,
      hasSeenTutorial: hasSeenTutorial,
    );
  }

  void _onPageChanged(int page) {
    ref.read(tutorialStateProvider.notifier).setCurrentPage(page);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(tutorialStateProvider);
    final notifier = ref.read(tutorialStateProvider.notifier);
    final currentScreen = notifier.getCurrentScreen();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final imageHeight =
        isSmallScreen ? screenHeight * 0.5 : screenHeight * 0.55;

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                child: TextButton(
                  onPressed: _onSkipPressed,
                  style: TextButton.styleFrom(
                    foregroundColor:
                        theme.colorScheme.onSurface.withOpacity(0.7),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTextstyle.interMedium(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: imageHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: notifier.totalPages,
                onPageChanged: _onPageChanged, // This was causing the issue
                itemBuilder: (context, index) {
                  final screen = ref.watch(tutorialDataProvider)[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          screen.imageAsset,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surfaceContainer,
                              child: Icon(
                                Icons.image,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.3),
                                size: 60,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: isSmallScreen ? 16.0 : 24.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentScreen.title,
                                style: AppTextstyle.interBold(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  color: theme.colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentScreen.description,
                                style: AppTextstyle.interRegular(
                                  fontSize: isSmallScreen ? 11 : 12,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            notifier.totalPages,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: state.currentPage == index ? 24 : 8,
                              height: 6,
                              decoration: BoxDecoration(
                                color: state.currentPage == index
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: isSmallScreen ? 50 : 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (state.currentPage > 0)
                              SizedBox(
                                width: screenWidth * 0.35,
                                child: TextButton(
                                  onPressed: () {
                                    final newPage = state.currentPage - 1;
                                    notifier.setCurrentPage(newPage);
                                    _pageController.animateToPage(
                                      newPage,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: theme.colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: theme.colorScheme.primary,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Previous',
                                        style: AppTextstyle.interMedium(
                                          fontSize: 14,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              SizedBox(width: screenWidth * 0.35),
                            SizedBox(
                              width: screenWidth * 0.35,
                              child: ElevatedButton(
                                onPressed: state.isLastPage
                                    ? _onGetStartedPressed
                                    : () {
                                        final newPage = state.currentPage + 1;
                                        notifier.setCurrentPage(newPage);
                                        _pageController.animateToPage(
                                          newPage,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 2,
                                  shadowColor: theme.colorScheme.primary
                                      .withOpacity(0.3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      state.isLastPage ? 'Start' : 'Next',
                                      style: AppTextstyle.interMedium(
                                        fontSize: 14,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    if (!state.isLastPage) ...[
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: theme.colorScheme.onPrimary,
                                        size: 14,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
