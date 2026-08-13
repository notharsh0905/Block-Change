# 12. LOCAL STORAGE AND STATE

## 12.1 Persistent data

Save: - highest unlocked level, - per-level completion, - stars, - best
moves, - best remaining time, - selected skin, - owned skins, -
settings, - appearance mode, - Color Assist, - purchase entitlement
cache, - schema version.

## 12.2 Not saved

Do not persist transient gameplay state by default: - every animation
frame, - temporary particles, - active ad object, - connectivity
object, - UI route stack.

## 12.3 Safe level recovery

If Android kills the app: - restore progress safely, - do not corrupt
completion data, - the current active level may restart unless a robust
checkpoint design is explicitly implemented.

Recommended v1: - persist completed-level progress immediately after
completion, - do not persist every active-board mutation.

## 12.4 Storage migration

Include schema version.

If future versions add fields: - migrate safely, - preserve existing
progress.

## 12.5 Data reset

A future "Reset Progress" option is optional.

If implemented: - clearly warn, - require confirmation, - explain that
it cannot be undone.

## 12.6 Purchase entitlement

Purchase state should be verified through platform APIs where
appropriate.

Local storage can cache the last known entitlement for UX but should not
become the sole authoritative proof when the billing API is available.
