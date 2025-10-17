import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/bottom_nav_bar_provider.dart';
import '../../../../providers/notification_provider.dart';
import '../../../../providers/user_profile_provider.dart';
import '../../../../shared/constants/app_assets.dart';
import '../../../../shared/constants/app_textstyle.dart';
import '../../../../shared/constants/user_data.dart';
import '../../../firebase_analyitcs_singleton/firebase_analtics_singleton.dart';
import '../../Notifications/notification_screen.dart';
import '../../login_and_signup_section/login_section/login_screen.dart';
import '../profile_screen/profile_screen_widgets/my_creations_widget.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});
  static const String routeName = "user_profile_screen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserData.ins.userId != null) {
        ref.read(userProfileProvider).getUserProfileData(UserData.ins.userId!);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      AnalyticsService.instance.logScreenView(screenName: 'profile screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final userProfile = ref.watch(userProfileProvider);
    final userPersonalData = userProfile.userProfileData;
    final user = userPersonalData?.user;
    final profilePic = user?.profilePic;
    final userName = user?.username ?? 'User';
    final theme = Theme.of(context);

    if (user == null || userPersonalData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          ref.read(bottomNavBarProvider).setPageIndex(0);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: screenHeight * 0.2,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, right: 16),
                          child: Consumer(
                            builder: (context, ref, _) {
                              final userId = UserData.ins.userId;
                              if (userId == null) return const SizedBox();

                              final notifications = ref.watch(notificationProvider(userId));
                              final unreadCount = notifications.maybeWhen(
                                data: (notifs) => notifs.where((n) => !n.isRead).length,
                                orElse: () => 0,
                              );
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.save, color: theme.colorScheme.onPrimary),
                                    onPressed: (){
                                      Navigator.of(context).pushNamed('saved-images-screens');
                                    },
                                    tooltip: "Saved Images",
                                  ),
                                  IconButton(
                                    icon: Badge(
                                      label: unreadCount > 0 ? Text(unreadCount.toString()) : null,
                                      child: Icon(Icons.notifications, color: theme.colorScheme.onPrimary, size: 30),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, NotificationScreen.routeName);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: screenHeight - (screenHeight * 0.2) - MediaQuery.of(context).padding.top,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 16 + safeAreaBottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, -60),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: theme.colorScheme.surface, width: 4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.colorScheme.shadow.withOpacity(0.1),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                        image: profilePic != null && profilePic.isNotEmpty
                                            ? DecorationImage(
                                          image: NetworkImage(profilePic),
                                          fit: BoxFit.cover,
                                        )
                                            : const DecorationImage(
                                          image: AssetImage(AppAssets.artstyle1),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      userName.toUpperCase(),
                                      style: AppTextstyle.interBold(
                                        fontSize: 22,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '@${user.email}',
                                      style: AppTextstyle.interMedium(
                                        fontSize: 16,
                                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Creating images just for fun',
                                      style: AppTextstyle.interRegular(
                                        fontSize: 15,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildStatColumn(
                                          userPersonalData.user.followers.length.toString(),
                                          'Followers',
                                          theme,
                                        ),
                                        const SizedBox(width: 30),
                                        _buildStatColumn(
                                          userPersonalData.user.following.length.toString(),
                                          'Following',
                                          theme,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${userPersonalData.user.images.length.toString()} Generations',
                                          style: AppTextstyle.interMedium(
                                            fontSize: 18,
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            MyCreationsWidget(
                              listofCreations: userPersonalData.user.images,
                              userName: userName,
                              userId: user.id,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, ThemeData theme) {
    return Row(
      children: [
        Text(
          value,
          style: AppTextstyle.interBold(
            fontSize: 18,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTextstyle.interRegular(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}