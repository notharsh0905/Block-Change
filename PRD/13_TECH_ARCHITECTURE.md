# 13. TECHNICAL ARCHITECTURE

## 13.1 Stack

-   Flutter
-   Dart
-   Android
-   Google Mobile Ads
-   Google Play Billing-compatible Flutter package
-   Local storage
-   Connectivity/reachability package
-   Audio package
-   No backend.

## 13.2 Architecture layers

### Presentation

Screens/widgets/theme.

### Application/state

Controllers/notifiers/state objects.

### Domain

GameEngine, level rules, validation, progression.

### Data

Level definitions, skin definitions, local persistence.

### Services

Ads, billing, audio, connectivity, haptics.

## 13.3 Game engine contract

UI sends user actions: - tapTile - pause - resume - restart.

Game engine produces state: - board - timer - target - moves - score -
freeze - locks - status.

UI renders state.

Do not mutate board state directly inside UI widgets.

## 13.4 State management

Choose one coherent Flutter state management approach and use it
consistently.

Do not install multiple state-management libraries without
justification.

For this game's scale, a lightweight built-in/notifier architecture is
acceptable.

## 13.5 Timing

Use elapsed-time based timers and a centralized game tick/controller.

Avoid dozens of independent Timer objects per tile.

## 13.6 Determinism

Level state should be reproducible from level seed + rules version.

## 13.7 Error handling

Service failures: - return typed/known states where possible, - log
diagnostics in debug, - display user-friendly messages.

Do not swallow exceptions silently.

## 13.8 Threading/isolation

Do not introduce isolates unless profiling demonstrates a real need.

The game board is small enough for normal Flutter execution.

## 13.9 Performance target

Target smooth 60 FPS on a typical mid-range Android phone.

Avoid: - unnecessary rebuilds, - oversized images, - expensive per-frame
allocations, - continuous particle storms, - memory leaks.

## 13.10 Security boundary

Client-side game logic is not secure against a determined user because
the app runs on their device.

The goal is casual integrity and correct monetization flow, not
impossible-to-bypass anti-cheat.
