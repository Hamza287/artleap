import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../providers/theme_provider.dart';
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
      width: screenWidth * 0.9,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Stack(
        children: [
          // Background with blur effect
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x5F0A0025),
                  Color(0x5E0A0025),
                ],
              ),
            ),
          ),

          // Frosted glass effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Padding(
              padding: padding,
              child: Column(
                spacing: 10,
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
                  UpgradeToProBanner(), // Uncomment if you have this widget
                  _buildSection(
                    context,
                    title: "General",
                    items: [
                      _ProfileMenuItem(
                        icon: AppAssets.userinfoicon,
                        title: "Personal Information",
                        onTap: () => Navigator.of(context).pushNamed("personal_info_screen"),
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.currentPlan,
                        title: "Current Plan",
                        onTap: () => _navigateTo(context, '/subscription-status'),
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.privacyicon,
                        title: "Privacy Policy",
                        onTap: () => _navigateTo(context, '/privacy-policy'),
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.payment,
                        title: "Payment Method",
                        onTap: () => Navigator.of(context).pushNamed("choose_plan_screen"),
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.darkMode,
                        title: "Dark Mode",
                        isToggle: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: "About",
                    items: [
                      _ProfileMenuItem(
                        icon: AppAssets.follow,
                        title: "Follow us on Social Media",
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.helpCenter,
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
                  Column(
                    spacing: 2,
                    children: [
                      _ProfileMenuItem(
                        icon: AppAssets.logouticon,
                        title: "Logout",
                        color: Color(0xFFE53935),
                        onTap: (){
                          AppLocal.ins.clearUSerData(Hivekey.userId);
                          Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
                        },
                      ),
                      // SizedBox(height: screenHeight * 0.01),
                      _ProfileMenuItem(
                        icon: AppAssets.deleteicon,
                        title: "Delete Account",
                        color: Color(0xFFFF2A28),
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
      spacing: 2,
      children: [
        SeparatorWidget(title: title),
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
class _ProfileMenuItem extends ConsumerWidget {
  final String icon;
  final String title;
  final Color? color;
  final VoidCallback? onTap;
  final bool isToggle;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.color,
    this.onTap,
    this.isToggle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconWithTextTile(
                  imageIcon: icon,
                  title: title,
                  titleColor: color ?? Colors.white.withOpacity(0.9),
                ),
                if (isToggle)
                  Switch(
                    value: theme == AppTheme.dark,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).toggle();
                    },
                    activeColor: AppColors.purple,
                    inactiveThumbColor: Colors.grey,
                  ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}