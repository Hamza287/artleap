import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapTeamSection extends StatelessWidget {
  const AboutArtleapTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.1),
            theme.colorScheme.secondaryContainer.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Meet The Team',
            style: AppTextstyle.interBold(
              fontSize: 24,
              color: theme.colorScheme.onSurface,
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
                imagePath: 'assets/images/photo.jpg',
              ),
              TeamMemberCard(
                name: 'Maria Rodriguez',
                role: 'Lead AI Engineer',
                imagePath: 'assets/images/photo.jpg',
              ),
              TeamMemberCard(
                name: 'James Wilson',
                role: 'Creative Director',
                imagePath: 'assets/images/photo.jpg',
              ),
              TeamMemberCard(
                name: 'Priya Patel',
                role: 'UX Designer',
                imagePath: 'assets/images/photo.jpg',
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
    final theme = Theme.of(context);
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
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: AppTextstyle.interBold(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            role,
            style: AppTextstyle.interRegular(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}