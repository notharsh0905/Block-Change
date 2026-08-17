import 'package:flutter/material.dart';

import '../models/app_theme_model.dart';
import '../models/game_settings_model.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';
import '../services/settings_service.dart';
import '../services/theme_service.dart';

/// Full Settings screen allowing player customization of Audio, Haptics, Gameplay, Theme, & Accessibility.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<GameSettingsModel>(
      valueListenable: SettingsService.instance.settingsNotifier,
      builder: (context, settings, _) {
        final theme = ThemeService.instance.equippedTheme;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: theme.backgroundGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // Custom Header
                  _buildHeader(context, theme),

                  // Main Settings Scrollable Body
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      children: [
                        _buildAudioSection(context, settings, theme),
                        const SizedBox(height: 20.0),
                        _buildHapticsSection(context, settings, theme),
                        const SizedBox(height: 20.0),
                        _buildGameplaySection(context, settings, theme),
                        const SizedBox(height: 20.0),
                        _buildThemeSection(context, settings, theme),
                        const SizedBox(height: 20.0),
                        _buildAboutSection(context, theme),
                        const SizedBox(height: 32.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
            'Settings',
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

  Widget _buildSectionCard({
    required AppThemeModel theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: theme.boardFrameColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.primaryAccent, size: 22.0),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAudioSection(
    BuildContext context,
    GameSettingsModel settings,
    AppThemeModel theme,
  ) {
    return _buildSectionCard(
      theme: theme,
      title: 'AUDIO',
      icon: Icons.volume_up_rounded,
      children: [
        // Music Switch
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: theme.primaryAccent,
          title: Text(
            'Background Music',
            style: TextStyle(color: theme.textPrimary),
          ),
          value: settings.musicEnabled,
          onChanged: (val) {
            AudioService.instance.playButtonTap();
            HapticService.instance.buttonPress();
            SettingsService.instance.update(musicEnabled: val);
          },
        ),

        // Music Volume Slider
        if (settings.musicEnabled) ...[
          Row(
            children: [
              Icon(
                Icons.music_note_rounded,
                color: theme.textSecondary,
                size: 18.0,
              ),
              Expanded(
                child: Slider(
                  value: settings.musicVolume,
                  activeColor: theme.primaryAccent,
                  inactiveColor: theme.cardColor,
                  onChanged: (val) {
                    SettingsService.instance.update(musicVolume: val);
                  },
                ),
              ),
              Text(
                '${(settings.musicVolume * 100).round()}%',
                style: TextStyle(color: theme.textSecondary, fontSize: 13.0),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
        ],

        // SFX Switch
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: theme.primaryAccent,
          title: Text(
            'Sound Effects',
            style: TextStyle(color: theme.textPrimary),
          ),
          value: settings.sfxEnabled,
          onChanged: (val) {
            AudioService.instance.playButtonTap();
            HapticService.instance.buttonPress();
            SettingsService.instance.update(sfxEnabled: val);
          },
        ),

        // SFX Volume Slider
        if (settings.sfxEnabled) ...[
          Row(
            children: [
              Icon(
                Icons.graphic_eq_rounded,
                color: theme.textSecondary,
                size: 18.0,
              ),
              Expanded(
                child: Slider(
                  value: settings.sfxVolume,
                  activeColor: theme.primaryAccent,
                  inactiveColor: theme.cardColor,
                  onChangeEnd: (_) {
                    AudioService.instance.playTileTap();
                  },
                  onChanged: (val) {
                    SettingsService.instance.update(sfxVolume: val);
                  },
                ),
              ),
              Text(
                '${(settings.sfxVolume * 100).round()}%',
                style: TextStyle(color: theme.textSecondary, fontSize: 13.0),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildHapticsSection(
    BuildContext context,
    GameSettingsModel settings,
    AppThemeModel theme,
  ) {
    return _buildSectionCard(
      theme: theme,
      title: 'HAPTIC FEEDBACK',
      icon: Icons.vibration_rounded,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: theme.primaryAccent,
          title: Text(
            'Haptics Enabled',
            style: TextStyle(color: theme.textPrimary),
          ),
          value: settings.hapticsEnabled,
          onChanged: (val) {
            AudioService.instance.playButtonTap();
            HapticService.instance.buttonPress();
            SettingsService.instance.update(hapticsEnabled: val);
          },
        ),
        if (settings.hapticsEnabled) ...[
          const SizedBox(height: 8.0),
          Text(
            'Intensity',
            style: TextStyle(color: theme.textSecondary, fontSize: 14.0),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: HapticIntensity.values.map((intensity) {
              final isSelected = settings.hapticIntensity == intensity;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? theme.primaryAccent
                          : theme.cardColor,
                      foregroundColor: isSelected
                          ? Colors.white
                          : theme.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: isSelected ? 4.0 : 0.0,
                    ),
                    onPressed: () {
                      AudioService.instance.playButtonTap();
                      SettingsService.instance.update(
                        hapticIntensity: intensity,
                      );
                      HapticService.instance.tileTap();
                    },
                    child: Text(
                      intensity.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildGameplaySection(
    BuildContext context,
    GameSettingsModel settings,
    AppThemeModel theme,
  ) {
    return _buildSectionCard(
      theme: theme,
      title: 'GAMEPLAY & ACCESSIBILITY',
      icon: Icons.accessibility_new_rounded,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: theme.primaryAccent,
          title: Text(
            'Show Interactive Tutorial',
            style: TextStyle(color: theme.textPrimary),
          ),
          value: settings.showTutorial,
          onChanged: (val) {
            AudioService.instance.playButtonTap();
            HapticService.instance.buttonPress();
            SettingsService.instance.update(showTutorial: val);
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: theme.primaryAccent,
          title: Text(
            'Reduced Motion',
            style: TextStyle(color: theme.textPrimary),
          ),
          subtitle: Text(
            'Damps scale animations & heavy haptic pulses',
            style: TextStyle(color: theme.textSecondary, fontSize: 12.0),
          ),
          value: settings.reducedMotion,
          onChanged: (val) {
            AudioService.instance.playButtonTap();
            HapticService.instance.buttonPress();
            SettingsService.instance.update(reducedMotion: val);
          },
        ),
      ],
    );
  }

  Widget _buildThemeSection(
    BuildContext context,
    GameSettingsModel settings,
    AppThemeModel theme,
  ) {
    final allThemes = ThemeService.allThemes;

    return _buildSectionCard(
      theme: theme,
      title: 'ENVIRONMENT THEME',
      icon: Icons.palette_rounded,
      children: [
        SizedBox(
          height: 110.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allThemes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12.0),
            itemBuilder: (context, index) {
              final itemTheme = allThemes[index];
              final isEquipped = settings.selectedThemeId == itemTheme.id;

              return GestureDetector(
                onTap: () {
                  AudioService.instance.playButtonTap();
                  HapticService.instance.buttonPress();
                  ThemeService.instance.equipTheme(itemTheme);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 140.0,
                  decoration: BoxDecoration(
                    gradient: itemTheme.backgroundGradient,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: isEquipped
                          ? theme.primaryAccent
                          : Colors.transparent,
                      width: isEquipped ? 3.0 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              color: itemTheme.primaryAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (isEquipped)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryAccent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        itemTheme.name,
                        style: TextStyle(
                          color: itemTheme.textPrimary,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, AppThemeModel theme) {
    return _buildSectionCard(
      theme: theme,
      title: 'ABOUT BLOCK CHANGE',
      icon: Icons.info_rounded,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Game Version', style: TextStyle(color: theme.textSecondary)),
            Text(
              '1.0.0+1',
              style: TextStyle(
                color: theme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Architecture', style: TextStyle(color: theme.textSecondary)),
            Text(
              'Clean Engine v5.0',
              style: TextStyle(
                color: theme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Campaign Levels',
              style: TextStyle(color: theme.textSecondary),
            ),
            Text(
              '100 / 100 Solvable',
              style: TextStyle(
                color: theme.primaryAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Text(
          'Developed by Google DeepMind Advanced Agentic Coding.\nAudio SFX & Music: Synthesized PCM 44.1kHz WAV Royalty-Free Assets.',
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 11.0,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
