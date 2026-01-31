import 'package:flutter/material.dart';

/// GlobalTrustHub Design System - Color Palette
/// Core Values: Trust, Transparency, Dignity
class AppColors {
  // Primary Brand Colors - Deep Trust Blue
  static const Color primary = Color(0xFF1A365D);        // Deep navy - trust
  static const Color primaryLight = Color(0xFF2D4A7C);
  static const Color primaryDark = Color(0xFF0D1B2A);

  // Secondary - Warm Gold - Success & Achievement
  static const Color secondary = Color(0xFFD69E2E);      // Trust gold
  static const Color secondaryLight = Color(0xFFECC94B);
  static const Color secondaryDark = Color(0xFFB7791F);

  // Accent - Teal - Growth & Journey
  static const Color accent = Color(0xFF319795);         // Journey teal
  static const Color accentLight = Color(0xFF4FD1C5);
  static const Color accentDark = Color(0xFF285E61);

  // Trust Score Colors
  static const Color trustHigh = Color(0xFF38A169);      // Green - verified
  static const Color trustMedium = Color(0xFFD69E2E);    // Gold - building
  static const Color trustLow = Color(0xFFE53E3E);       // Red - caution

  // Verification Status Colors
  static const Color verified = Color(0xFF38A169);
  static const Color pending = Color(0xFFED8936);
  static const Color unverified = Color(0xFF718096);
  static const Color rejected = Color(0xFFE53E3E);

  // Semantic Colors
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF3182CE);

  // Background & Surface
  static const Color background = Color(0xFFF7FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF718096);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF1A202C);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0D1B2A);
  static const Color darkSurface = Color(0xFF1A365D);
  static const Color darkSurfaceElevated = Color(0xFF2D4A7C);
  static const Color darkDivider = Color(0xFF2D3748);
  static const Color darkTextPrimary = Color(0xFFF7FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E0);

  // Role-Specific Colors
  static const Color roleStudent = Color(0xFF3182CE);    // Blue
  static const Color roleAgent = Color(0xFF805AD5);       // Purple
  static const Color roleInstitution = Color(0xFF38A169); // Green
  static const Color roleProvider = Color(0xFFED8936);    // Orange

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient trustGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [trustLow, trustMedium, trustHigh],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, Color(0xFF0D1B2A)],
  );
}
