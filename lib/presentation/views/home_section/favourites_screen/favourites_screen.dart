import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_background_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/favourites_screen/favourites_screen_widgets/result_container_widget.dart';
import 'package:Artleap.ai/presentation/views/home_section/favourites_screen/favourites_screen_widgets/results_text_dropdown_widget.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;
import '../../../../providers/add_image_to_fav_provider.dart';
import '../../../../providers/bottom_nav_bar_provider.dart';
import '../../../../shared/constants/app_colors.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favouriteState = ref.watch(favouriteProvider);
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          ref.read(bottomNavBarProvider).setPageIndex(0);
        }
      },
      child: AppBackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
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
                      ? Center(
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: AppColors.white,
                      size: 30,
                    ),
                  )
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

  Widget _buildEmptyState(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.15),
        // Animated gradient container
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6A11CB),
                Color(0xFF2575FC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withValues(),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: Center(
            child: Icon(
              Icons.favorite_border_rounded,
              size: 80,
              color: Colors.white.withValues(),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Animated text
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: value,
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              Text(
                'No Favorites Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.purple.withValues(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Start saving your favorite creations\nand they will appear here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // Shimmering button
        Shimmer.fromColors(
          baseColor: Colors.purple[300]!,
          highlightColor: Colors.blue[200]!,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to explore screen
              ref.read(bottomNavBarProvider).setPageIndex(1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.purple.withValues(),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
            ),
            child: const Text(
              'Explore Creations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}