import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../shared/constants/user_data.dart';
import '../home_section/favourites_screen/favourites_screen.dart';
import '../global_widgets/dialog_box/delete_account_dialog.dart';
import '../home_section/profile_screen/edit_profile_screen_widgets/separator_widget.dart';
import '../home_section/profile_screen/edit_profile_screen_widgets/user_info_widget.dart';
import '../global_widgets/upgrade_plan_widget.dart';
import 'logout_confirmation_dialog.dart';
import 'social_media_bottom_sheet.dart';
import '../../../shared/theme/theme_provider.dart';

class ProfileDrawer extends ConsumerStatefulWidget {
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
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends ConsumerState<ProfileDrawer> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.06;

    final profileProvider = ref.watch(userProfileProvider);
    final user = profileProvider.userProfileData?.user;

    return Drawer(
      width: screenWidth * 0.9,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                  theme.colorScheme.surface.withOpacity(0.9),
                  theme.colorScheme.surface.withOpacity(0.8),
                ]
                    : [
                  Color(0x5F0A0025),
                  Color(0x5E0A0025),
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, right: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _GlassCircleButton(
                      icon: Icons.close,
                      size: iconSize,
                      onPressed: () => Navigator.pop(context),
                      theme: theme,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, top: 16, right: 16),
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth * 0.18,
                        height: screenWidth * 0.18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? theme.colorScheme.onSurface.withOpacity(0.3)
                                : AppColors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          image: DecorationImage(
                            image: widget.profileImage.isEmpty
                                ? const AssetImage(AppAssets.profilepic) as ImageProvider
                                : NetworkImage(widget.profileImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: AppTextstyle.interMedium(
                              color: isDark ? theme.colorScheme.onSurface : AppColors.white,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            widget.userEmail,
                            style: AppTextstyle.interMedium(
                              color: isDark
                                  ? theme.colorScheme.onSurface.withOpacity(0.8)
                                  : AppColors.white.withOpacity(0.8),
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                user?.planName.toLowerCase() == 'free' ?
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, top: 16, right: 16),
                  child: UpgradeToProBanner(),
                ) : Container(),
                10.spaceY,
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, top: 16),
                  child: _buildSection(
                    context,
                    title: "General",
                    items: [
                      _ProfileMenuItem(
                        icon: AppAssets.userinfoicon,
                        title: "Personal Information",
                        onTap: () => Navigator.of(context).pushNamed("personal_info_screen"),
                        theme: theme,
                      ),
                      user?.planName.toLowerCase() == 'free' ?
                      _ProfileMenuItem(
                        icon: AppAssets.currentPlan,
                        title: "You don't have an active subscription",
                        onTap: ()=>Navigator.of(context).pushNamed("choose_plan_screen"),
                        color: theme.colorScheme.error,
                        theme: theme,
                      ) : _ProfileMenuItem(
                        icon: AppAssets.currentPlan,
                        title: "Current Plan",
                        onTap: () => _navigateTo(context, '/subscription-status'),
                        theme: theme,
                      ) ,
                      _ProfileMenuItem(
                        icon: AppAssets.privacyicon,
                        title: "Privacy Policy",
                        onTap: () => _navigateTo(context, '/privacy-policy'),
                        theme: theme,
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.payment,
                        title: "Subscription Plans",
                        onTap: () => Navigator.of(context).pushNamed("choose_plan_screen"),
                        theme: theme,
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.saveicon,
                        title: "Favourites",
                        onTap: () => Navigator.pushNamed(context, FavouritesScreen.routeName),
                        theme: theme,
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.darkMode,
                        title: "Dark Mode",
                        isToggle: true,
                        onTap: () {},
                        theme: theme,
                      ),
                    ],
                  ),
                ),
                10.spaceY,
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05, top: 16),
                  child: _buildSection(
                    context,
                    title: "About",
                    items: [
                      _ProfileMenuItem(
                        icon: AppAssets.follow,
                        title: "Follow us on Social Media",
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            isScrollControlled: true,
                            builder: (context) => const SocialMediaBottomSheet(),
                          );
                        },
                        theme: theme,
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.helpCenter,
                        title: "Help Center",
                        onTap: () => _navigateTo(context, '/help-screen'),
                        theme: theme,
                      ),
                      _ProfileMenuItem(
                        icon: AppAssets.abouticon,
                        title: "About Artleap",
                        onTap: () => _navigateTo(context, '/about-artleap'),
                        theme: theme,
                      ),
                    ],
                  ),
                ),

                // Actions section with theme-aware background
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.surface.withOpacity(0.5)
                        : Color(0x991D0751),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05, top: 10, bottom: 20),
                    child: Column(
                      children: [
                        _ProfileMenuItem(
                          icon: AppAssets.logouticon,
                          title: "Logout",
                          color: theme.colorScheme.error,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => const LogoutConfirmationDialog(),
                          ),
                          theme: theme,
                        ),
                        _ProfileMenuItem(
                          icon: AppAssets.deleteicon,
                          title: "Delete Account",
                          color: theme.colorScheme.error.withOpacity(0.9),
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => const DeleteAccountDialog(),
                          ),
                          theme: theme,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<_ProfileMenuItem> items}) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SeparatorWidget(
          title: title,
        ),
        SingleChildScrollView(
          child: Column(
            spacing: 4,
            children: items,
          ),
          physics: BouncingScrollPhysics(),
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pop(context);
    Navigator.pushNamed(context, routeName);
  }
}

class _GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;
  final ThemeData theme;

  const _GlassCircleButton({
    required this.icon,
    required this.size,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size * 1.8,
        height: size * 1.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? theme.colorScheme.surface.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: isDark
                ? theme.colorScheme.onSurface.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isDark ? theme.colorScheme.onSurface : Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends ConsumerWidget {
  final String icon;
  final String title;
  final Color? color;
  final VoidCallback? onTap;
  final bool isToggle;
  final ThemeData theme;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.color,
    this.onTap,
    this.isToggle = false,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor = color ?? (isDark ? theme.colorScheme.onSurface : Colors.white.withOpacity(0.9));

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
                  titleColor: effectiveColor,
                ),
                if (isToggle)
                  Switch(
                    value: ref.watch(themeProvider) == ThemeMode.dark,
                    onChanged: (_) {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                    activeThumbColor: theme.colorScheme.primary,
                    inactiveThumbColor: theme.colorScheme.outline,
                    inactiveTrackColor: theme.colorScheme.outline.withOpacity(0.5),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return theme.colorScheme.primary.withOpacity(0.5);
                      }
                      return theme.colorScheme.outline.withOpacity(0.5);
                    }),
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