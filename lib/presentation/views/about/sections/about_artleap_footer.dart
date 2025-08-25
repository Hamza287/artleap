import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class AboutArtleapFooter extends StatelessWidget {
  const AboutArtleapFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      width: double.infinity,
      color: AppColors.darkBlue,
      child: Column(
        children: [
          Image.asset(
            'assets/icons/logo.png',
            height: 60,
          ),
          const SizedBox(height: 24),
          Text(
            'Artleap - Where Creativity Meets AI',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _buildSocialIcon(Icons.facebook),
          //     const SizedBox(width: 16),
          //     _buildSocialIcon(Icons.face),
          //     const SizedBox(width: 16),
          //     _buildSocialIcon(Icons.face),
          //     const SizedBox(width: 16),
          //     _buildSocialIcon(Icons.face),
          //   ],
          // ),
          // const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} Xr Digital. All rights reserved.',
            style: AppTextstyle.interRegular(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
    );
  }
}