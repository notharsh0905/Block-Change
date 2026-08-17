import 'package:flutter/material.dart';

import '../models/app_theme_model.dart';
import '../models/skin_model.dart';
import '../models/tile_model.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';
import '../services/skin_service.dart';
import '../services/theme_service.dart';
import '../widgets/skin_tile_decorator.dart';

/// Cosmetic Skin selection and preview gallery screen.
class SkinSelectionScreen extends StatefulWidget {
  const SkinSelectionScreen({super.key});

  @override
  State<SkinSelectionScreen> createState() => _SkinSelectionScreenState();
}

class _SkinSelectionScreenState extends State<SkinSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeService.instance.equippedTheme;
    final allSkins = SkinService.allSkins;
    final equippedSkin = SkinService.instance.equippedSkin;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, theme),

              // Skin Gallery Grid
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  itemCount: allSkins.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final skin = allSkins[index];
                    final isEquipped = skin.id == equippedSkin.id;
                    final isUnlocked = SkinService.instance.isSkinUnlocked(skin);

                    return _buildSkinCard(
                      context: context,
                      skin: skin,
                      isEquipped: isEquipped,
                      isUnlocked: isUnlocked,
                      theme: theme,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppThemeModel theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: theme.textPrimary,
            onPressed: () {
              AudioService.instance.playButtonTap();
              HapticService.instance.buttonPress();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 8.0),
          Text(
            'Skin Gallery',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkinCard({
    required BuildContext context,
    required SkinModel skin,
    required bool isEquipped,
    required bool isUnlocked,
    required AppThemeModel theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isEquipped ? theme.primaryAccent : theme.boardFrameColor.withOpacity(0.3),
          width: isEquipped ? 2.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Skin Preview Box (4 Sample Tiles)
          _buildPreviewBox(skin, theme),
          const SizedBox(width: 16.0),

          // Skin Info & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        skin.name,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusBadge(skin, isEquipped, isUnlocked, theme),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  skin.description,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 12.0,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12.0),

                // Action Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEquipped
                          ? theme.cardColor
                          : isUnlocked
                              ? theme.primaryAccent
                              : theme.cardColor.withOpacity(0.5),
                      foregroundColor: isEquipped
                          ? theme.textSecondary
                          : isUnlocked
                              ? Colors.white
                              : theme.textSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: isUnlocked && !isEquipped
                        ? () async {
                            AudioService.instance.playButtonTap();
                            HapticService.instance.buttonPress();
                            await SkinService.instance.equipSkin(skin);
                            setState(() {});
                          }
                        : null,
                    child: Text(
                      isEquipped
                          ? 'EQUIPPED'
                          : isUnlocked
                              ? 'EQUIP'
                              : skin.unlockRequirementText,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewBox(SkinModel skin, AppThemeModel theme) {
    const sampleColors = [0, 1, 2, 3]; // Red, Green, Blue, Yellow
    const tileColors = [
      Color(0xFFFF5E62),
      Color(0xFF00F5D4),
      Color(0xFF00BBF9),
      Color(0xFFFFD200),
    ];

    return Container(
      width: 72.0,
      height: 72.0,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(4, (i) {
          final dummyTile = TileModel(
            row: i ~/ 2,
            col: i % 2,
            colorIndex: sampleColors[i],
            type: TileType.normal,
          );

          return SkinTileDecorator(
            skin: skin,
            tile: dummyTile,
            child: Container(
              decoration: BoxDecoration(
                color: tileColors[i],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatusBadge(
    SkinModel skin,
    bool isEquipped,
    bool isUnlocked,
    AppThemeModel theme,
  ) {
    if (isEquipped) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: theme.primaryAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'EQUIPPED',
          style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (isUnlocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.green, width: 1.0),
        ),
        child: const Text(
          'UNLOCKED',
          style: TextStyle(color: Colors.greenAccent, fontSize: 10.0, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.orange.withOpacity(0.5), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_rounded, size: 10.0, color: Colors.orangeAccent),
          const SizedBox(width: 4.0),
          Text(
            skin.unlockRequirementText,
            style: const TextStyle(color: Colors.orangeAccent, fontSize: 9.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
