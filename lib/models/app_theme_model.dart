import 'package:flutter/material.dart';

/// Catalog model defining visual environment themes (backgrounds, surfaces, HUD, card accents).
class AppThemeModel {
  final String id;
  final String name;
  final String description;
  final LinearGradient backgroundGradient;
  final Color surfaceColor;
  final Color cardColor;
  final Color primaryAccent;
  final Color secondaryAccent;
  final Color textPrimary;
  final Color textSecondary;
  final Color boardFrameColor;

  const AppThemeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.backgroundGradient,
    required this.surfaceColor,
    required this.cardColor,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.boardFrameColor,
  });
}
