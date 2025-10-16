import 'dart:ui';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../shared/constants/user_data.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  static const String routeName = "bottom_nav_bar_screen";

  const BottomNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> with SingleTickerProviderStateMixin {
  bool _initialized = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_initialized) return;
      _initialized = true;
      final userId = (AppData.instance.userId?.trim().isNotEmpty ?? false)
          ? AppData.instance.userId!.trim()
          : (UserData.ins.userId ?? '').trim();
      if (userId.isEmpty) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
        return;
      }
      await ref.read(userProfileProvider).getUserProfileData(userId);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    ref.read(bottomNavBarProvider).setPageIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomNavBarState = ref.watch(bottomNavBarProvider);
    final pageIndex = bottomNavBarState.pageIndex;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: isKeyboardOpen
          ? const SizedBox.shrink()
          : _buildEnhancedNavBar(pageIndex, theme),
      body: (pageIndex >= 0 && pageIndex < bottomNavBarState.widgets.length)
          ? bottomNavBarState.widgets[pageIndex]
          : Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEnhancedNavBar(int currentIndex, ThemeData theme) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.25),
              blurRadius: 25,
              spreadRadius: 3,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: -2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surface.withOpacity(0.95),
                    theme.colorScheme.surface.withOpacity(0.98),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavigationItem(
                    icon: Feather.home,
                    activeIcon: Feather.home,
                    label: 'Home',
                    index: 0,
                    currentIndex: currentIndex,
                    theme: theme,
                  ),
                  _buildNavigationItem(
                    icon: Feather.edit_3,
                    activeIcon: Feather.edit_3,
                    label: 'Create',
                    index: 1,
                    currentIndex: currentIndex,
                    theme: theme,
                  ),
                  _buildNavigationItem(
                    icon: Feather.users,
                    activeIcon: Feather.users,
                    label: 'Community',
                    index: 2,
                    currentIndex: currentIndex,
                    theme: theme,
                  ),
                  _buildNavigationItem(
                    icon: Feather.users,
                    activeIcon: Feather.users,
                    label: 'Profile',
                    index: 3,
                    currentIndex: currentIndex,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    required ThemeData theme,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: isActive ? _fadeAnimation.value : 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isActive
                          ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.15),
                          theme.colorScheme.primary.withOpacity(0.25),
                        ],
                      )
                          : null,
                      color: isActive
                          ? null
                          : theme.colorScheme.onSurface.withOpacity(0.05),
                      boxShadow: isActive
                          ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ]
                          : null,
                    ),
                    child: Icon(
                      isActive ? activeIcon : icon,
                      size: isActive ? 26 : 22,
                      color: isActive
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   label,
                  //   style: TextStyle(
                  //     fontSize: 11,
                  //     fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  //     color: isActive
                  //         ? theme.colorScheme.onSurface
                  //         : theme.colorScheme.onSurface.withOpacity(0.7),
                  //     letterSpacing: 0.3,
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}