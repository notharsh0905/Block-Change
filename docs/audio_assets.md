# Block Change — Audio Assets Specification & License Registry

## 1. Overview
The audio system in **Block Change** uses a centralized, non-blocking `AudioService` that responds reactively to `SettingsService` volume and enable toggles. Audio assets are stored locally as pristine 44.1kHz 16-bit Mono WAV PCM files to guarantee zero-latency playback across all Android hardware tiers.

---

## 2. Sound Effects (SFX) Catalog

| Filename | Purpose / Gameplay Event | Source / License | Format | Duration |
|---|---|---|---|---|
| `assets/audio/sfx/tile_tap.wav` | Tile selection tap feedback | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 50ms |
| `assets/audio/sfx/color_change.wav` | Color cycling state transition | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 120ms |
| `assets/audio/sfx/bomb_explode.wav` | 3x3 Bomb tile explosion impact | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 350ms |
| `assets/audio/sfx/freeze.wav` | Freeze tile timer shimmer | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 250ms |
| `assets/audio/sfx/lock_tap.wav` | Locked tile tapped (denied click) | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 80ms |
| `assets/audio/sfx/level_complete.wav` | Level victory fanfare chord | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 450ms |
| `assets/audio/sfx/star_reveal.wav` | Star reward sparkle chime | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 150ms |
| `assets/audio/sfx/button_click.wav` | Tactile UI button click | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 40ms |
| `assets/audio/sfx/level_start.wav` | Level transition swipe chime | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 250ms |
| `assets/audio/sfx/timer_warning.wav` | Countdown low timer pulse | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 150ms |
| `assets/audio/sfx/game_over.wav` | Time out / game over chime | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 400ms |

---

## 3. Background Music (BGM) Catalog

| Filename | Purpose / Screen Context | Source / License | Format | Duration | Loop |
|---|---|---|---|---|---|
| `assets/audio/music/menu_theme.wav` | Main menu & map atmosphere | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 1.5s | Yes |
| `assets/audio/music/gameplay_theme.wav` | Active gameplay puzzle theme | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 1.5s | Yes |
| `assets/audio/music/victory_stinger.wav` | Level completion celebration | Original Synthesized PCM (CC0) | WAV 44.1kHz 16-bit | 1.2s | No |

---

## 4. Licensing & Attribution Notice
All audio assets in `assets/audio/` were procedurally synthesized and authored specifically for **Block Change** under the **Creative Commons CC0 1.0 Universal (Public Domain Dedication)** license. They contain no copyrighted content and require no external royalty payments.
