# 15. DEPENDENCIES AND CONFIGURATION

## 15.1 Dependency philosophy

Use the smallest stable dependency set.

Do not add packages merely because an AI assistant suggests them.

Before adding: - verify Flutter compatibility, - verify Android
compatibility, - verify maintenance status, - check license, - check
whether Flutter already provides the functionality.

## 15.2 Functional dependencies

Expected categories: - Google Mobile Ads - In-app purchase / Google Play
Billing integration - local preferences/storage - connectivity - audio -
optional animation utility.

Exact package versions must be resolved against the current Flutter
stable environment at implementation time.

## 15.3 Configuration

`config.dart`: - app name - version/environment flags - feature flags.

`ad_config.dart`: - test banner ID - test interstitial ID - test
rewarded ID - production IDs placeholders/configuration.

`game_config.dart`: - minimum/maximum grid - color count - freeze
duration - lock duration - rewarded extra time - default timing
constants - ad frequency configuration.

`theme_config.dart`: - design tokens.

## 15.4 Test/prod separation

The development environment must default to: - debug mode, - test ads, -
verbose diagnostics.

Release must: - use production ad IDs, - disable debug menu, - disable
test shortcuts, - reduce debug logging.

Never commit secrets or private credentials.

## 15.5 Product IDs

Example: `remove_ads`

Cosmetic products should have stable IDs such as: `skin_panda`
`skin_space` `skin_candy`

Final IDs must be registered consistently in Play Console and source
configuration.
