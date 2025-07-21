import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  static const routeName = '/help-screen';

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool _isSendingEmail = false;

  Future<void> _launchEmail() async {
    if (_isSendingEmail) return;

    setState(() => _isSendingEmail = true);

    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'info@x-r.digital',
        queryParameters: {
          'subject': 'Artleap App Support Request',
          'body': 'Hello Mimar Studios team,\n\nI need help with...',
        },
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Email client not found';
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('not found')
                ? 'No email app installed'
                : 'Failed to open email',
            style: AppTextstyle.interRegular(color: AppColors.white),
          ),
          backgroundColor: AppColors.redColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(20),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingEmail = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text(
          'Help Center',
          style: AppTextstyle.interBold(
            color: AppColors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with decorative element
            _buildSectionHeader('Need Help?'),
            const SizedBox(height: 10),
            Text(
              'We\'re here to assist you with any questions or issues you might have.',
              style: AppTextstyle.interRegular(
                color: AppColors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 30),

            // FAQ Section
            _buildSectionHeader('Frequently Asked Questions'),
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

            // Contact Section
            const SizedBox(height: 40),
            _buildSectionHeader('Still Need Help?'),
            const SizedBox(height: 15),
            Text(
              'Our support team is ready to help you with any questions or issues.',
              style: AppTextstyle.interRegular(
                color: AppColors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 25),

            Center(
              child: ElevatedButton.icon(
                onPressed: _isSendingEmail ? null : _launchEmail,
                icon: _isSendingEmail
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
                    : const Icon(Icons.email_outlined, size: 20),
                label: Text(
                  _isSendingEmail ? 'Opening...' : 'Contact Support',
                  style: AppTextstyle.interMedium(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPurple,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  shadowColor: AppColors.lightPurple.withOpacity(0.3),
                ),
              ),
            ),

            // Footer
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Text(
                    'Mimar Studios Team',
                    style: AppTextstyle.interMedium(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'We appreciate your feedback',
                    style: AppTextstyle.interRegular(
                      color: AppColors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: AppTextstyle.interBold(
        color: AppColors.white,
        fontSize: 18,
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greyBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTextstyle.interMedium(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: AppTextstyle.interRegular(
                color: AppColors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        iconColor: AppColors.lightPurple,
        collapsedIconColor: AppColors.lightPurple,
      ),
    );
  }
}