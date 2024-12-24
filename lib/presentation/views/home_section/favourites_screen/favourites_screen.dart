import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/favourites_screen/favourites_screen_widgets/result_container_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/favourites_screen/favourites_screen_widgets/results_text_dropdown_widget.dart';
import 'package:photoroomapp/providers/favrourite_provider.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../providers/bottom_nav_bar_provider.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(favouriteProvider).fetchUserFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          ref.watch(bottomNavBarProvider).setPageIndex(0);
        }
      },
      child: AppBackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: RefreshIndicator(
            backgroundColor: AppColors.darkBlue,
            onRefresh: () {
              return ref.watch(favouriteProvider).fetchUserFavourites();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(), // Allows scroll refresh
              child: Column(
                children: [
                  // ResultsTextDropDownWidget(),
                  20.spaceY,
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                    future: ref.read(favouriteProvider).fetchUserFavourites(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: AppColors.white,
                            size: 30,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        DocumentSnapshot<Map<String, dynamic>>?
                            userFavouriteData = snapshot.data;

                        List<dynamic> favourites =
                            userFavouriteData?.data()?["favourites"] ?? [];

                        if (favourites.isEmpty) {
                          return Center(
                            child: Text(
                              "No data yet",
                              style: AppTextstyle.interBold(
                                fontSize: 15,
                                color: AppColors.white,
                              ),
                            ),
                          );
                        } else {
                          print(favourites.length);
                          print("hhhhhhhhhhh");
                          return ResultContainerWidget(
                            data: favourites,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
