# 5. UI/UX DESIGN

## 5.1 Global layout

Portrait only.

Design for: - small Android phones, - standard phones, - tall phones, -
display cutouts, - system navigation bars.

Use SafeArea and responsive constraints.

Do not use hardcoded 700x900 coordinates from the Lua prototype.

## 5.2 Splash

Elements: - Block Change logo - small animated block motif - subtle
loading state if initialization is required.

Keep splash short.

Before entering Home, verify: - local storage initialization, - required
service initialization, - internet availability.

## 5.3 Offline blocking screen

This is a mandatory state.

### When shown

-   launch without internet,
-   internet lost while app active,
-   required online service unavailable if the feature genuinely
    requires it.

### During gameplay

Overlay must pause the level immediately and disable input.

### Copy

Title: **No Internet Connection**

Body: **Block Change requires an internet connection. Please turn on
Wi‑Fi or mobile data to continue.**

Primary: **Retry**

Optional secondary: **Open Settings** only if platform behavior makes it
appropriate.

### Behavior

Retry performs a fresh reachability check.

If online: - dismiss overlay, - restore safe paused state, - user
explicitly resumes if required.

If offline: - remain blocked.

Do not allow bypassing the overlay.

## 5.4 Home

Primary elements: - logo - Play / Continue - Level Map - Skins/Shop -
Settings

Secondary: - progress summary - stars - current world - optional
cosmetic showcase.

## 5.5 Level map

Map should visually communicate: - completed levels, - current level, -
unlocked levels, - locked levels, - stars, - world boundaries, - world
completion.

Node states: - locked, - unlocked, - current, - completed 1-star, -
completed 2-star, - completed 3-star.

Use a path/journey concept.

## 5.6 Gameplay HUD

Top: - level name/number - target color - timer - pause

Optional: - move count - score.

Board: - centered, - responsive, - largest safe size.

Bottom: - reserved banner area where active.

Do not allow ads to cover the board.

## 5.7 Tile visuals

Each tile: - rounded shape, - subtle depth, - highlight, - soft
shadow, - clear color identity, - special tile indicator.

Special icons must not rely on emoji because emoji rendering differs by
Android device. Use bundled vector/raster assets.

## 5.8 Pause

Show: - Resume - Restart - Level Map

Background gameplay should be visually dimmed.

## 5.9 Time Up

Show: - "Time Up" - final progress - Try Again - Watch Ad +15 sec - Back
to Map

Rewarded ad must be clearly labeled as optional.

## 5.10 Level Complete

Show: - celebratory animation - star sequence - score/moves/time
summary - Next Level - Replay - Map

If next level is unlocked, emphasize Next Level.

## 5.11 Shop/Skins

Sections: - Owned - Unlockable - Premium

Each skin: - large preview - name - unlock method - action button.

Examples: - "Watch Ad" - "Purchase" - "Equipped" - "Equip"

Do not hide pricing.

## 5.12 Settings

Sections: Audio: - Music - Sound Effects - Haptics

Appearance: - System - Light - Dark

Accessibility: - Color Assist

Account: - no account exists.

Purchases: - Restore Purchases

Legal: - Privacy Policy - Terms if required

## 5.13 Navigation

Use standard Flutter navigation/state management appropriate to
architecture.

Prevent accidental duplicate routes.

## 5.14 Error UI

Never expose raw exceptions.

Friendly error: "Something went wrong. Please try again."

Developer logs may contain diagnostic detail in debug builds only.
