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
      error: AppColors.lightError,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onSurface: AppColors.black,
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
      secondaryContainer: Color(0xFF1AA58C),
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      error: AppColors.darkError,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onSurface: AppColors.darkTextPrimary,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurfaceVariant,
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.darkTextPrimary),
      displayMedium: TextStyle(color: AppColors.darkTextPrimary),
      displaySmall: TextStyle(color: AppColors.darkTextPrimary),
      headlineMedium: TextStyle(color: AppColors.darkTextPrimary),
      headlineSmall: TextStyle(color: AppColors.darkTextPrimary),
      titleLarge: TextStyle(color: AppColors.darkTextPrimary),
      titleMedium: TextStyle(color: AppColors.darkTextPrimary),
      titleSmall: TextStyle(color: AppColors.darkTextPrimary),
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
      bodySmall: TextStyle(color: AppColors.darkTextSecondary),
      labelLarge: TextStyle(color: AppColors.darkTextPrimary),
      labelSmall: TextStyle(color: AppColors.darkTextSecondary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
      labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
      floatingLabelStyle: const TextStyle(color: AppColors.darkPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: AppColors.darkTextSecondary,
      elevation: 4,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
      space: 1,
    ),
  );
}