import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photoroomapp/presentation/views/global_widgets/app_background_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/favourites_screen/favourites_screen_widgets/result_container_widget.dart';
import 'package:photoroomapp/presentation/views/home_section/favourites_screen/favourites_screen_widgets/results_text_dropdown_widget.dart';
import 'package:photoroomapp/providers/favrourite_provider.dart';
import 'package:photoroomapp/shared/constants/user_data.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../providers/add_image_to_fav_provider.dart';
import '../../../../providers/bottom_nav_bar_provider.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';

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
    ref.read(favouriteProvider).getUserFav(UserData.ins.userId!);
    AnalyticsService.instance.logScreenView(screenName: 'favourite screen');
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
              return ref
                  .read(favouriteProvider)
                  .getUserFav(UserData.ins.userId!);
            },
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Allows scroll refresh
              child: Column(
                children: [
                  ResultsTextDropDownWidget(),
                  20.spaceY,
                  ref.watch(favouriteProvider).usersFavourites == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                          ),
                        )
                      : ResultContainerWidget(
                          data: ref
                              .watch(favouriteProvider)
                              .usersFavourites!
                              .favorites,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
