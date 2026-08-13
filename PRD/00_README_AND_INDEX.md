# BLOCK CHANGE --- DEVELOPMENT-READY PRD v1.1

## Purpose

This PRD is the single source of truth for rebuilding the existing
LOVE2D/Lua prototype as a polished Flutter Android game.

The implementation target is a real publishable product, not a
prototype.

## Product summary

**Working title:** Block Change\
**Platform:** Android\
**Orientation:** Portrait\
**Framework:** Flutter + Dart\
**Backend:** None\
**Authentication:** None\
**Game account:** None\
**Local persistence:** Yes\
**Internet:** Required while the app is being used\
**Ads:** Google Mobile Ads / AdMob\
**Purchase:** Google Play Billing / Flutter in-app purchase integration\
**Campaign:** 100+ levels\
**Visual direction:** Original playful + premium 2.5D mobile-game
aesthetic

## Non-negotiable product requirements

1.  The game must contain at least 100 campaign levels.
2.  Every campaign level must be solvable and tested/validated.
3.  Gameplay must remain portrait-first.
4.  The game must require an active internet connection.
5.  Internet loss after launch must immediately block active gameplay.
6.  No backend, custom server, authentication, or account system may be
    introduced.
7.  Development builds must use official Google test ad IDs.
8.  Production builds must use production AdMob IDs.
9.  Rewarded ads must be voluntary.
10. Interstitials must never interrupt active puzzle interaction.
11. A one-time Remove Ads purchase must disable banner and interstitial
    ads.
12. Skins are cosmetic and cannot alter gameplay difficulty or rules.
13. Progress and settings must survive app restarts through local
    storage.
14. The project must be modular; `main.dart` must remain a thin
    bootstrapper.
15. Debug-only tools must not ship in the production release.
16. Release readiness requires a signed Android App Bundle and Play
    Console testing.

## Source-of-truth rule

Antigravity must read every file in `prd/` before implementation. If two
requirements conflict, prefer: 1. safety/integrity requirements, 2.
explicit product requirements, 3. technical architecture, 4. visual
preferences.

Do not silently invent missing product behavior. Document implementation
decisions in the project notes.

## Document index

-   00_README_AND_INDEX.md --- master rules and definitions
-   01_PRODUCT_SPEC.md --- product scope and requirements
-   02_GAMEPLAY_RULES.md --- complete game mechanics
-   03_LEVEL_DESIGN_100.md --- campaign and difficulty plan
-   04_LEVEL_DATA_SCHEMA.md --- level representation and validation
-   05_UI_UX_DESIGN.md --- screens and interaction design
-   06_VISUAL_DESIGN_SYSTEM.md --- colors, typography, 2.5D styling
-   07_ANIMATION_SPEC.md --- animation and motion rules
-   08_AUDIO_HAPTICS_SPEC.md --- sound, music, haptics
-   09_SKINS_THEMES_SPEC.md --- cosmetic system
-   10_ADMOB_MONETIZATION.md --- ads and Remove Ads
-   11_CONNECTIVITY_OFFLINE_SPEC.md --- mandatory online behavior
-   12_LOCAL_STORAGE_STATE.md --- persistence and lifecycle
-   13_TECH_ARCHITECTURE.md --- Flutter architecture
-   14_PROJECT_STRUCTURE.md --- exact folders and responsibilities
-   15_DEPENDENCIES_CONFIG.md --- dependency/config rules
-   16_TESTING_QA.md --- test plan
-   17_SECURITY_ANTI_CHEAT.md --- realistic client-side protections
-   18_PLAY_STORE_RELEASE.md --- Android release checklist
-   19_PRIVACY_DATA_SAFETY.md --- privacy/data requirements
-   20_ANTIGRAVITY_INSTRUCTIONS.md --- AI implementation contract
-   21_GIT_WORKFLOW.md --- meaningful commit workflow
-   22_DEFINITION_OF_DONE.md --- release acceptance criteria
-   23_ASSET_PRODUCTION_GUIDE.md --- icons, sounds, artwork
-   24_ROADMAP_AND_STATUS.md --- build phases and progress tracking
-   25_LUA_TO_FLUTTER_MAPPING.md --- prototype-to-production mapping

## Current project status

Planning/design specification: complete for v1.1.

Implementation: not started in this PRD package.

After the PRD is placed into the Antigravity workspace, the
implementation process begins.
