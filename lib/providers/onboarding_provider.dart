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
  setOnboardingPageIndex(int index) {
    _onboardingPageIndex = index;
    notifyListeners();
  }

  void startAutoPageView() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      int nextPage = onboardingPageIndex + 1;
      if (nextPage >= onboardingImagesList.length) {
        nextPage = 0;
      }
      pageController.animateToPage(
        duration: Duration(milliseconds: 300),
        nextPage,
        curve: Curves.easeInOutCubicEmphasized,
      );
      setOnboardingPageIndex(nextPage);
    });
  }
}
