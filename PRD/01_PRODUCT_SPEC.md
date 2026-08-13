# 1. PRODUCT SPECIFICATION

## 1.1 Product vision

Block Change is a casual puzzle game built around a simple interaction:

> Tap blocks to change their colors and make the entire board match the
> target color.

The game becomes progressively more strategic through: - increasing
board sizes, - more colors, - controlled automatic chaos, - Bomb
tiles, - Freeze tiles, - Lock tiles, - limited time, - level-specific
constraints, - optional cosmetic skins.

The experience should be easy to understand in seconds but increasingly
difficult to master.

## 1.2 Target experience

The player should feel: - immediate understanding, - satisfying
feedback, - low cognitive friction, - increasing mastery, - pleasant
pressure, - rewarding completion, - curiosity about upcoming skins and
levels.

## 1.3 Product personality

Keywords: - cute - polished - responsive - energetic - friendly -
premium - clean - tactile - playful

Avoid: - clutter - excessive gradients - overly childish visuals -
aggressive monetization - visual noise - copying an existing brand.

## 1.4 Inspiration constraint

The requested UI direction is a high-level combination of: - playful
learning-app friendliness, - premium minimalist mobile UI, - subtle 2.5D
game depth.

Do not copy Duolingo, Apple, or any other game's exact interface,
characters, icons, typography, layouts, or assets.

## 1.5 Core loop

1.  Launch app.
2.  Validate internet availability.
3.  Load local progress.
4.  Home screen.
5.  Open Level Map.
6.  Select unlocked level.
7.  Read/skip contextual tutorial if applicable.
8.  Start level.
9.  Solve board before time expires.
10. Receive stars and completion feedback.
11. Save progress.
12. Unlock next level.
13. Continue or return to map.

## 1.6 Secondary loops

### Cosmetics

Play -\> earn/claim cosmetic unlocks -\> equip skin -\> continue
playing.

### Rewarded time

Time Up -\> optionally watch rewarded ad -\> receive one configured
extra-time reward -\> continue.

### Monetization

Play -\> encounter occasional interstitial/banner -\> optionally
purchase Remove Ads -\> banner/interstitial disabled.

## 1.7 Required screens

-   Splash
-   Connectivity/Offline Blocking
-   Home
-   Level Map
-   Gameplay
-   Pause
-   Time Up
-   Level Complete
-   Shop/Skins
-   Settings
-   How to Play
-   Purchase/Restore feedback dialogs
-   Generic error/retry dialog where necessary

## 1.8 Required settings

-   Music: On/Off
-   Sound Effects: On/Off
-   Haptics: On/Off
-   Appearance: System / Light / Dark
-   Color Assist: On/Off
-   Restore Purchases
-   Privacy Policy
-   Terms/Legal links if needed
-   Version number

## 1.9 Accessibility

Color is the core mechanic, so color-only communication must be avoided
where practical.

Color Assist may add: - shape symbols, - pattern overlays, - small
labels, - icon differences.

Do not make the accessibility layer visually ugly or distracting.

## 1.10 No backend

Do not add: - Firebase database, - custom API, - user accounts, -
server-side game state, - cloud save.

Third-party SDKs required for ads and billing are allowed because they
are platform monetization services, not a custom game backend.

Optional crash reporting/analytics must be explicitly approved before
adding it.

## 1.11 Offline policy

The game requires internet while being used.

Important distinction: - No custom server exists. - The app may use
network reachability and third-party online services. - User-facing copy
must not falsely claim the player is disconnected from a proprietary
Block Change server.

Recommended copy:

**No Internet Connection**

"Block Change requires an internet connection. Please turn on Wi‑Fi or
mobile data to continue."

Button: **Retry**

## 1.12 Monetization philosophy

The game must not become pay-to-win.

Allowed: - cosmetic purchases, - voluntary rewarded ads, - Remove Ads.

Do not sell: - guaranteed puzzle solutions, - impossible-to-lose
modes, - direct competitive advantages, - required paid consumables.

## 1.13 Launch scope

Minimum launch scope: - 100 campaign levels, - level map, - stars, -
four tile mechanics, - six or more colors, - at least seven skins, -
settings, - sound/music/haptics, - banner, - interstitial, - rewarded
ad, - Remove Ads, - local progress, - online requirement, - polished
tutorial, - production release configuration.
