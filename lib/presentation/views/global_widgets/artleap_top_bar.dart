import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_profile_provider.dart';

// Screen size category helper function
ScreenSizeCategory getScreenSizeCategory(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 375) return ScreenSizeCategory.extraSmall;
  if (width < 414) return ScreenSizeCategory.small;
  if (width < 600) return ScreenSizeCategory.medium;
  return ScreenSizeCategory.large;
}

enum ScreenSizeCategory { extraSmall, small, medium, large }

class ArtLeapTopBar extends ConsumerWidget {
  final String title;
  ArtLeapTopBar({super.key, this.title = 'Creation Studio'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credits = ref.watch(userProfileProvider).userProfileData?.user.totalCredits ?? 0;
    final screenSize = getScreenSizeCategory(context);

    // Adjust sizes based on screen category
    final topPadding = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 12.0 : 20.0;
    final horizontalPadding = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 2.0 : 5.0;
    final creditsContainerHeight = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 32.0 : 36.0;
    final creditsContainerWidth = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 60.0 : 70.0;
    final coinIconSize = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 16.0 : 18.0;
    final creditsFontSize = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 10.0 : 12.0;
    final buttonPadding = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final buttonTextSize = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 12.0 : 14.0;
    final proIconSize = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 24.0 : 30.0;
    final spaceBetween = screenSize == ScreenSizeCategory.small ||
        screenSize == ScreenSizeCategory.extraSmall
        ? 4.0 : 8.0;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: horizontalPadding, right: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              if(ref.watch(userProfileProvider).userProfileData?.user.planName.toLowerCase() != 'free'){
                Navigator.of(context).pushNamed("/subscription-status");
              }else{
                Navigator.of(context).pushNamed("choose_plan_screen");
              }
            },
            child: Container(
              height: creditsContainerHeight,
              width: creditsContainerWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1.2,
                ),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.stackofcoins,
                    height: coinIconSize,
                    color: Colors.amber[700],
                  ),
                  SizedBox(width: screenSize == ScreenSizeCategory.small ||
                      screenSize == ScreenSizeCategory.extraSmall
                      ? 2.0 : 3.0),
                  Text(
                    "$credits",
                    style: AppTextstyle.interMedium(
                      color: Colors.black,
                      fontSize: creditsFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),

          // Get Pro Button
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("choose_plan_screen");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF923CFF),
              padding: buttonPadding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(86),
              ),
              elevation: 0,
            ),
            child: Row(
              children: [
                Image.asset(
                  AppAssets.proBtn,
                  height: proIconSize,
                ),
                SizedBox(width: spaceBetween),
                Text(
                  "Get Pro",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: buttonTextSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}