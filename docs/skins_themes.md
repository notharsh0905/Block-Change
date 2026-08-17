# Block Change — Cosmetic Skins & Themes Specification

## 1. Overview
The cosmetic system in **Block Change** separates **Visual Themes** (application environment, background gradients, HUD cards) from **Tile Skins** (tile icon overlays, border treatments, shapes).

---

## 2. Cosmetic Tile Skins Catalog (10 Skins)

| Skin ID | Name | Unlock Method | Requirement / Milestone | Status |
|---|---|---|---|---|
| `classic` | Classic Blocks | `FREE` | Unlocked by Default | **Available** |
| `cute_cats` | Cute Cats | `REWARDED_AD` | Future Rewarded Ad Watch | **Future Ad Unlock** |
| `puppies` | Puppies | `REWARDED_AD` | Future Rewarded Ad Watch | **Future Ad Unlock** |
| `fruits` | Fruits | `REWARDED_AD` | Future Rewarded Ad Watch | **Future Ad Unlock** |
| `desserts` | Desserts | `REWARDED_AD` | Future Rewarded Ad Watch | **Future Ad Unlock** |
| `rainbow` | Rainbow | `LEVEL_PROGRESS` | Reach World 2 (Level 21) | **Progress Unlock** |
| `space` | Space | `LEVEL_PROGRESS` | Reach World 4 (Level 41) | **Progress Unlock** |
| `kawaii` | Kawaii | `LEVEL_PROGRESS` | Reach World 6 (Level 61) | **Progress Unlock** |
| `ice` | Ice | `LEVEL_PROGRESS` | Reach World 8 (Level 81) | **Progress Unlock** |
| `fire` | Fire | `LEVEL_PROGRESS` | Complete Campaign (Level 100) | **Progress Unlock** |

### Color Semantics Rule
Cosmetic skins modify **ONLY** tile visual overlays (`SkinTileDecorator`). They **NEVER** alter core gameplay parameters (`colorIndex`, `TileType`, `targetColor`, `isLocked`).

---

## 3. Visual Environment Themes (5 Themes)

| Theme ID | Name | Background Gradient | Surface / Card Accent | Primary Accent |
|---|---|---|---|---|
| `classic_dark` | Classic Dark | Dark Slate `#0F172A` $\rightarrow$ Indigo `#1E1B4B` | Slate `#1E293B` | Neon Indigo `#6366F1` |
| `bright_candy` | Bright Candy | Lavender Pink `#FFF0F5` $\rightarrow$ Sky `#E6F0FA` | Pure White `#FFFFFF` | Candy Magenta `#FF007F` |
| `ocean` | Deep Ocean | Abyss Cyan `#0B192C` $\rightarrow$ Navy `#1E3E62` | Deep Navy `#1E2A38` | Seafoam Cyan `#00F5D4` |
| `sunset` | Dusk Sunset | Twilight Purple `#2D0B32` $\rightarrow$ Plum `#4D194D` | Dark Plum `#38143D` | Coral Red `#FF6B6B` |
| `lavender` | Soft Lavender | Midnight Purple `#1F1A30` $\rightarrow$ Violet `#322B48` | Deep Purple `#28223D` | Vivid Orchid `#B5179E` |

### Gameplay Readability Principle
Changing themes alters the application background and card container colors. The six gameplay tile colors (**Coral Red**, **Mint Green**, **Sky Blue**, **Sunshine Yellow**, **Deep Violet**, **Electric Cyan**) remain 100% distinct and readable on all themes.
