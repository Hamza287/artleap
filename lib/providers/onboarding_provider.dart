import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/constants/app_static_data.dart';

final onboardingProvider =
    ChangeNotifierProvider<OnBoardingProvider>((ref) => OnBoardingProvider());

class OnBoardingProvider extends ChangeNotifier {
  PageController pageController = PageController();
  int _onboardingPageIndex = 0;
  int get onboardingPageIndex => _onboardingPageIndex;
  Timer? timer;
  bool isAnimating = false; // Add a flag to track if the page is animating

  setOnboardingPageIndex(int index) {
    _onboardingPageIndex = index;
    notifyListeners();
  }

  void startAutoPageView() {
    timer = Timer.periodic(Duration(seconds: 4), (timer) async {
      if (!isAnimating) {
        // Only start if not already animating
        int nextPage = onboardingPageIndex + 1;
        if (nextPage >= onboardingImagesList.length) {
          nextPage = 0;
        }

        isAnimating = true; // Set the flag to true when animation starts
        await pageController
            .animateToPage(
          nextPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOutCubicEmphasized,
        )
            .then(
          (value) {
            isAnimating = false;
            setOnboardingPageIndex(nextPage);
          },
        );
        // Reset the flag after animation completes
      }
    });
  }

  // Add a method to cancel the timer when the onboarding is complete or the user leaves the screen.
  void stopAutoPageView() {
    timer?.cancel();
    timer = null;
  }
}
