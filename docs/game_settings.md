# Block Change — Settings & Local Persistence Specification

## 1. Overview
Player preferences in **Block Change** are managed centrally by `SettingsService` and serialized locally via `SharedPreferencesStorage` under storage key `block_change_game_settings_v1`.

---

## 2. Game Settings Data Model (`GameSettingsModel`)

| Field Name | Type | Default Value | Description |
|---|---|---|---|
| `musicEnabled` | `bool` | `true` | Master toggle for background music playback |
| `musicVolume` | `double` | `0.7` | Music volume scaling factor (0.0 to 1.0) |
| `sfxEnabled` | `bool` | `true` | Master toggle for sound effects playback |
| `sfxVolume` | `double` | `0.85` | SFX volume scaling factor (0.0 to 1.0) |
| `hapticsEnabled` | `bool` | `true` | Master toggle for tactile haptic feedback |
| `hapticIntensity` | `HapticIntensity` | `medium` | Haptic pulse level (`low`, `medium`, `high`) |
| `showTutorial` | `bool` | `true` | Toggle contextual gameplay tutorial banner |
| `reducedMotion` | `bool` | `false` | Damps scale animations & heavy haptic pulses |
| `selectedSkinId` | `String` | `'classic'` | Currently equipped cosmetic skin ID |
| `selectedThemeId` | `String` | `'classic_dark'` | Currently equipped visual environment theme ID |

---

## 3. Persistence & Safety Guards
- Settings updates are debounced and written asynchronously to avoid blocking the main UI thread during gameplay.
- Volume values are strictly clamped ($0.0 \le \text{vol} \le 1.0$).
- Settings survive application restart, process termination, and device reboot.
