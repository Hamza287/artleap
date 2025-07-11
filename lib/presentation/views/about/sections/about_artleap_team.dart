import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapTeamSection extends StatelessWidget {
  const AboutArtleapTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.lightBlue.withOpacity(0.1),
            AppColors.lightPurple.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Meet The Team',
            style: AppTextstyle.interBold(
              fontSize: 24,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: const [
              TeamMemberCard(
                name: 'Alex Chen',
                role: 'Founder & CEO',
                imagePath: 'assets/images/team/alex.jpg',
              ),
              TeamMemberCard(
                name: 'Maria Rodriguez',
                role: 'Lead AI Engineer',
                imagePath: 'assets/images/team/maria.jpg',
              ),
              TeamMemberCard(
                name: 'James Wilson',
                role: 'Creative Director',
                imagePath: 'assets/images/team/james.jpg',
              ),
              TeamMemberCard(
                name: 'Priya Patel',
                role: 'UX Designer',
                imagePath: 'assets/images/team/priya.jpg',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: AppColors.lightPurple.withOpacity(0.5),
                width: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: AppTextstyle.interBold(
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
          Text(
            role,
            style: AppTextstyle.interRegular(
              fontSize: 14,
              color: AppColors.darkBlue.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}