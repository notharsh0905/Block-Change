import 'package:flutter/material.dart';

/// Centralized application color palette and 2.5D visual tokens.
abstract class AppColors {
  // Logical Game Colors (6 baseline tokens)
  static const Color coral = Color(0xFFFF7A7A);
  static const Color mint = Color(0xFF73D99A);
  static const Color sky = Color(0xFF6FA8FF);
  static const Color violet = Color(0xFF9B7BFF);
  static const Color sunshine = Color(0xFFFFD45C);
  static const Color aqua = Color(0xFF55D6D6);

  static const List<Color> gamePalette = [
    coral,
    mint,
    sky,
    violet,
    sunshine,
    aqua,
  ];

  // Darker shade variants for 2.5D bottom depth edge
  static const Color coralDark = Color(0xFFD95353);
  static const Color mintDark = Color(0xFF4EB876);
  static const Color skyDark = Color(0xFF4A82D9);
  static const Color violetDark = Color(0xFF7555D9);
  static const Color sunshineDark = Color(0xFFD9AB36);
  static const Color aquaDark = Color(0xFF32B0B0);

  static const List<Color> gamePaletteDark = [
    coralDark,
    mintDark,
    skyDark,
    violetDark,
    sunshineDark,
    aquaDark,
  ];

  // App Theme Surfaces (Dark Playful 2.5D Baseline)
  static const Color background = Color(0xFF181824);
  static const Color surface = Color(0xFF242436);
  static const Color surfaceElevated = Color(0xFF32324A);
  static const Color primary = Color(0xFF9B7BFF);
  static const Color accent = Color(0xFFFFD45C);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0C0);

  // Status Colors
  static const Color success = Color(0xFF73D99A);
  static const Color warning = Color(0xFFFFD45C);
  static const Color error = Color(0xFFFF7A7A);
}
