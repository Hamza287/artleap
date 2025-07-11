import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../home_section/profile_screen/edit_profile_screen_widgets/delete_account_dialog.dart';
import '../home_section/profile_screen/edit_profile_screen_widgets/separator_widget.dart';
import '../home_section/profile_screen/edit_profile_screen_widgets/user_info_widget.dart';
import '../global_widgets/upgrade_plan_widget.dart';
import '../login_and_signup_section/login_section/login_screen.dart';

class ProfileDrawer extends ConsumerWidget {
  final String profileImage;
  final String userName;
  final String userEmail;

  const ProfileDrawer({
    super.key,
    required this.profileImage,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.06;
    final padding = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: 16,
    );

    return Drawer(
      width: screenWidth * 0.85,
      child: Stack(
        children: [
          // Background with blur effect
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkIndigo.withOpacity(0.8),
                  AppColors.darkIndigo.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Frosted glass effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _GlassCircleButton(
                      icon: Icons.close,
                      size: iconSize,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.18,
                        height: screenWidth * 0.18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          image: DecorationImage(
                            image: profileImage.isEmpty
                                ? const AssetImage(AppAssets.profilepic) as ImageProvider
                                : NetworkImage(profileImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: AppTextstyle.interMedium(
                              color: AppColors.white,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            userEmail,
                            style: AppTextstyle.interMedium(
                              color: AppColors.white.withOpacity(0.8),
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  UpgradeToProBanner(), // Uncomment if you have this widget
                  SizedBox(height: screenHeight * 0.02),
                  _buildSection(
                    context,
                    title: "General",
                    items: [
                      _ProfileMenuItem(
                        icon: AppAssets.userinfoicon,
                        title: "Personal Information",
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.copyicon,
                        title: "Current Plan",
                        onTap: () => _navigateTo(context, '/subscription-status'),
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.privacyicon,
                        title: "Privacy Policy",
                        onTap: () => _navigateTo(context, '/privacy-policy'),
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.privacyicon,
                        title: "Payment Method",
                        onTap: () => _navigateTo(context, 'choose-plan-screen'),
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.dark,
                        title: "Dark Mode",
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // About Section
                  _buildSection(
                    context,
                    title: "About",
                    items: [
                      _ProfileMenuItem(
                        icon: AppAssets.facebooklogin,
                        title: "Follow us on Social Media",
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.privacyicon,
                        title: "Help Center",
                        onTap: () => _navigateTo(context, '/help-screen'),
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.abouticon,
                        title: "About Artleap",
                        onTap: () => _navigateTo(context, '/about-artleap'),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Column(
                    children: [
                      _ProfileMenuItem(
                        icon: AppAssets.logouticon,
                        title: "Logout",
                        color: AppColors.redColor,
                        onTap: (){
                          AppLocal.ins.clearUSerData(Hivekey.userId);
                          Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _ProfileMenuItem(
                        icon: AppAssets.deleteicon,
                        title: "Delete Account",
                        color: AppColors.redColor,
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => const DeleteAccountDialog(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<_ProfileMenuItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeparatorWidget(title: title),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ...items,
      ],
    );
  }

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pop(context); // Close drawer first
    Navigator.pushNamed(context, routeName);
  }
}

// Custom glass circle button
class _GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  const _GlassCircleButton({
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size * 1.8,
        height: size * 1.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}

// Reusable menu item widget
class _ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            IconWithTextTile(
              imageIcon: icon,
              title: title,
              titleColor: color ?? Colors.white.withOpacity(0.9),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}