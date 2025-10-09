import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'custom_theme_extension.dart';

enum ThemeMode { light, dark, system }

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    primaryColorDark: AppColors.lightPrimaryVariant,
    primaryColorLight: AppColors.lightPurple,
    extensions: const [CustomThemeExtension.light],
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryVariant,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: AppColors.lightError,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onSurface: AppColors.black,
      onBackground: AppColors.black,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightPrimary),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.lightSurface,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.primaryTextColor),
      displayMedium: TextStyle(color: AppColors.primaryTextColor),
      displaySmall: TextStyle(color: AppColors.primaryTextColor),
      headlineMedium: TextStyle(color: AppColors.primaryTextColor),
      headlineSmall: TextStyle(color: AppColors.primaryTextColor),
      titleLarge: TextStyle(color: AppColors.primaryTextColor),
      titleMedium: TextStyle(color: AppColors.primaryTextColor),
      titleSmall: TextStyle(color: AppColors.primaryTextColor),
      bodyLarge: TextStyle(color: AppColors.primaryTextColor),
      bodyMedium: TextStyle(color: AppColors.primaryTextColor),
      bodySmall: TextStyle(color: AppColors.hintTextColor),
      labelLarge: TextStyle(color: AppColors.primaryTextColor),
      labelSmall: TextStyle(color: AppColors.hintTextColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: AppColors.lightSurface,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.greyMedium,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    primaryColorDark: AppColors.darkPrimaryVariant,
    primaryColorLight: AppColors.lightPurple,
    extensions: const [CustomThemeExtension.dark],
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryVariant,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.darkError,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.white,
      onBackground: AppColors.white,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 4,
      margin: EdgeInsets.all(8),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.white),
      displayMedium: TextStyle(color: AppColors.white),
      displaySmall: TextStyle(color: AppColors.white),
      headlineMedium: TextStyle(color: AppColors.white),
      headlineSmall: TextStyle(color: AppColors.white),
      titleLarge: TextStyle(color: AppColors.white),
      titleMedium: TextStyle(color: AppColors.white),
      titleSmall: TextStyle(color: AppColors.white),
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.white),
      bodySmall: TextStyle(color: AppColors.greyMedium),
      labelLarge: TextStyle(color: AppColors.white),
      labelSmall: TextStyle(color: AppColors.greyMedium),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.greyBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.greyBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: AppColors.darkSurface,
      hintStyle: const TextStyle(color: AppColors.greyMedium),
      labelStyle: const TextStyle(color: AppColors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: AppColors.greyMedium,
    ),
  );
}