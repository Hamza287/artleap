import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/base_widgets/common_appbar.dart';
import 'package:Artleap.ai/providers/ads_provider.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../providers/generate_image_provider.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../providers/home_screen_provider.dart';
import '../../../shared/constants/user_data.dart';
import '../../google_ads/banner_ad.dart';
import '../../google_ads/native_add.dart';
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
    // NativeAdWidget.instance.loadNativeAd();
    // InterstitialAdManager.instance.loadInterstitialAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(userProfileProvider)
          .getUserProfileData(UserData.ins.userId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              // if (ref.watch(bottomNavBarProvider).pageIndex == 0)
              //   const Expanded(
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: EdgeInsets.only(left: 10),
              //           child: BannerAdWidget(),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(top: 5, left: 15),
              //           child: SearchTextfield(),
              //         ),
              //       ],
              //     ),
              //   ),
              // if (ref.watch(bottomNavBarProvider).pageIndex == 0) 20.spaceX,

              // if (ref.watch(bottomNavBarProvider).pageIndex == 0)
              //   Padding(
              //     padding: const EdgeInsets.only(right: 20, top: 10),
              //     child: Image.asset(
              //       AppAssets.notificationicon,
              //       scale: 2,
              //     ),
              //   )
            ],
            bottomWidget: ref.watch(bottomNavBarProvider).pageIndex == 0
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: BannerAdWidget(),
                      ),
                      5.spaceY,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: SearchTextfield(),
                      ),
                    ],
                  )
                : null,
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
                    child: ref.watch(userProfileProvider).isloading
                        ? const CircularProgressIndicator(
                            color: AppColors.indigo,
                          )
                        : ref
                                .watch(userProfileProvider)
                                .userProfileData!
                                .user
                                .profilePic
                                .isEmpty
                            ? Container(
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(AppAssets.artstyle1),
                                    ),
                                    shape: BoxShape.circle,
                                    color: AppColors.white),
                              )
                            : Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(ref
                                            .watch(userProfileProvider)
                                            .userProfileData!
                                            .user
                                            .profilePic)),
                                    shape: BoxShape.circle,
                                    color: AppColors.white),
                              )),
              ],
            ),
          ),
          body: ref
              .watch(bottomNavBarProvider)
              .widgets[ref.watch(bottomNavBarProvider).pageIndex]),
    );
  }
}
