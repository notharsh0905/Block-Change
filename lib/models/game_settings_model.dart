enum HapticIntensity { low, medium, high }

/// Model storing player preferences and game settings.
class GameSettingsModel {
  final bool musicEnabled;
  final double musicVolume; // 0.0 to 1.0
  final bool sfxEnabled;
  final double sfxVolume; // 0.0 to 1.0
  final bool hapticsEnabled;
  final HapticIntensity hapticIntensity;
  final bool showTutorial;
  final bool reducedMotion;
  final String selectedSkinId;
  final String selectedThemeId;

  const GameSettingsModel({
    this.musicEnabled = true,
    this.musicVolume = 0.7,
    this.sfxEnabled = true,
    this.sfxVolume = 0.85,
    this.hapticsEnabled = true,
    this.hapticIntensity = HapticIntensity.medium,
    this.showTutorial = true,
    this.reducedMotion = false,
    this.selectedSkinId = 'classic',
    this.selectedThemeId = 'classic_dark',
  });

  /// Default initial settings configuration.
  static const GameSettingsModel defaultSettings = GameSettingsModel();

  GameSettingsModel copyWith({
    bool? musicEnabled,
    double? musicVolume,
    bool? sfxEnabled,
    double? sfxVolume,
    bool? hapticsEnabled,
    HapticIntensity? hapticIntensity,
    bool? showTutorial,
    bool? reducedMotion,
    String? selectedSkinId,
    String? selectedThemeId,
  }) {
    return GameSettingsModel(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      musicVolume: (musicVolume ?? this.musicVolume).clamp(0.0, 1.0),
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      sfxVolume: (sfxVolume ?? this.sfxVolume).clamp(0.0, 1.0),
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      hapticIntensity: hapticIntensity ?? this.hapticIntensity,
      showTutorial: showTutorial ?? this.showTutorial,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      selectedSkinId: selectedSkinId ?? this.selectedSkinId,
      selectedThemeId: selectedThemeId ?? this.selectedThemeId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'musicEnabled': musicEnabled,
      'musicVolume': musicVolume,
      'sfxEnabled': sfxEnabled,
      'sfxVolume': sfxVolume,
      'hapticsEnabled': hapticsEnabled,
      'hapticIntensity': hapticIntensity.name,
      'showTutorial': showTutorial,
      'reducedMotion': reducedMotion,
      'selectedSkinId': selectedSkinId,
      'selectedThemeId': selectedThemeId,
    };
  }

  factory GameSettingsModel.fromJson(Map<String, dynamic> json) {
    HapticIntensity parseHaptics(dynamic val) {
      if (val is String) {
        return HapticIntensity.values.firstWhere(
          (e) => e.name == val,
          orElse: () => HapticIntensity.medium,
        );
      }
      return HapticIntensity.medium;
    }

    return GameSettingsModel(
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      musicVolume:
          (json['musicVolume'] as num?)?.toDouble().clamp(0.0, 1.0) ?? 0.7,
      sfxEnabled: json['sfxEnabled'] as bool? ?? true,
      sfxVolume:
          (json['sfxVolume'] as num?)?.toDouble().clamp(0.0, 1.0) ?? 0.85,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      hapticIntensity: parseHaptics(json['hapticIntensity']),
      showTutorial: json['showTutorial'] as bool? ?? true,
      reducedMotion: json['reducedMotion'] as bool? ?? false,
      selectedSkinId: json['selectedSkinId'] as String? ?? 'classic',
      selectedThemeId: json['selectedThemeId'] as String? ?? 'classic_dark',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSettingsModel &&
          runtimeType == other.runtimeType &&
          musicEnabled == other.musicEnabled &&
          musicVolume == other.musicVolume &&
          sfxEnabled == other.sfxEnabled &&
          sfxVolume == other.sfxVolume &&
          hapticsEnabled == other.hapticsEnabled &&
          hapticIntensity == other.hapticIntensity &&
          showTutorial == other.showTutorial &&
          reducedMotion == other.reducedMotion &&
          selectedSkinId == other.selectedSkinId &&
          selectedThemeId == other.selectedThemeId;

  @override
  int get hashCode =>
      musicEnabled.hashCode ^
      musicVolume.hashCode ^
      sfxEnabled.hashCode ^
      sfxVolume.hashCode ^
      hapticsEnabled.hashCode ^
      hapticIntensity.hashCode ^
      showTutorial.hashCode ^
      reducedMotion.hashCode ^
      selectedSkinId.hashCode ^
      selectedThemeId.hashCode;
}
