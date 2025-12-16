import 'components/onboarding_step_content.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class InterestOnboardingScreen extends ConsumerWidget {
  const InterestOnboardingScreen({super.key});
  static const String routeName = "interest_onboarding_screen";

  Future<void> _saveUserInterests(WidgetRef ref, BuildContext context) async {
    final selectedOptions = ref.read(selectedOptionsProvider);
    final onboardingData = ref.read(onboardingDataProvider);
    final userId = UserData.ins.userId;

    if (userId == null || userId.isEmpty) {
      if (context.mounted) {
        appSnackBar(
          'Error',
          'User not found. Please login again.',
          backgroundColor: AppColors.red,
        );
      }
      return;
    }

    List<String> selectedInterests = [];
    List<String> categories = [];

    for (int i = 0; i < selectedOptions.length; i++) {
      final selectedIndex = selectedOptions[i];
      if (selectedIndex != null && onboardingData[i].options.length > selectedIndex) {
        selectedInterests.add(onboardingData[i].options[selectedIndex]);
        categories.add('category_$i');
      }
    }

    if (selectedInterests.isNotEmpty) {
      final success = await ref.read(userPreferencesServiceProvider).updateUserInterests(
        userId: userId,
        selected: selectedInterests,
        categories: categories,
      );

      if (!success && context.mounted) {
        appSnackBar(
          'Error',
          'Failed to save interests.',
          backgroundColor: AppColors.red,
        );
      }
    }
  }

  void _handleContinue(WidgetRef ref, BuildContext context) {
    final currentStep = ref.read(interestOnboardingStepProvider);
    final onboardingData = ref.read(onboardingDataProvider);

    if (currentStep < onboardingData.length - 1) {
      ref.read(interestOnboardingStepProvider.notifier).state++;
    } else {
      _saveUserInterests(ref, context).then((_) {
        Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentStep = ref.watch(interestOnboardingStepProvider);
    final onboardingData = ref.watch(onboardingDataProvider);
    final selectedOptions = ref.watch(selectedOptionsProvider);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenWidth < 600;

    final currentStepData = onboardingData[currentStep];
    final currentSelection = selectedOptions[currentStep];

    final adState = ref.watch(nativeAdProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: currentStep == 0
            ? null
            : IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () {
            if (currentStep > 0) {
              ref.read(interestOnboardingStepProvider.notifier).state--;
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigation.pushNamedAndRemoveUntil(BottomNavBar.routeName);
            },
            child: Text(
              'Skip',
              style: AppTextstyle.interMedium(
                fontSize: 16.0,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ProgressBar(),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 16.0 : 32.0,
                                  vertical: 16.0,
                                ),
                                child: OnboardingStepContent(
                                  stepData: currentStepData,
                                  currentStep: currentStep,
                                  selectedIndex: currentSelection,
                                  onOptionSelected: (index) {
                                    final updatedSelections = List<int?>.from(selectedOptions);
                                    updatedSelections[currentStep] = index;
                                    ref.read(selectedOptionsProvider.notifier).state = updatedSelections;
                                  },
                                  onContinue: () => _handleContinue(ref, context),
                                  isLastStep: currentStep == onboardingData.length - 1,
                                ),
                              ),
                            ),
                            if (adState.showAds && adState.nativeAds.isNotEmpty && !adState.isLoading)
                              _buildNativeAdWidget(adState, isSmallScreen, currentStep, context),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNativeAdWidget(NativeAdState adState, bool isSmallScreen, int currentStep, BuildContext context) {
    final adIndex = currentStep % adState.nativeAds.length;
    final nativeAd = adState.nativeAds[adIndex];

    return Container(
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: isSmallScreen ? 16.0 : 32.0,
        right: isSmallScreen ? 16.0 : 32.0,
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AdWidget(ad: nativeAd),
        ),
      ),
    );
  }
}