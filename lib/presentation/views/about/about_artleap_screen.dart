import 'package:Artleap.ai/presentation/views/about/sections/about_artleap_team.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

import 'sections/about_artleap_contact.dart';
import 'sections/about_artleap_footer.dart';
import 'sections/about_artleap_hero.dart';
import 'sections/about_artleap_mission.dart';
import 'sections/about_artleap_technology.dart';

class AboutArtleapScreen extends StatelessWidget {
  static const routeName = '/about-artleap';

  const AboutArtleapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              const AboutArtleapHeroSection(),
        
              // Mission Section
              const AboutArtleapMissionSection(),
        
              // Team Section
              // const AboutArtleapTeamSection(),
        
              // Technology Section
              const AboutArtleapTechnologySection(),
        
              // Contact Section
              const AboutArtleapContactSection(),
        
              // Footer
              const AboutArtleapFooter(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'About Artleap',
        style: AppTextstyle.interBold(
          fontSize: 20,
          color: AppColors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.darkBlue,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
    );
  }
}