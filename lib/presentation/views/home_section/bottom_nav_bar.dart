import 'dart:ui';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../shared/constants/user_data.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  static const String routeName = "bottom_nav_bar_screen";

  const BottomNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_initialized) return;
      _initialized = true;
      final userId = (AppData.instance.userId?.trim().isNotEmpty ?? false)
          ? AppData.instance.userId!.trim()
          : (UserData.ins.userId ?? '').trim();
      if (userId.isEmpty) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
        return;
      }
      await ref.read(userProfileProvider).getUserProfileData(userId);
    });
  }

  // Widget _buildProfilePicture() {
  //   final userProfileState = ref.watch(userProfileProvider);

  //   if (userProfileState.isloading) {
  //     return const SizedBox(
  //       height: 35,
  //       width: 35,
  //       child: Center(
  //         child: CircularProgressIndicator(
  //           color: AppColors.indigo,
  //           strokeWidth: 2,
  //         ),
  //       ),
  //     );
  //   }

  //   final profilePic = userProfileState.userProfileData?.user.profilePic;

  //   if (profilePic != null && profilePic.isNotEmpty) {
  //     return Container(
  //       height: 35,
  //       width: 35,
  //       decoration: BoxDecoration(
  //         image: DecorationImage(
  //           image: NetworkImage(profilePic),
  //           fit: BoxFit.cover,
  //         ),
  //         shape: BoxShape.circle,
  //         color: AppColors.white,
  //         border: Border.all(
  //           color: ref.watch(bottomNavBarProvider).pageIndex == 3
  //               ? const Color(0xFFAB8AFF) // Purple when selected
  //               : AppColors.darkBlue, // Dark blue when unselected
  //           width: 2,
  //         ),
  //       ),
  //     );
  //   }

  //   // Default profile picture
  //   return Container(
  //     height: 35,
  //     width: 35,
  //     decoration: BoxDecoration(
  //       image: const DecorationImage(
  //         image: AssetImage(AppAssets.artstyle1),
  //         fit: BoxFit.cover,
  //       ),
  //       shape: BoxShape.circle,
  //       color: AppColors.white,
  //       border: Border.all(
  //         color: ref.watch(bottomNavBarProvider).pageIndex == 3
  //             ? const Color(0xFFAB8AFF) // Purple when selected
  //             : AppColors.darkBlue, // Dark blue when unselected
  //         width: 2,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final bottomNavBarState = ref.watch(bottomNavBarProvider);
    final pageIndex = bottomNavBarState.pageIndex;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10.0,
                  sigmaY: 10.0,
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
                      icon: Icons.add_circle,
                      index: 1,
                      currentIndex: pageIndex,
                      onTap: () => ref.read(bottomNavBarProvider).setPageIndex(1),
                    ),
                    _buildNavButton(
                      icon: Icons.groups,
                      index: 2,
                      currentIndex: pageIndex,
                      onTap: () => ref.read(bottomNavBarProvider).setPageIndex(2),
                    ),
                    _buildNavButton(
                      icon: Icons.person,
                      index: 3,
                      currentIndex: pageIndex,
                      onTap: () => ref.read(bottomNavBarProvider).setPageIndex(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: (pageIndex >= 0 && pageIndex < bottomNavBarState.widgets.length)
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
            size: 33,
            color: currentIndex == index
                ? const Color(0xFFAB8AFF)
                : AppColors.darkBlue,
          ),
        ),
      ),
    );
  }
}