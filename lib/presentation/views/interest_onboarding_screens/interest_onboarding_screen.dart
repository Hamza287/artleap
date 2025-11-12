import 'package:Artleap.ai/domain/user_preferences/user_preferences_service.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/providers/interest_onboarding_provider.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
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

  Future<void> _saveUserInterests(WidgetRef ref, BuildContext context) async {
    final selectedOptions = ref.read(selectedOptionsProvider);
    final onboardingData = ref.read(onboardingDataProvider);
    final userId = UserData.ins.userId;

    if (userId == null || userId.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save interests.'),
            backgroundColor: Colors.red,
          ),
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
                  onContinue: () => _handleContinue(ref, context),
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