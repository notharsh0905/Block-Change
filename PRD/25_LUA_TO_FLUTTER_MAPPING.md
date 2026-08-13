# 25. LUA TO FLUTTER MIGRATION MAP

## Prototype source

Original prototype: `main.lua`

Title: `COLOR CHAOS PUZZLE (WITH ANIMATIONS)`

## Existing constants

Lua: - NORMAL = 0 - BOMB = 1 - FREEZE = 2 - LOCK = 3

Flutter: Represent as a Dart enum or equivalent strongly typed model.

## Existing colors

Lua uses 3 colors.

Production: expand to at least 6 logical colors.

## Existing board

Lua: `grid[i][j]`

Flutter: typed `List<List<int>>` or a dedicated board model.

## Existing tile types

Lua: `tileType[i][j]`

Flutter: typed Tile model with enum.

## Existing lock timer

Lua: `lockTimer[i][j]`

Flutter: model/controller state.

## Existing animations

Lua: `animScale`, `animTimer`

Flutter: Flutter animation controllers or state-driven implicit/explicit
animations.

Do not recreate per-tile timer objects unnecessarily.

## Existing level

Lua: `level = 1`

Flutter: Progression service/model.

## Critical prototype issue

Lua: `gridSize = 2 + level`

This creates: - Level 1 = 3x3 - Level 100 = 102x102

Do NOT carry this behavior into Flutter.

Production board sizes are capped at 8x8.

## Existing auto interval

Lua: `2 - level * 0.2`, capped by `0.35`.

This is too simplistic for a 100-level campaign.

Production: level-specific chaos configuration.

## Existing random tile type

Lua uses probability thresholds.

Production: level data explicitly controls allowed special tile types
and counts. Avoid accidental difficulty spikes.

## Existing random chaos

Lua changes one random tile.

Production: controlled, seeded, validated chaos.

## Existing explode

Lua affects a 3x3 neighborhood.

Production: preserve the concept but define locked-tile interaction
explicitly.

## Existing freeze

Lua freezes automatic chaos for 3 seconds.

Production: preserve this concept, configurable by level.

## Existing checkWin

Lua: all cells must match first cell.

Production: all cells must equal the level target color.

## Existing similarityRatio

Lua stops chaos when similarity \> 80%.

Production: do not copy blindly. Replace with controlled chaos rules
designed per level.

## Existing mouse input

Lua: `love.mousepressed`

Flutter: GestureDetector/InkWell/appropriate pointer handling with
responsive board hit targets.

## Existing draw

Lua: direct immediate-mode rendering.

Flutter: Widget tree/custom painter only where justified.

## Prototype UI limitations to replace

-   fixed 700x900 window,
-   text-only HUD,
-   emoji special icons,
-   minimal menu,
-   no level map,
-   no persistence,
-   no ads,
-   no purchase,
-   no skin system,
-   no offline enforcement,
-   no robust state machine.

## Preserve

Preserve the recognizable core: - color-changing puzzle, - chaos, -
bomb, - freeze, - lock, - completion condition, - animation concept.

Improve everything around it for mobile production.
