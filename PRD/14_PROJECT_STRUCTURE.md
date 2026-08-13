# 14. PROJECT STRUCTURE

``` text
block_change/
├── android/
├── assets/
│   ├── images/
│   ├── icons/
│   ├── skins/
│   ├── sounds/
│   └── music/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── config/
│   │   ├── config.dart
│   │   ├── ad_config.dart
│   │   ├── game_config.dart
│   │   └── theme_config.dart
│   │
│   ├── models/
│   │   ├── level_model.dart
│   │   ├── tile_model.dart
│   │   ├── skin_model.dart
│   │   ├── player_progress.dart
│   │   └── game_state_model.dart
│   │
│   ├── game/
│   │   ├── game_engine.dart
│   │   ├── level_generator.dart
│   │   ├── level_validator.dart
│   │   ├── chaos_manager.dart
│   │   ├── tile_manager.dart
│   │   ├── star_calculator.dart
│   │   └── game_rules.dart
│   │
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── offline_screen.dart
│   │   ├── home_screen.dart
│   │   ├── level_map_screen.dart
│   │   ├── gameplay_screen.dart
│   │   ├── shop_screen.dart
│   │   ├── settings_screen.dart
│   │   └── how_to_play_screen.dart
│   │
│   ├── widgets/
│   │   ├── game_tile.dart
│   │   ├── game_board.dart
│   │   ├── game_button.dart
│   │   ├── level_node.dart
│   │   ├── star_rating.dart
│   │   ├── timer_display.dart
│   │   ├── target_indicator.dart
│   │   ├── ad_banner.dart
│   │   └── dialogs/
│   │
│   ├── services/
│   │   ├── ad_service.dart
│   │   ├── purchase_service.dart
│   │   ├── audio_service.dart
│   │   ├── storage_service.dart
│   │   ├── connectivity_service.dart
│   │   └── haptic_service.dart
│   │
│   ├── data/
│   │   ├── levels.dart
│   │   ├── skins.dart
│   │   └── worlds.dart
│   │
│   └── theme/
│       ├── app_theme.dart
│       ├── app_colors.dart
│       ├── app_dimensions.dart
│       └── app_text_styles.dart
│
├── prd/
├── test/
│   ├── game/
│   ├── services/
│   ├── models/
│   └── widgets/
├── integration_test/
├── pubspec.yaml
└── README.md
```

## main.dart

Only: - Flutter initialization, - app bootstrap, - top-level error
handling if needed, - runApp.

Do not put game logic here.

## app.dart

Responsible for: - root MaterialApp/Cupertino configuration, - theme, -
routing, - global providers/state setup.
