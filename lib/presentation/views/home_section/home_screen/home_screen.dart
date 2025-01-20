import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen_widgets/trending_creations_widget.dart';
import 'package:photoroomapp/providers/generate_image_provider.dart';
import 'package:photoroomapp/providers/home_screen_provider.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';
import '../../../../providers/favrourite_provider.dart';
import '../../../../providers/user_profile_provider.dart';
import '../../../google_ads/interstetial_ad.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = 'home_screen';
  const HomeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final interstitialManager = InterstitialAdManager()..loadInterstitialAd();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeScreenProvider).getDeviceTokekn();
      ref.read(homeScreenProvider).getUserCreations();
      ref.read(homeScreenProvider).requestPermission();
      ref.read(userProfileProvider).getUserProfiledata();
      ref.read(favouriteProvider).fetchUserFavourites();
      ref.read(generateImageProvider).creditsCheckAndBalance();
      ref.read(generateImageProvider).clearVarData();
    });
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
                  title: const Text('Confirm Exit'),
                  content: const Text('Are you sure you want to leave?'),
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
      child: AppBackgroundWidget(
          widget: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6),
        child: RefreshIndicator(
          backgroundColor: AppColors.darkBlue,
          onRefresh: () {
            return ref.watch(homeScreenProvider).getUserCreations();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [10.spaceY, 15.spaceY, const TrendingCreationsWidget()],
            ),
          ),
        ),
      )),
    );
  }
}
