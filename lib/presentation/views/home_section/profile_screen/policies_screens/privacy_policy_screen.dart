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
        decoration: _buildBackgroundDecoration(),
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
          color: AppColors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.darkBlue,
      iconTheme: const IconThemeData(color: AppColors.white),
      elevation: 0,
      scrolledUnderElevation: 4,
      shadowColor: AppColors.darkBlue.withValues(),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.darkBlue, AppColors.purple],
        stops: [0.1, 0.9],
      ),
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
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Last updated: ${DateFormat('MMMM d, y').format(DateTime.now())}',
          style: AppTextstyle.interRegular(
            fontSize: 14,
            color: AppColors.lightgrey,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkBlue.withValues(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.lightPurple.withValues(),
              width: 1,
            ),
          ),
          child: Text(
            'Mimar Technologies Inc. ("we", "us", "our") is committed to protecting your privacy. This policy explains how we collect, use, and safeguard your information in our Artleap AI image generation application.',
            style: AppTextstyle.interRegular(
              fontSize: 16,
              color: AppColors.white.withValues(),
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
We collect various types of information to provide and improve our services:

• Account Information: Email, username, and profile details
• Content Data: Images you generate and associated prompts
• Technical Data: Device information, IP address, and usage metrics
• Transaction Data: Payment information for premium features
• Analytics: Usage patterns and feature interactions
""",
        ),
        _buildPolicySection(
          icon: Icons.analytics,
          title: "2. How We Use Your Information",
          content: """
Your data helps us:

• Deliver and enhance our AI services
• Personalize your creative experience
• Process transactions securely
• Protect against misuse and fraud
• Comply with legal requirements
• Research and develop new features
""",
        ),
        _buildPolicySection(
          icon: Icons.share,
          title: "3. Data Sharing & Disclosure",
          content: """
We may share information with:

• Trusted service providers (cloud hosting, analytics)
• Legal authorities when legally required
• Mimar affiliates for service optimization
• Third parties with your explicit consent

We do not sell your personal data to advertisers.
""",
        ),
        _buildPolicySection(
          icon: Icons.auto_awesome,
          title: "4. AI-Generated Content",
          content: """
• Your generated images are stored temporarily for app functionality
• You maintain full ownership of your creations
• Anonymized data may train our AI models (no personal association)
• Content is reviewed only for compliance with our policies
""",
        ),
        _buildPolicySection(
          icon: Icons.security,
          title: "5. Data Security",
          content: """
Our security measures include:

• AES-256 encryption for data in transit
• Regular penetration testing
• Strict access controls
• SOC 2 compliant infrastructure
• Annual security audits

While we implement robust protections, absolute security cannot be guaranteed.
""",
        ),
        _buildPolicySection(
          icon: Icons.child_care,
          title: "6. Children's Privacy",
          content: """
• Artleap is not designed for users under 13
• We do not knowingly collect children's data
• Parents may contact us to remove accidental collection
• COPPA compliant practices
""",
        ),
        _buildPolicySection(
          icon: Icons.update,
          title: "7. Policy Updates",
          content: """
• We may revise this policy periodically
• Material changes will be notified via email
• Your continued use signifies acceptance
• Previous versions are archived for reference
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
        color: AppColors.darkBlue.withValues(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightPurple.withValues(),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.lightPurple,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextstyle.interBold(
                      fontSize: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                content,
                style: AppTextstyle.interRegular(
                  fontSize: 15,
                  color: AppColors.white.withValues(),
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
          color: AppColors.lightgrey,
          thickness: 0.5,
          height: 1,
        ),
        const SizedBox(height: 24),
        Text(
          'By using Artleap, you acknowledge that you have read and understood this Privacy Policy and agree to our Terms of Service.',
          style: AppTextstyle.interRegular(
            fontSize: 14,
            color: AppColors.lightgrey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          '© ${DateTime.now().year} Mimar Technologies Inc.\nAll rights reserved.',
          style: AppTextstyle.interRegular(
            fontSize: 12,
            color: AppColors.lightgrey.withValues(),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}