import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen_sections/home_screen_search_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen_sections/home_screen_top_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/user_profile_provider.dart';
import '../../common/profile_drawer.dart';
import 'home_screen_sections/ai_filters_grid.dart';
import 'home_screen_sections/filter_of_day_widget.dart';
import 'home_screen_sections/potrait_options.dart';
import 'home_screen_sections/promo_banner.dart';
import 'home_screen_sections/prompt_templates.dart';
import 'home_screen_sections/trending_styles.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).userProfileData?.user;
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
              HomeScreenTopBar( onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),),
              const SizedBox(height: 12),
              const HomeScreenSearchBar(),
              const SizedBox(height: 20),
              const FilterOfTheDay(),
              const SizedBox(height: 24),
              const PortraitOptions(),
              const SizedBox(height: 24),
              const AiFiltersGrid(),
              const SizedBox(height: 24),
              const TrendingStyles(),
              const SizedBox(height: 24),
              const PromptTemplates(),
              const SizedBox(height: 24),
              const PromoBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
