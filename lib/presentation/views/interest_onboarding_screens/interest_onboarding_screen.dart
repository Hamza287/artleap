import 'package:Artleap.ai/providers/interest_onboarding_controller.dart';
import 'package:Artleap.ai/shared/utilities/progress_bar.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../login_and_signup_section/login_section/login_screen.dart';
import 'components/onboarding_step_content.dart';

class InterestOnboardingScreen extends ConsumerWidget {
  const InterestOnboardingScreen({super.key});
  static const String routeName = "interest_onboarding_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentStep = ref.watch(interestOnboardingStepProvider);
    final onboardingData = ref.watch(onboardingDataProvider);
    final selectedOptions = ref.watch(selectedOptionsProvider);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    final currentStepData = onboardingData[currentStep];
    final currentSelection = selectedOptions[currentStep];

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
              Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : 32.0,
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
                  onContinue: () {
                    if (currentStep < onboardingData.length - 1) {
                      ref.read(interestOnboardingStepProvider.notifier).state++;
                    } else {
                      Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
                    }
                  },
                  isLastStep: currentStep == onboardingData.length - 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}