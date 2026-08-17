import 'package:flutter/material.dart';

import '../models/skin_model.dart';
import '../models/tile_model.dart';

/// Renders cosmetic skin visual accents and pattern overlays on top of game tiles.
class SkinTileDecorator extends StatelessWidget {
  final SkinModel skin;
  final TileModel tile;
  final Widget child;

  const SkinTileDecorator({
    super.key,
    required this.skin,
    required this.tile,
    required this.child,
  });

  IconData? get _skinIcon {
    switch (skin.id) {
      case 'cute_cats':
        return Icons.pets_rounded;
      case 'puppies':
        return Icons.pets_rounded;
      case 'fruits':
        return Icons.eco_rounded;
      case 'desserts':
        return Icons.cake_rounded;
      case 'rainbow':
        return Icons.auto_awesome_rounded;
      case 'space':
        return Icons.star_rounded;
      case 'kawaii':
        return Icons.sentiment_very_satisfied_rounded;
      case 'ice':
        return Icons.ac_unit_rounded;
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'classic':
      default:
        return null;
    }
  }

  BoxDecoration? get _skinBorder {
    switch (skin.id) {
      case 'rainbow':
        return BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 2.0,
          ),
        );
      case 'ice':
        return BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFE0F7FA).withOpacity(0.6),
            width: 2.0,
          ),
        );
      case 'fire':
        return BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFFF6F00).withOpacity(0.6),
            width: 2.0,
          ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _skinIcon;
    final border = _skinBorder;

    return Stack(
      children: [
        child,
        if (border != null)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(decoration: border),
            ),
          ),
        if (icon != null && tile.type == TileType.normal)
          Positioned(
            right: 4.0,
            top: 4.0,
            child: IgnorePointer(
              child: Icon(
                icon,
                size: 14.0,
                color: Colors.white.withOpacity(0.35),
              ),
            ),
          ),
      ],
    );
  }
}
