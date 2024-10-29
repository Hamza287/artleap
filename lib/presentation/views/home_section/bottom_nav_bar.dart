import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/base_widgets/common_appbar.dart';
import 'package:photoroomapp/presentation/views/home_section/favourites_screen/favourites_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_or_ref_screen.dart';
import 'package:photoroomapp/providers/bottom_nav_bar_provider.dart';
import 'package:photoroomapp/providers/user_profile_provider.dart';
import 'package:photoroomapp/shared/constants/user_data.dart';
import 'package:photoroomapp/shared/shared.dart';

import '../../../providers/home_screen_provider.dart';
import '../global_widgets/search_textfield.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  static const String routeName = "bottom_nav_bar_screen";

  const BottomNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(homeScreenProvider).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
        } else {
          bool shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.blue,
                  title: Text('Confirm Exit'),
                  content: Text('Are you sure you want to leave?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'No',
                        style: AppTextstyle.interBold(color: AppColors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Yes',
                        style: AppTextstyle.interBold(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ) ??
              false;

          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
            appBar: CommonAppBar(
              title: ref.watch(bottomNavBarProvider).pageIndex == 1
                  ? "Image Generation"
                  : ref.watch(bottomNavBarProvider).pageIndex == 2
                      ? "Your Favourites"
                      : "",
              listOfColors: ref.watch(bottomNavBarProvider).pageIndex == 3
                  ? [AppColors.lightIndigo, AppColors.darkIndigo]
                  : [AppColors.darkBlue, AppColors.darkBlue],
              actions: [
                if (ref.watch(bottomNavBarProvider).pageIndex == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const SearchTextfield(),
                  ),
                if (ref.watch(bottomNavBarProvider).pageIndex == 0) 20.spaceX,
                // if (ref.watch(bottomNavBarProvider).pageIndex == 0)
                //   Padding(
                //     padding: const EdgeInsets.only(right: 20, top: 10),
                //     child: Image.asset(
                //       AppAssets.notificationicon,
                //       scale: 2,
                //     ),
                //   )
              ],
            ),
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Container(
              height: 55,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.lightBlue, AppColors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      ref.watch(bottomNavBarProvider).setPageIndex(0);
                    },
                    child: SizedBox(
                      height: 55,
                      width: 40,
                      child: Center(
                          child: Icon(
                        Icons.home,
                        size: 30,
                        color: ref.watch(bottomNavBarProvider).pageIndex == 0
                            ? AppColors.white
                            : AppColors.lightgrey,
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.watch(bottomNavBarProvider).setPageIndex(1);
                    },
                    child: SizedBox(
                      height: 55,
                      width: 40,
                      child: Center(
                          child: Icon(
                        Icons.add,
                        size: 30,
                        color: ref.watch(bottomNavBarProvider).pageIndex == 1
                            ? AppColors.white
                            : AppColors.lightgrey,
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.watch(bottomNavBarProvider).setPageIndex(2);
                    },
                    child: SizedBox(
                      height: 55,
                      width: 40,
                      child: Center(
                          child: Icon(
                        Icons.favorite,
                        size: 30,
                        color: ref.watch(bottomNavBarProvider).pageIndex == 2
                            ? AppColors.white
                            : AppColors.lightgrey,
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.watch(bottomNavBarProvider).setPageIndex(3);
                    },
                    child: ref.watch(userProfileProvider).userPersonalData ==
                            null
                        ? Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.darkIndigo,
                            ),
                          )
                        : ref
                                    .watch(userProfileProvider)
                                    .userPersonalData!["profile_image"] !=
                                null
                            ? Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(ref
                                                .watch(userProfileProvider)
                                                .userPersonalData![
                                            "profile_image"])),
                                    shape: BoxShape.circle,
                                    color: AppColors.white),
                              )
                            : Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(AppAssets.artstyle1),
                                    ),
                                    shape: BoxShape.circle,
                                    color: AppColors.white),
                              ),
                  ),
                ],
              ),
            ),
            body: ref
                .watch(bottomNavBarProvider)
                .widgets[ref.watch(bottomNavBarProvider).pageIndex]),
      ),
    );
  }
}
