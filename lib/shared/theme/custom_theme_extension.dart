import 'package:flutter/material.dart';

@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final RadialGradient onboardingBackground;
  final LinearGradient headlineGradient;
  final LinearGradient buttonGradient;
  final Color secondaryText;

  const CustomThemeExtension({
    required this.onboardingBackground,
    required this.headlineGradient,
    required this.buttonGradient,
    required this.secondaryText,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    RadialGradient? onboardingBackground,
    LinearGradient? headlineGradient,
    LinearGradient? buttonGradient,
    Color? secondaryText,
  }) {
    return CustomThemeExtension(
      onboardingBackground: onboardingBackground ?? this.onboardingBackground,
      headlineGradient: headlineGradient ?? this.headlineGradient,
      buttonGradient: buttonGradient ?? this.buttonGradient,
      secondaryText: secondaryText ?? this.secondaryText,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
      ThemeExtension<CustomThemeExtension>? other,
      double t,
      ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      onboardingBackground: RadialGradient.lerp(
          onboardingBackground,
          other.onboardingBackground,
          t
      )!,
      headlineGradient: LinearGradient.lerp(
          headlineGradient,
          other.headlineGradient,
          t
      )!,
      buttonGradient: LinearGradient.lerp(
          buttonGradient,
          other.buttonGradient,
          t
      )!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
    );
  }

  static const light = CustomThemeExtension(
    onboardingBackground: RadialGradient(
      center: Alignment.topRight,
      radius: 1.2,
      colors: [Color(0xFFB499FF), Colors.white],
    ),
    headlineGradient: LinearGradient(
      colors: [Color(0xFF9B5CFF), Color(0xFF7E4EFF)],
    ),
    buttonGradient: LinearGradient(
      colors: [Color(0xFFD765FF), Color(0xFF6D40DA)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    secondaryText: Colors.black87,
  );

  static const dark = CustomThemeExtension(
    onboardingBackground: RadialGradient(
      center: Alignment.topRight,
      radius: 1.2,
      colors: [Color(0xFF2D1B69), Color(0xFF121212)],
    ),
    headlineGradient: LinearGradient(
      colors: [Color(0xFFB499FF), Color(0xFF9C67F7)],
    ),
    buttonGradient: LinearGradient(
      colors: [Color(0xFF9C67F7), Color(0xFF6D40DA)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    secondaryText: Colors.white70,
  );
}