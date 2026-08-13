# 20. ANTIGRAVITY IMPLEMENTATION CONTRACT

## READ THIS FIRST

Before changing code: 1. Read all PRD files. 2. Inspect existing project
files. 3. Inspect the original Lua `main.lua` supplied by the developer.
4. Understand the prototype's behavior. 5. Build a migration map from
Lua behavior to Flutter architecture. 6. Do not copy the single-file
architecture into Flutter.

## Primary goal

Transform the prototype into a production-quality Android game while
preserving the intended core gameplay and improving: - UI, -
animations, - architecture, - responsiveness, - accessibility, -
reliability, - monetization, - level design.

## Non-negotiable constraints

-   Flutter + Dart.
-   Android portrait.
-   100+ campaign levels.
-   No backend.
-   No authentication.
-   No custom game server.
-   Local persistence.
-   Internet required while app is in use.
-   Connectivity loss blocks gameplay.
-   Test AdMob IDs in development.
-   Production AdMob IDs only in release.
-   Google Play Billing for Remove Ads.
-   Voluntary rewarded ads.
-   No pay-to-win.
-   Cosmetic skins only.
-   main.dart must remain small.
-   No giant monolithic widget.
-   No giant game file.
-   No raw emoji for core game icons.

## Implementation phases

### Phase A --- Bootstrap

-   Create Flutter project.
-   Configure Android.
-   Add PRD directory.
-   Configure assets.
-   Set portrait orientation.
-   Add basic theme.
-   Add environment/config structure.

### Phase B --- Domain

-   Implement models.
-   Implement game rules.
-   Implement game engine.
-   Implement board.
-   Implement tile interactions.
-   Implement win.
-   Implement timer.
-   Implement pause.
-   Implement chaos.
-   Implement special tiles.

### Phase C --- Levels

-   Implement level schema.
-   Implement all 100 levels.
-   Implement level validator.
-   Validate every level.
-   Implement progression and stars.

### Phase D --- UI

-   Home.
-   Level map.
-   Gameplay.
-   Completion.
-   Time Up.
-   Settings.
-   Shop.
-   How to Play.
-   Offline screen.

### Phase E --- Polish

-   2.5D visuals.
-   animations.
-   audio.
-   haptics.
-   responsive layouts.
-   accessibility.
-   dark/light theme.

### Phase F --- Monetization

-   AdMob test ads.
-   banner.
-   interstitial.
-   rewarded.
-   purchase.
-   Remove Ads.
-   restore purchase.

### Phase G --- QA

-   unit tests.
-   widget tests.
-   integration tests.
-   physical-device tests.
-   network tests.
-   purchase tests.
-   ad tests.

### Phase H --- Release

-   remove debug tools.
-   verify production configuration.
-   clean.
-   build signed AAB.
-   internal test.
-   fix release blockers.
-   Play Console preparation.

## Coding rules

-   Use clear names.
-   Avoid unnecessary abstractions.
-   Avoid magic numbers.
-   Use constants/config.
-   Keep business logic outside UI.
-   Keep services independent.
-   Prefer immutable state where practical.
-   Dispose controllers/listeners.
-   Handle async lifecycle safely.
-   Avoid memory leaks.
-   Do not add unused dependencies.
-   Do not hide compiler/analyzer warnings.
-   Do not comment out broken code and call it finished.

## Error handling

Never present stack traces to users.

Debug: - log diagnostic context.

Production: - friendly UI.

## Testing rule

After every meaningful feature: 1. format, 2. analyze, 3. run relevant
tests, 4. manually test the changed behavior, 5. commit.

## Git rule

Create small meaningful commits.

Do NOT manufacture empty/no-op commits solely to generate green
contribution dots.

Good: - `feat: add game tile model` - `feat: implement bomb mechanic` -
`test: add bomb engine tests` - `fix: pause timer during offline state`

Bad: - empty commits, - repeated whitespace commits, - fake "progress"
commits.

## Decision rule

If a new implementation idea is not in the PRD: - if it is an internal
implementation detail, choose the simplest maintainable approach; - if
it changes product behavior, stop and document it before proceeding.

## Do not finish with placeholders

Core requirements must be implemented, not left as: - TODO, - FIXME, -
dummy buttons, - fake ads, - fake purchases, - hardcoded "purchase
successful", - nonfunctional settings.

## Final code quality gate

Before declaring the project complete: - run analyzer, - run tests, -
build release, - inspect logs, - manually play all worlds, - test
offline interruption, - test ads, - test purchase, - test restore, -
verify no debug menu, - verify no test ad IDs in production.
