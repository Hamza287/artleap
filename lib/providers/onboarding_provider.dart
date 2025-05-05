import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/constants/app_static_data.dart';

final onboardingProvider =
    ChangeNotifierProvider<OnBoardingProvider>((ref) => OnBoardingProvider());

class OnBoardingProvider extends ChangeNotifier {
  late PageController pageController;
  int _onboardingPageIndex = 0;
  int get onboardingPageIndex => _onboardingPageIndex;
  Timer? timer;
  bool isAnimating = false;

  OnBoardingProvider() {
    pageController =
        PageController(initialPage: onboardingImagesList.length * 100);
  }

  setOnboardingPageIndex(int index) {
    _onboardingPageIndex =
        index % onboardingImagesList.length; // Loop the index
    notifyListeners();
  }

  void startAutoPageView() {
    timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (!isAnimating && pageController.hasClients) {
        int nextPage = pageController.page!.toInt() + 1;

        isAnimating = true;
        await pageController
            .animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCirc,
        )
            .then((value) {
          isAnimating = false;
          setOnboardingPageIndex(nextPage);
        });
      }
    });
  }

  void stopAutoPageView() {
    timer?.cancel();
    if (pageController.hasClients) {
      pageController.dispose();
    }
  }
}
