import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen_sections/home_screen_search_bar.dart';
import 'package:Artleap.ai/presentation/views/home_section/home_screen/home_screen_sections/home_screen_top_bar.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'home_screen_sections/ai_filters_grid.dart';
import 'home_screen_sections/filter_of_day_widget.dart';
import 'home_screen_sections/potrait_options.dart';
import 'home_screen_sections/promo_banner.dart';
import 'home_screen_sections/prompt_templates.dart';
import 'home_screen_sections/trending_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeScreenTopBar(),
              SizedBox(height: 12),
              HomeScreenSearchBar(),
              SizedBox(height: 20),
              FilterOfTheDay(),
              SizedBox(height: 24),
              PortraitOptions(),
              SizedBox(height: 24),
              AiFiltersGrid(),
              SizedBox(height: 24),
              TrendingStyles(),
              SizedBox(height: 24),
              PromptTemplates(),
              SizedBox(height: 24),
              PromoBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
