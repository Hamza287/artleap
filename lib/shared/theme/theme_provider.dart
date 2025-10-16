import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart' show AppTheme;

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt('theme_mode') ?? ThemeMode.system.index;
      state = ThemeMode.values[themeIndex];
    } catch (e) {
      state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    state = theme;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', theme.index);
    } catch (e) {
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newTheme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);

final platformBrightnessProvider = StateProvider<Brightness>((ref) {
  return WidgetsBinding.instance.window.platformBrightness;
});

final effectiveThemeModeProvider = Provider<ThemeMode>((ref) {
  final selectedTheme = ref.watch(themeProvider);
  final platformBrightness = ref.watch(platformBrightnessProvider);

  if (selectedTheme == ThemeMode.system) {
    return platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }
  return selectedTheme;
});

final currentThemeProvider = Provider<ThemeData>((ref) {
  final effectiveThemeMode = ref.watch(effectiveThemeModeProvider);

  return effectiveThemeMode == ThemeMode.dark
      ? AppTheme.darkTheme
      : AppTheme.lightTheme;
});

final systemThemeMonitorProvider = Provider((ref) {
  ref.watch(platformBrightnessProvider);
  return null;
});