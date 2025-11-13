import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelectorMenuItem extends ConsumerWidget {
  final ThemeData theme;
  final ThemeMode currentTheme;
  final Function(ThemeMode) onThemeChanged;

  const ThemeSelectorMenuItem({
    required this.theme,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  String _getThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.phone_iphone_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor =
        isDark ? theme.colorScheme.onSurface : Colors.white.withOpacity(0.9);

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FeatherIcons.moon,
                size: 24,
                color: effectiveColor,
              ),
              SizedBox(width: 12),
              Text(
                "Theme",
                style: AppTextstyle.interMedium(
                  color: effectiveColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            spacing: 5,
            children: [
              _buildThemeOption(ThemeMode.light),
              _buildThemeOption(ThemeMode.dark),
              _buildThemeOption(ThemeMode.system),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(ThemeMode themeMode) {
    final isSelected = currentTheme == themeMode;

    return Expanded(
      child: GestureDetector(
        onTap: () => onThemeChanged(themeMode),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.15)
                : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected ? theme.colorScheme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                _getThemeIcon(themeMode),
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                _getThemeName(themeMode),
                style: AppTextstyle.interMedium(
                  fontSize: 12,
                  color:
                      isSelected ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
