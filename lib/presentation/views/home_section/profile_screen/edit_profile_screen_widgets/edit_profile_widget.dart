import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/user_info_widget.dart';
import 'package:Artleap.ai/presentation/views/global_widgets/upgrade_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/edit_profile_screen_widgets/delete_account_dialog.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/policies_screens/help_screen.dart';
import 'package:Artleap.ai/presentation/views/home_section/profile_screen/policies_screens/privacy_policy_screen.dart';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'separator_widget.dart';

class EditProfileWidget extends ConsumerWidget {
  final EditProfileSreenParams? params;
  const EditProfileWidget({super.key, this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconSize = MediaQuery.of(context).size.width * 0.06; // Responsive icon size
    final padding = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.05,
      vertical: 16,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigation.pop(),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.white,
                  size: iconSize,
                ),
              ),
              const SizedBox(height: 30),

              // Profile Section
              Row(
                children: [
                  Container(
                    width: constraints.maxWidth * 0.18,
                    height: constraints.maxWidth * 0.18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: params!.profileImage == ''
                            ? const AssetImage(AppAssets.profilepic) as ImageProvider
                            : NetworkImage(params!.profileImage ?? AppAssets.profilepic),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        params!.userName ?? "user name",
                        style: AppTextstyle.interMedium(
                          color: AppColors.white,
                          fontSize: constraints.maxWidth * 0.04,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        params!.userEmail ?? "username@gmail.com",
                        style: AppTextstyle.interMedium(
                          color: AppColors.white,
                          fontSize: constraints.maxWidth * 0.035,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              UpgradeToProBanner(),
              const SizedBox(height: 20),
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
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: AppAssets.privacyicon,
                    title: "Privacy Policy",
                    onTap: () => _navigateTo(context, PrivacyPolicyScreen.routeName),
                  ),
                  _ProfileMenuItem(
                    icon: AppAssets.privacyicon,
                    title: "Payment Method",
                    onTap: () => _navigateTo(context, PrivacyPolicyScreen.routeName),
                  ),
                  _ProfileMenuItem(
                    icon: AppAssets.dark,
                    title: "Dark Mode",
                    onTap: () => _navigateTo(context, PrivacyPolicyScreen.routeName),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // About Section
              _buildSection(
                context,
                title: "About",
                items: [
                  _ProfileMenuItem(
                    icon: AppAssets.facebooklogin,
                    title: "Follow us on Social Media",
                    onTap: () => _navigateTo(context, PrivacyPolicyScreen.routeName),
                  ),
                  _ProfileMenuItem(
                    icon: AppAssets.privacyicon,
                    title: "Help Center",
                    onTap: () => _navigateTo(context, HelpScreen.routeName),
                  ),
                  _ProfileMenuItem(
                    icon: AppAssets.abouticon,
                    title: "About Artleap",
                    onTap: () => _navigateTo(context, PrivacyPolicyScreen.routeName),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Account Actions
              _ProfileMenuItem(
                icon: AppAssets.logouticon,
                title: "Logout",
                color: AppColors.redColor,
                onTap: () {
                  AppLocal.ins.clearUSerData(Hivekey.userId);
                  Navigation.pushNamedAndRemoveUntil(LoginScreen.routeName);
                },
              ),
              const SizedBox(height: 20),
              _ProfileMenuItem(
                icon: AppAssets.deleteicon,
                title: "Delete Account",
                color: AppColors.redColor,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => const DeleteAccountDialog(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<_ProfileMenuItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeparatorWidget(title: title),
        const SizedBox(height: 20),
        ...items,
      ],
    );
  }

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}

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
    return  GestureDetector(
      onTap:onTap,
      child: Column(
        children: [
          IconWithTextTile(
            imageIcon: icon,
            title: title,
            titleColor: color,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}