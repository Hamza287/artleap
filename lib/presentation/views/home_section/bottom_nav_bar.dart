import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/base_widgets/common_appbar.dart';
import 'package:Artleap.ai/providers/ads_provider.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../providers/generate_image_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../providers/home_screen_provider.dart';
import '../../../shared/constants/user_data.dart';
import '../../google_ads/banner_ad.dart';
import '../../google_ads/native_add.dart';
import '../Notifications/notification_screen.dart';
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserData.ins.userId;
      if (userId != null && userId.isNotEmpty) {
        ref.read(userProfileProvider).getUserProfileData(userId);
      }
    });
  }

  Widget _buildProfilePicture() {
    final userProfileState = ref.watch(userProfileProvider);

    if (userProfileState.isloading) {
      return const SizedBox(
        height: 35,
        width: 35,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.indigo,
            strokeWidth: 2,
          ),
        ),
      );
    }

    final profilePic = userProfileState.userProfileData?.user.profilePic;

    if (profilePic != null && profilePic.isNotEmpty) {
      return Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(profilePic),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
      );
    }

    // Default profile picture
    return Container(
      height: 35,
      width: 35,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.artstyle1),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
        color: AppColors.white,
      ),
    );
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
    final bottomNavBarState = ref.watch(bottomNavBarProvider);
    final pageIndex = bottomNavBarState.pageIndex;

    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          title: _getAppBarTitle(pageIndex),
          listOfColors: _getAppBarColors(pageIndex),
          actions:  [
            Consumer(
              builder: (context, ref, _) {
                final unreadCount = ref.watch(notificationProvider)
                    .where((n) => !n.isRead)
                    .length;

                return IconButton(
                  icon: Badge(
                    label: unreadCount > 0 ? Text(unreadCount.toString()) : null,
                    child: const Icon(
                      Icons.notifications,
                      color: AppColors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                        context,
                        NotificationScreen.routeName
                    );
                  },
                );
              },
            ),
          ],
          bottomWidget: pageIndex == 0
              ? Column(
            children: [
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 15),
              //   child: BannerAdWidget(),
              // ),
              5.spaceY,
              const Padding(
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
              _buildNavButton(
                icon: Icons.home,
                index: 0,
                currentIndex: pageIndex,
                onTap: () => ref.read(bottomNavBarProvider).setPageIndex(0),
              ),
              _buildNavButton(
                icon: Icons.add,
                index: 1,
                currentIndex: pageIndex,
                onTap: () => ref.read(bottomNavBarProvider).setPageIndex(1),
              ),
              _buildNavButton(
                icon: Icons.favorite,
                index: 2,
                currentIndex: pageIndex,
                onTap: () => ref.read(bottomNavBarProvider).setPageIndex(2),
              ),
              InkWell(
                onTap: () => ref.read(bottomNavBarProvider).setPageIndex(3),
                child: _buildProfilePicture(),
              ),
            ],
          ),
        ),
        body: (pageIndex >= 0 &&
            pageIndex < bottomNavBarState.widgets.length)
            ? bottomNavBarState.widgets[pageIndex]
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 55,
        width: 40,
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: currentIndex == index
                ? AppColors.white
                : AppColors.lightgrey,
          ),
        ),
      ),
    );
  }
}