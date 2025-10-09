import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart' show AppTheme;

// Theme Notifier
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme_mode') ?? 2; // Default to system
    state = ThemeMode.values[themeIndex];
  }

  Future<void> setTheme(ThemeMode theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', theme.index);
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newTheme);
  }
}

// Providers
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);

final currentThemeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeProvider);
  final platformBrightness = WidgetsBinding.instance.window.platformBrightness;

  switch (themeMode) {
    case ThemeMode.light:
      return AppTheme.lightTheme;
    case ThemeMode.dark:
      return AppTheme.darkTheme;
    case ThemeMode.system:
      return platformBrightness == Brightness.dark
          ? AppTheme.darkTheme
          : AppTheme.lightTheme;
  }
});