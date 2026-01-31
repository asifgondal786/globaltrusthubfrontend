import 'package:flutter/material.dart';

class UiConfig {
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color dangerColor = Colors.red;

  static const String fontFamily = 'Poppins';
  static const double borderRadius = 12.0;
  static const double cardShadowLevel = 4.0;
  static const String animationLevel = 'medium'; // low | medium

  static const Map<String, dynamic> accessibility = {
    'text_scaling': 1.0,
    'high_contrast': false,
  };

  static const Map<String, dynamic> layoutRules = {
    'sidebar_visibility': true,
    'dashboard_card_order': ['trust_score', 'quick_actions', 'news', 'services'],
  };
}
