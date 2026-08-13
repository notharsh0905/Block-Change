# BLOCK CHANGE --- ANTIGRAVITY MASTER PROMPT

You are implementing Block Change, a production Android puzzle game.

FIRST: read every file in the `prd/` folder. Do not start coding until
you understand the entire specification.

The PRD is the source of truth.

Core requirements: - Flutter/Dart - Android portrait - 100+ validated,
solvable levels - six+ logical colors - Normal, Bomb, Freeze, Lock -
level map and stars - skins including Cat and Dog - sound/music/haptics
with settings - banner/interstitial/rewarded AdMob - development uses
official Google test ad IDs - one-time Remove Ads purchase - local
progress - NO backend - NO authentication - active internet required
while app is being used - if internet is lost after launch, pause/block
gameplay and show a Retry offline overlay - no bypass in release - clean
modular architecture - main.dart must stay small

Before implementation, inspect the original Lua `main.lua` and use
`25_LUA_TO_FLUTTER_MAPPING.md` to preserve intended mechanics while
fixing prototype limitations.

Implement incrementally. After each meaningful unit: 1. format, 2.
analyze, 3. test, 4. manually verify, 5. make a focused Git commit.

Do not create fake/empty commits just to generate contribution dots.

Never use production ad IDs during development. Never fake a purchase
success. Never grant a rewarded-ad reward without the SDK completion
callback. Never ship impossible levels. Never allow active gameplay
while offline. Never expose raw exceptions to users. Never leave core
requirements as TODO placeholders.

When you believe the game is complete, run the entire Definition of Done
checklist in `22_DEFINITION_OF_DONE.md`.
