import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/game_settings_model.dart';
import 'settings_service.dart';

/// Callback signature for audio playback interception in unit tests.
typedef AudioPlaybackCallback = void Function(String assetPath, double volume, bool isMusic);

/// Centralized audio management service backing all game SFX and ambient music.
class AudioService {
  static AudioService? _instance;
  static AudioService get instance => _instance ??= AudioService._();

  final SettingsService _settingsService;
  final AudioPlaybackCallback? _testCallback;

  AudioPlayer? _sfxPlayer;
  AudioPlayer? _musicPlayer;

  String? _currentMusicAsset;
  bool _isMusicPlaying = false;

  AudioService._({
    SettingsService? settingsService,
    AudioPlaybackCallback? testCallback,
  })  : _settingsService = settingsService ?? SettingsService.instance,
        _testCallback = testCallback {
    _initPlayers();
    _settingsService.settingsNotifier.addListener(_onSettingsChanged);
  }

  /// Testing constructor for injecting custom SettingsService or intercepting audio triggers.
  factory AudioService.withSettings(
    SettingsService settingsService, {
    AudioPlaybackCallback? onPlayback,
  }) {
    return AudioService._(
      settingsService: settingsService,
      testCallback: onPlayback,
    );
  }

  @visibleForTesting
  static void resetInstanceForTesting({AudioService? testInstance}) {
    _instance?._dispose();
    _instance = testInstance;
  }

  void _initPlayers() {
    if (kIsWeb || !kDebugMode && defaultTargetPlatform == TargetPlatform.android) {
      // Standard runtime initialization
    }
    try {
      _sfxPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      _musicPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      debugPrint('AudioPlayer initialization notice (ignored in test mode): $e');
    }
  }

  void _dispose() {
    try {
      _settingsService.settingsNotifier.removeListener(_onSettingsChanged);
      _sfxPlayer?.dispose();
      _musicPlayer?.dispose();
    } catch (_) {}
  }

  GameSettingsModel get _settings => _settingsService.currentSettings;

  void _onSettingsChanged() {
    final settings = _settings;
    if (!settings.musicEnabled || settings.musicVolume <= 0) {
      stopMusic();
    } else if (_isMusicPlaying && _musicPlayer != null) {
      try {
        _musicPlayer!.setVolume(settings.musicVolume);
      } catch (_) {}
    }
  }

  /// Helper to trigger sound effect playback safely.
  Future<void> _playSfx(String assetPath) async {
    final settings = _settings;
    if (!settings.sfxEnabled || settings.sfxVolume <= 0) return;

    if (_testCallback != null) {
      _testCallback!(assetPath, settings.sfxVolume, false);
      return;
    }

    try {
      if (_sfxPlayer != null) {
        await _sfxPlayer!.stop();
        await _sfxPlayer!.setVolume(settings.sfxVolume);
        await _sfxPlayer!.play(AssetSource(assetPath));
      }
    } catch (e) {
      debugPrint('AudioService SFX playback notice: $e');
    }
  }

  /// Helper to manage background music playback safely.
  Future<void> _playMusic(String assetPath, {bool loop = true}) async {
    final settings = _settings;
    if (!settings.musicEnabled || settings.musicVolume <= 0) return;

    if (_currentMusicAsset == assetPath && _isMusicPlaying) return;

    if (_testCallback != null) {
      _testCallback!(assetPath, settings.musicVolume, true);
      _currentMusicAsset = assetPath;
      _isMusicPlaying = true;
      return;
    }

    try {
      if (_musicPlayer != null) {
        await _musicPlayer!.stop();
        await _musicPlayer!.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
        await _musicPlayer!.setVolume(settings.musicVolume);
        await _musicPlayer!.play(AssetSource(assetPath));
        _currentMusicAsset = assetPath;
        _isMusicPlaying = true;
      }
    } catch (e) {
      debugPrint('AudioService Music playback notice: $e');
    }
  }

  /// Stops current music playback.
  Future<void> stopMusic() async {
    _isMusicPlaying = false;
    _currentMusicAsset = null;
    if (_testCallback != null) return;
    try {
      await _musicPlayer?.stop();
    } catch (_) {}
  }

  /// Pauses current music playback.
  Future<void> pauseMusic() async {
    if (!_isMusicPlaying) return;
    if (_testCallback != null) return;
    try {
      await _musicPlayer?.pause();
    } catch (_) {}
  }

  /// Resumes current music playback.
  Future<void> resumeMusic() async {
    if (_currentMusicAsset == null) return;
    final settings = _settings;
    if (!settings.musicEnabled || settings.musicVolume <= 0) return;

    if (_testCallback != null) {
      _isMusicPlaying = true;
      return;
    }

    try {
      await _musicPlayer?.resume();
      _isMusicPlaying = true;
    } catch (_) {}
  }

  // --- Semantic Sound Effect Methods ---

  Future<void> playTileTap() => _playSfx('audio/sfx/tile_tap.wav');
  Future<void> playColorChange() => _playSfx('audio/sfx/color_change.wav');
  Future<void> playBomb() => _playSfx('audio/sfx/bomb_explode.wav');
  Future<void> playFreeze() => _playSfx('audio/sfx/freeze.wav');
  Future<void> playLock() => _playSfx('audio/sfx/lock_tap.wav');
  Future<void> playLockedTap() => _playSfx('audio/sfx/lock_tap.wav');
  Future<void> playLevelComplete() => _playSfx('audio/sfx/level_complete.wav');
  Future<void> playStarReveal() => _playSfx('audio/sfx/star_reveal.wav');
  Future<void> playButtonTap() => _playSfx('audio/sfx/button_click.wav');
  Future<void> playLevelStart() => _playSfx('audio/sfx/level_start.wav');
  Future<void> playCountdownWarning() => _playSfx('audio/sfx/timer_warning.wav');
  Future<void> playGameOver() => _playSfx('audio/sfx/game_over.wav');

  // --- Semantic Background Music Methods ---

  Future<void> playMenuMusic() => _playMusic('audio/music/menu_theme.wav', loop: true);
  Future<void> playGameplayMusic() => _playMusic('audio/music/gameplay_theme.wav', loop: true);
  Future<void> playVictoryMusic() => _playMusic('audio/music/victory_stinger.wav', loop: false);
}
