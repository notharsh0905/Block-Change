import 'package:flutter/material.dart';

/// Centralized application color palette and 2.5D visual tokens.
abstract class AppColors {
  // Vibrant, Brighter Logical Game Colors (6 baseline tokens)
  static const Color coral = Color(0xFFFF5E62);
  static const Color mint = Color(0xFF38EF7D);
  static const Color sky = Color(0xFF4FACFE);
  static const Color violet = Color(0xFFA855F7);
  static const Color sunshine = Color(0xFFFFD200);
  static const Color aqua = Color(0xFF00F2FE);

  static const List<Color> gamePalette = [
    coral,
    mint,
    sky,
    violet,
    sunshine,
    aqua,
  ];

  // Rich 2.5D Bottom Depth Edge Shades
  static const Color coralDark = Color(0xFFD63B40);
  static const Color mintDark = Color(0xFF11B952);
  static const Color skyDark = Color(0xFF0072D2);
  static const Color violetDark = Color(0xFF7E22CE);
  static const Color sunshineDark = Color(0xFFD49B00);
  static const Color aquaDark = Color(0xFF00B4BD);

  static const List<Color> gamePaletteDark = [
    coralDark,
    mintDark,
    skyDark,
    violetDark,
    sunshineDark,
    aquaDark,
  ];

  // App Theme Surfaces (Brighter, Richer Dark 2.5D Playful Gradient Surfaces)
  static const Color backgroundTop = Color(0xFF1E1E38);
  static const Color backgroundBottom = Color(0xFF121222);
  static const Color background = Color(0xFF181829);
  static const Color surface = Color(0xFF2B2B48);
  static const Color surfaceElevated = Color(0xFF38385C);
  static const Color boardBackground = Color(0xFF19192C);
  static const Color boardBorder = Color(0xFF38385C);

  static const Color primary = Color(0xFFA855F7);
  static const Color accent = Color(0xFFFFD200);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB4B4DB);

  // Status Colors
  static const Color success = Color(0xFF38EF7D);
  static const Color warning = Color(0xFFFFD200);
  static const Color error = Color(0xFFFF5E62);
}
