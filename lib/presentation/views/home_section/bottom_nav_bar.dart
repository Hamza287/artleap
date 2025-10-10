import 'dart:ui';
import 'package:Artleap.ai/presentation/views/login_and_signup_section/login_section/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/bottom_nav_bar_provider.dart';
import 'package:Artleap.ai/shared/shared.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../shared/constants/user_data.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  static const String routeName = "bottom_nav_bar_screen";

  const BottomNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomNavBarState = ref.watch(bottomNavBarProvider);
    final pageIndex = bottomNavBarState.pageIndex;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorScheme.of(context).surface,
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
      ),
    );
  }

  Widget _buildEnhancedNavBar(int currentIndex, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton(
                icon: Icons.home,
                index: 0,
                currentIndex: currentIndex,
                onTap: () => ref.read(bottomNavBarProvider).setPageIndex(0),
                theme: theme,
              ),
              _buildNavButton(
                icon: Icons.add_circle,
                index: 1,
                currentIndex: currentIndex,
                onTap: () => ref.read(bottomNavBarProvider).setPageIndex(1),
                theme: theme,
              ),
              _buildNavButton(
                icon: Icons.groups,
                index: 2,
                currentIndex: currentIndex,
                onTap: () => ref.read(bottomNavBarProvider).setPageIndex(2),
                theme: theme,
              ),
              _buildNavButton(
                icon: Icons.person,
                index: 3,
                currentIndex: currentIndex,
                onTap: () => ref.read(bottomNavBarProvider).setPageIndex(3),
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    final isSelected = currentIndex == index;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
              width: 1.5,
            )
                : null,
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}