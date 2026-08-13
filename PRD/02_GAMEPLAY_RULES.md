# 2. COMPLETE GAMEPLAY RULES

## 2.1 Board

A level contains a square grid.

Supported campaign board sizes: - 3x3 - 4x4 - 5x5 - 6x6 - 7x7 - 8x8

Do not let campaign levels exceed 8x8 without explicit design review.

## 2.2 Colors

Launch with at least six logical colors.

Suggested palette: 1. Coral 2. Mint 3. Sky 4. Violet 5. Sunshine 6. Aqua

The exact final colors must satisfy sufficient contrast and
accessibility testing.

Color identity is logical and independent from cosmetic skins.

## 2.3 Target color

Every level has one target color.

The player wins when all cells match that target color.

The target should be shown clearly in the HUD using: - target color
swatch, - text label, - and, when Color Assist is enabled, a symbol.

## 2.4 Normal tile

Tap: - increment the tile color to the next logical color.

Cycle: `0 -> 1 -> 2 -> ... -> last -> 0`

Each tap: - counts as a move, - triggers tile animation, - plays tile
SFX if enabled, - triggers haptic if enabled, - updates game state.

## 2.5 Bomb tile

Bomb is a special tile.

When tapped: 1. validate it is not locked, 2. play anticipation
animation, 3. play bomb SFX, 4. apply its effect to itself and valid
neighboring cells, 5. animate affected cells, 6. update board, 7. count
one player action.

Default radius: - all 8 surrounding cells plus itself (3x3
neighborhood), - clipped at board boundaries.

The exact effect: - set affected cells to the bomb's current logical
color.

Bomb interactions with Lock: - a locked tile remains locked; - bomb may
visually affect its color only if level configuration explicitly allows
it. Default: locked tiles are not changed by bomb.

Bomb interactions with Freeze: - Freeze state is separate from tile
color; no special conflict.

## 2.6 Freeze tile

When tapped: - trigger freeze effect, - set global freeze timer to
configured duration, - prevent automatic chaos during freeze, - player
interaction remains enabled unless a level explicitly defines otherwise.

Default duration: - 3 seconds.

Freeze should not reset the level timer.

## 2.7 Lock tile

Locked tile: - cannot be tapped, - displays a clear lock visual, - has
an internal lock timer.

When timer expires: - tile becomes normal, - play unlock SFX, - animate
unlock, - tile becomes interactive.

Default duration: - 5 seconds.

A level may define a different lock duration.

## 2.8 Chaos

Chaos is the game's automatic pressure system.

At configured intervals: - select one eligible cell, - change its
logical color according to level rules, - trigger a subtle
animation/SFX.

Chaos must be: - deterministic where possible, - level-specific, -
bounded, - solvability-aware.

Do not allow chaos to fire during: - pause, - offline blocked state, -
completed level, - app background state.

During Freeze: - chaos timer stops or does not trigger, - remaining
chaos interval is preserved unless the level explicitly specifies reset
behavior.

## 2.9 Timer

Every level may have a time limit.

Timer starts only when the level enters PLAYING.

Timer pauses when: - pause opened, - app backgrounded, - offline
blocked.

Timer must not continue silently while the user cannot interact.

Timer should use elapsed-time measurement rather than wall-clock
arithmetic to reduce system-clock manipulation.

## 2.10 Time warning

At configurable threshold: - HUD changes to warning state, - optional
warning pulse, - optional warning SFX, - optional haptic pulse.

Do not make the warning visually stressful or inaccessible.

## 2.11 Move count

Track moves internally for: - analytics if approved, - star
calculation, - debugging, - level balancing.

A move is a user-initiated tile action, including valid special-tile
activation.

Automatic chaos does not count as a player move.

## 2.12 Score

A simple score can be calculated from: - base completion value, - time
remaining, - moves, - optional special mechanic efficiency.

Score is secondary to stars and progression.

Do not build an online leaderboard without a backend.

## 2.13 Win

Win when: - every cell equals target color, - level is still PLAYING, -
app is online.

On win: 1. freeze gameplay, 2. stop timer, 3. stop chaos, 4. play
completion animation, 5. calculate stars, 6. persist completion, 7.
unlock next level, 8. show Level Complete UI.

## 2.14 Time Up

When timer reaches zero: - stop timer, - stop chaos, - freeze board, -
show Time Up panel.

Options: - Try Again - Watch Rewarded Ad for extra time - Return to Map

## 2.15 Rewarded extra time

Default reward: +15 seconds.

Only grant reward after the rewarded-ad SDK reports successful
completion.

Do not grant reward merely because an ad was loaded or opened.

Do not allow duplicate rewards from a single ad impression.

If the player declines, no penalty occurs.

## 2.16 Pause

Pause screen: - Resume - Restart Level - Exit to Map

Pause must stop: - timer, - chaos, - gameplay input, - gameplay music or
duck it according to audio design.

## 2.17 Restart

Restart resets: - board to level initial state, - timer, - chaos, -
freeze state, - tile lock timers, - move count, - score for that
attempt.

Do not reset: - unlocked levels, - earned stars, - owned skins, -
settings.

## 2.18 Level completion stars

Recommended default: - 3 stars = completion with strong efficiency - 2
stars = normal completion - 1 star = completion

Thresholds must be defined per level data rather than hidden in UI code.

## 2.19 Seeded deterministic behavior

Each authored/generated level should have a seed.

For a given: - level ID, - seed, - rules version,

the initial board should reproduce consistently.

This makes bug reports reproducible.

## 2.20 Solvability

Level Validator must confirm a level is solvable under its intended
rules.

For authored levels: - validate before release.

For procedural/endless levels: - generate -\> validate -\>
reject/regenerate if invalid.

Do not ship an unvalidated level.

## 2.21 Anti-frustration rule

A player must never lose because: - timer continued while app was
paused, - timer continued while offline, - chaos continued while
paused, - app backgrounded and state changed unexpectedly, - an
impossible board was generated.
