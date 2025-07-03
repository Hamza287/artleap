import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  static const routeName = '/help-screen';
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@mimarstudios.com',
      queryParameters: {
        'subject': 'Artleap App Support Request',
        'body': 'Hello Mimar Studios team,\n\nI need help with...',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text(
          'Help Center',
          style: AppTextstyle.interBold(color: AppColors.white),
        ),
        backgroundColor: AppColors.darkBlue,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: AppTextstyle.interBold(
                color: AppColors.white,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            _buildFAQItem(
              question: 'How do I create a new artwork?',
              answer: 'Tap the "+" button on the home screen to start a new creation. Select your canvas size and begin painting with our tools.',
            ),
            _buildFAQItem(
              question: 'Where are my saved artworks stored?',
              answer: 'All your artworks are saved in the "My Gallery" section. You can access them anytime from the bottom navigation.',
            ),
            _buildFAQItem(
              question: 'How do I share my artwork?',
              answer: 'Open any artwork and tap the share icon. You can share directly to social media or save to your device.',
            ),
            _buildFAQItem(
              question: 'What subscription options are available?',
              answer: 'We offer monthly and yearly subscriptions. Go to "Account" > "Subscription" to view available plans.',
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _launchEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Contact Support',
                  style: AppTextstyle.interMedium(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Mimar Studios Team',
              style: AppTextstyle.interRegular(
                color: AppColors.white.withValues(),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTextstyle.interMedium(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: AppTextstyle.interRegular(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(
            color: AppColors.greyBlue,
            height: 1,
          ),
        ],
      ),
    );
  }
}