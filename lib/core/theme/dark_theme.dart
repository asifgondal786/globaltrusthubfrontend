import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/colors.dart';
import 'package:global_trust_hub/core/constants/typography.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary, // Adjust for dark mode if needed
  primaryColorLight: AppColors.primaryVariant,
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  textTheme: TextTheme(
    displayLarge: AppTypography.h1.copyWith(color: Colors.white),
    displayMedium: AppTypography.h2.copyWith(color: Colors.white),
    displaySmall: AppTypography.h3.copyWith(color: Colors.white),
    headlineMedium: AppTypography.h4.copyWith(color: Colors.white),
    headlineSmall: AppTypography.h5.copyWith(color: Colors.white),
    titleLarge: AppTypography.h6.copyWith(color: Colors.white),
    titleMedium: AppTypography.subtitle1.copyWith(color: Colors.white),
    titleSmall: AppTypography.subtitle2.copyWith(color: Colors.white70),
    bodyLarge: AppTypography.body1.copyWith(color: Colors.white),
    bodyMedium: AppTypography.body2.copyWith(color: Colors.white),
    labelLarge: AppTypography.button.copyWith(color: Colors.black),
    bodySmall: AppTypography.caption.copyWith(color: Colors.white54),
    labelSmall: AppTypography.overline.copyWith(color: Colors.white54),
  ),
  colorScheme: const ColorScheme(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: Color(0xFF1E1E1E),
    error: Color(0xFFCF6679),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),
);
