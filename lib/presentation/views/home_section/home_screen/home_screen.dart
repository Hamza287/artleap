import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen_sections/home_screen_search_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen_sections/home_screen_top_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/bottom_nav_bar_provider.dart';
import '../../../../providers/refresh_provider.dart';
import '../../../../providers/user_profile_provider.dart';
import '../../../../shared/constants/user_data.dart';
import '../../common/profile_drawer.dart';
import 'home_screen_sections/prompt_templates.dart';
import 'home_screen_sections/trending_styles.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider).updateUserCredits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).userProfileData?.user;
    final shouldRefresh = ref.watch(refreshProvider);
    final bottomNavBarState = ref.watch(bottomNavBarProvider);
    final pageIndex = bottomNavBarState.pageIndex;

    if (shouldRefresh && UserData.ins.userId != null) {
      Future.microtask(() {
        ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId!);
      });
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      key: _scaffoldKey,
      drawer: ProfileDrawer(
        profileImage: userProfile?.profilePic ?? '',
        userName: userProfile?.username ?? 'Guest',
        userEmail: userProfile?.email ?? 'guest@example.com',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeScreenTopBar(
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const SizedBox(height: 12),
              const HomeScreenSearchBar(),
              const SizedBox(height: 20),
              _buildCard(
                "Generate Image",
                "Let's create magic and bring your imagination to life.",
                "Create Magic",
                'assets/images/image_generate_dumy.png',
                Color(0xFFB352FF),
                () => ref.read(bottomNavBarProvider).setPageIndex(1),
                Colors.white,
              ),
              SizedBox(height: 20),
              _buildCard(
                "Community",
                "Explore community and follow what others have created",
                "Explore Community",
                'assets/images/community_dumy.png',
                Color(0xFFDBADFF),
                () => ref.read(bottomNavBarProvider).setPageIndex(2),
                Colors.black,
              ),
              // const FilterOfTheDay(),
              const SizedBox(height: 24),
              // const PortraitOptions(),
              const SizedBox(height: 24),
              // const AiFiltersGrid(),
              const SizedBox(height: 24),
              const TrendingStyles(),
              const SizedBox(height: 24),
              const PromptTemplates(),
              const SizedBox(height: 24),
              // const PromoBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, String buttonText,
      String image, Color color, VoidCallback onTap, Color btnTextColor) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 260,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.white, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 16.0, color: btnTextColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
