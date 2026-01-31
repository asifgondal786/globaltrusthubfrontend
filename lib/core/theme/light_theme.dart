import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/colors.dart';
import 'package:global_trust_hub/core/constants/typography.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  primaryColorLight: AppColors.primaryVariant,
  scaffoldBackgroundColor: AppColors.background,
  cardColor: AppColors.surface,
  textTheme: const TextTheme(
    displayLarge: AppTypography.h1,
    displayMedium: AppTypography.h2,
    displaySmall: AppTypography.h3,
    headlineMedium: AppTypography.h4,
    headlineSmall: AppTypography.h5,
    titleLarge: AppTypography.h6,
    titleMedium: AppTypography.subtitle1,
    titleSmall: AppTypography.subtitle2,
    bodyLarge: AppTypography.body1,
    bodyMedium: AppTypography.body2,
    labelLarge: AppTypography.button,
    bodySmall: AppTypography.caption,
    labelSmall: AppTypography.overline,
  ),
  colorScheme: const ColorScheme(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onSurface: AppColors.onSurface,
    onError: AppColors.onError,
    brightness: Brightness.light,
  ),
);
