import 'package:Artleap.ai/presentation/views/home_section/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_background_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/favourites_screen/favourites_screen_widgets/result_container_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/favourites_screen/favourites_screen_widgets/results_text_dropdown_widget.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../providers/add_image_to_fav_provider.dart';
import '../../../../providers/bottom_nav_bar_provider.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_textstyle.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  static const String routeName = 'favourite-screen';
  const FavouritesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favouriteState = ref.watch(favouriteProvider);
    final size = MediaQuery.of(context).size;
    final bottomNavBarState = ref.watch(bottomNavBarProvider);
    final pageIndex = bottomNavBarState.pageIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: AppBackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: RefreshIndicator(
            backgroundColor: AppColors.darkBlue,
            onRefresh: () async {
              try {
                await ref.read(favouriteProvider).getUserFav(UserData.ins.userId!);
              } catch (e) {
                debugPrint('Refresh error: $e');
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ResultsTextDropDownWidget(),
                  20.spaceY,
                  favouriteState.isLoading
                      ? _buildShimmerLoading(size)
                      : favouriteState.usersFavourites == null ||
                      favouriteState.usersFavourites!.favorites.isEmpty
                      ? _buildEmptyState(size)
                      : ResultContainerWidget(
                    data: favouriteState.usersFavourites!.favorites,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 50,
            width: size.width * 0.8,
            color: Colors.white,
          ),
          20.spaceY,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1,
            ),
            itemCount: 6, // Simulate 6 items
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.1),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 60,
                  color: AppColors.darkBlue,
                ),
                const SizedBox(height: 20),
                Text(
                  'No Favorites Yet',
                  style: AppTextstyle.interBold(
                    fontSize: 22,
                    color: AppColors.darkBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Save your favorite creations from the explore section,\nand they will appear here.',
                  textAlign: TextAlign.center,
                  style: AppTextstyle.interRegular(
                    fontSize: 14,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    ref.read(bottomNavBarProvider).setPageIndex(1);
                    await Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Explore Creations',
                    style: AppTextstyle.interBold(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}