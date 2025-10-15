import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/app_background_widget.dart';
import 'package:Artleap.ai/providers/add_image_to_fav_provider.dart';
import 'package:Artleap.ai/providers/user_profile_provider.dart';
import 'package:Artleap.ai/providers/home_screen_provider.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/constants/user_data.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/search_textfield.dart';
import '../../../../widgets/common_appbar.dart';
import 'community_screen_widgets/trending_creations_widget.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  static const String routeName = 'community_screen';
  const CommunityScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favouriteProvider).getUserFav(UserData.ins.userId ?? "");
      ref.read(userProfileProvider).updateUserCredits();
      ref.read(homeScreenProvider).getUserInfo();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !ref.watch(homeScreenProvider).isLoadingMore) {
        ref.read(homeScreenProvider).loadMoreImages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getAppBarTitle(int pageIndex) {
    switch (pageIndex) {
      case 1:
        return "Image Generation";
      case 2:
        return "Your Favourites";
      default:
        return "";
    }
  }

  List<Color> _getAppBarColors(int pageIndex) {
    return pageIndex == 3
        ? [AppColors.lightIndigo, AppColors.darkIndigo]
        : [AppColors.darkBlue, AppColors.darkBlue];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        bool shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.blue,
                title: const Text('Confirm Exit'),
                content: const Text('Are you sure you want to leave?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('No',
                        style: AppTextstyle.interBold(color: AppColors.white)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Yes',
                        style: AppTextstyle.interBold(color: AppColors.white)),
                  ),
                ],
              ),
            ) ??
            false;
        if (shouldExit) SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: _getAppBarTitle(0),
          listOfColors: _getAppBarColors(0),
          bottomWidget: Column(
            children: [
              10.spaceY,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SearchTextfield(),
              ),
            ],
          ),
        ),
        body: AppBackgroundWidget(
          widget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: RefreshIndicator(
              backgroundColor: AppColors.darkBlue,
              onRefresh: () => ref.read(homeScreenProvider).getUserCreations(),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.spaceY,
                    const TrendingCreationsWidget(),
                    if (ref.watch(homeScreenProvider).isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
