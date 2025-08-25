import 'package:Artleap.ai/presentation/views/interest_onboarding_screens/sections/step1.dart';
import 'package:Artleap.ai/presentation/views/interest_onboarding_screens/sections/step2.dart';
import 'package:Artleap.ai/presentation/views/interest_onboarding_screens/sections/step3.dart';
import 'package:Artleap.ai/presentation/views/interest_onboarding_screens/sections/step4.dart';
import 'package:Artleap.ai/providers/interest_onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utilities/progress_bar.dart';

class InterestOnboardingScreen extends ConsumerWidget {
  const InterestOnboardingScreen({super.key});
  static const String routeName = "interest_onboarding_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(interestOnboardingStepProvider);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    final pages = [
      const Step1(),
      const Step2(),
      const Step3(),
      const Step4(),
    ];

    return Scaffold(
      appBar: AppBar(
        // 👇 Hide back button if step == 0
        leading: step == 0
            ? null
            : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final currentStep = ref.read(interestOnboardingStepProvider);
            if (currentStep > 0) {
              ref.read(interestOnboardingStepProvider.notifier).state--;
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'login_screen');
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ProgressBar(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : 32.0,
                ),
                child: pages[step],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
