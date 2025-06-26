import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/presentation/views/onboarding_section/onboarding_widgets/continue_button.dart';
import 'package:Artleap.ai/providers/onboarding_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_static_data.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/navigation/navigation.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  static const String routeName = 'onboarding_screen';
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    ref.read(onboardingProvider).startAutoPageView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: ref.watch(onboardingProvider).pageController,
              onPageChanged: (index) {
                ref.read(onboardingProvider).setOnboardingPageIndex(index);
              },
              itemBuilder: (context, index) {
                int actualIndex =
                    index % onboardingImagesList.length; // Handle looping
                double pageOffset = 0;
                double scale = (1 - (pageOffset.abs() * 0.2)).clamp(0.9, 1.0);
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          onboardingImagesList[actualIndex]["image"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 150),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 70,
                        width: 300,
                        child: Text(
                          onboardingImagesList[actualIndex]["text"],
                          textAlign: TextAlign.center,
                          style: AppTextstyle.interBold(
                              color: AppColors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ...onboardingImagesList.asMap().entries.map((entry) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 12,
                      width: 12,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          color: ref
                                      .watch(onboardingProvider)
                                      .onboardingPageIndex ==
                                  entry.key
                              ? AppColors.white
                              : AppColors.white.withOpacity(0.6),
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2,
                              color: ref
                                          .watch(onboardingProvider)
                                          .onboardingPageIndex ==
                                      entry.key
                                  ? AppColors.indigo
                                  : AppColors.white.withOpacity(0.6))),
                    ),
                  );
                }),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ContinueButton(
                    onpress: () {
                      Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
                      ref.read(onboardingProvider).stopAutoPageView();
                      // ref.read(onboardingProvider).pageController.dispose();
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
