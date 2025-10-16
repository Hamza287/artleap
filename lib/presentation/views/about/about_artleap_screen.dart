import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'sections/about_artleap_contact.dart';
import 'sections/about_artleap_footer.dart';
import 'sections/about_artleap_hero.dart';
import 'sections/about_artleap_mission.dart';
import 'sections/about_artleap_team.dart';
import 'sections/about_artleap_technology.dart';

class AboutArtleapScreen extends StatelessWidget {
  static const routeName = '/about-artleap';

  const AboutArtleapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(theme),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AboutArtleapHeroSection(),
              const AboutArtleapMissionSection(),
              const AboutArtleapTeamSection(),
              const AboutArtleapTechnologySection(),
              const AboutArtleapContactSection(),
              const AboutArtleapFooter(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(
        'About Artleap',
        style: AppTextstyle.interBold(
          fontSize: 20,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      centerTitle: true,
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
    );
  }
}