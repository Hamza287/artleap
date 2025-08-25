import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_colors.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:intl/intl.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const routeName = '/privacy-policy';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.lightBlue.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 32),
                _buildPolicyContent(),
                const SizedBox(height: 24),
                _buildFooterSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Privacy Policy',
        style: AppTextstyle.interBold(
          fontSize: 20,
          color: AppColors.darkBlue,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.white,
      iconTheme: const IconThemeData(color: AppColors.darkBlue),
      elevation: 0,
      scrolledUnderElevation: 4,
      shadowColor: AppColors.darkBlue.withOpacity(0.1),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Privacy Policy',
          style: AppTextstyle.interBold(
            fontSize: 32,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Effective Date: January 1, 2025',
          style: AppTextstyle.interRegular(
            fontSize: 14,
            color: AppColors.darkBlue.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.lightBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'At ArtLeap.AI, we value your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our photo generator AI application ("App"). By using the App, you agree to the practices outlined in this policy.',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyContent() {
    return Column(
      children: [
        _buildPolicySection(
          icon: Icons.collections_bookmark,
          title: "1. Information We Collect",
          content: """
1.1 Personal Information

Account Details: If you register an account, we may collect your name, email address, and other optional profile information.

Payment Information: If you make in-app purchases, your payment is securely processed by a third-party billing platform. We do not store or access your payment details.

1.2 Uploaded Content

User Content: Any images or photos you upload for AI processing are temporarily processed and not stored longer than necessary to deliver the service.

1.3 Device and Usage Data

Device Details: We may collect data such as device model, operating system version, app version, and device identifiers to ensure optimal performance.

Usage Logs: We collect information about your interactions with the App, such as features used and error reports, to improve functionality.

1.4 Analytics and Tracking

We may use anonymous cookies or similar technologies to analyze user behavior and enhance your experience with the App. These tools help us understand usage trends and optimize features.
""",
        ),
        _buildPolicySection(
          icon: Icons.analytics,
          title: "2. How We Use Your Information",
          content: """
We use collected information to:

• Operate and enhance the App's performance and features.
• Process your content and deliver AI-generated results.
• Provide user support and respond to inquiries.
• Customize user experience and show relevant features.
• Comply with legal and policy requirements.
""",
        ),
        _buildPolicySection(
          icon: Icons.share,
          title: "3. Sharing of Information",
          content: """
We do not sell or rent your personal information. We may share limited data with:

• Trusted service providers who help us operate, maintain, and improve the App.
• Legal authorities, only when required to comply with applicable laws or to protect rights and safety.
""",
        ),
        _buildPolicySection(
          icon: Icons.security,
          title: "4. Data Security",
          content: """
We implement industry-standard security practices to protect your information, including encryption, secure data storage, and access controls. While we strive to protect all user data, no digital system is completely immune to risks.
""",
        ),
        _buildPolicySection(
          icon: Icons.person_outline,
          title: "5. Your Rights",
          content: """
Depending on your location, you may have the right to:

• Access your personal data.
• Update or correct inaccurate information.
• Request deletion of your account or data.
• Disable analytics or tracking features in your device or app settings.

To exercise your rights, please contact us at info@x-r.digital.
""",
        ),
        _buildPolicySection(
          icon: Icons.storage,
          title: "6. Data Retention",
          content: """
• Uploaded images are stored temporarily and deleted after processing.
• Other data is retained only as long as needed for operational, legal, or business purposes.
""",
        ),
        _buildPolicySection(
          icon: Icons.child_care,
          title: "7. Children's Privacy",
          content: """
The App is not intended for children under 13. We do not knowingly collect personal information from anyone under this age. If such data is identified, it will be promptly deleted.
""",
        ),
        _buildPolicySection(
          icon: Icons.update,
          title: "8. Policy Updates",
          content: """
We may update this Privacy Policy to reflect changes to our features or legal requirements. Any updates will be posted within the App. Your continued use of the App indicates acceptance of the updated policy.
""",
        ),
        _buildPolicySection(
          icon: Icons.contact_support,
          title: "9. Contact Us",
          content: """
For any privacy-related inquiries or concerns, please reach out to us:

📧 Email: info@x-r.digital
""",
        ),
      ],
    );
  }

  Widget _buildPolicySection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightBlue.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.darkBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextstyle.interBold(
                      fontSize: 20,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                content,
                style: AppTextstyle.interRegular(
                  fontSize: 15,
                  color: AppColors.darkBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: AppColors.lightBlue,
          thickness: 0.5,
          height: 1,
        ),
        const SizedBox(height: 24),
        Text(
          'By using ArtLeap.AI, you acknowledge that you have read and understood this Privacy Policy.',
          style: AppTextstyle.interRegular(
            fontSize: 14,
            color: AppColors.darkBlue.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          '© ${DateTime.now().year} ArtLeap.AI\nAll rights reserved.',
          style: AppTextstyle.interRegular(
            fontSize: 12,
            color: AppColors.darkBlue.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
