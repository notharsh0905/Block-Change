# 3. 100-LEVEL CAMPAIGN DESIGN

## 3.1 Structure

10 worlds x 10 levels = 100 levels.

Worlds: 1. First Change --- 1--10 2. Rising Chaos --- 11--20 3. Boom
Blocks --- 21--30 4. Frozen Path --- 31--40 5. Locked Down --- 41--50 6.
Total Chaos --- 51--60 7. Color Storm --- 61--70 8. Expert Shift ---
71--80 9. Master Blocks --- 81--90 10. Final Change --- 91--100

## 3.2 Level progression matrix

The following is the design baseline. Actual boards must be validated
and playtested.

  Levels   Grid     Colors Mechanics               Chaos        Approx Time
  -------- ------ -------- ----------------------- ------------ -------------
  1--3     3x3           3 Normal                  none         60s
  4--6     3x3           3 Normal                  slow         60s
  7--10    3x3           3 Normal + light chaos    slow         55--60s
  11--14   3x3           4 Normal + chaos          slow         55s
  15--20   4x4           4 Normal + chaos          medium       60s
  21--24   4x4           4 Bomb                    medium       60s
  25--30   4x4           4 Bomb + chaos            medium       55s
  31--34   5x5           5 Freeze                  medium       70s
  35--40   5x5           5 Freeze + chaos          medium       65s
  41--44   5x5           5 Lock                    medium       70s
  45--50   6x6           5 Lock + chaos            medium       75s
  51--55   6x6           5 Bomb + Freeze           fast         70s
  56--60   6x6           6 Bomb + Freeze + chaos   fast         75s
  61--65   7x7           6 Mixed                   fast         85s
  66--70   7x7           6 Mixed + locks           fast         80s
  71--75   7x7           6 Mixed advanced          fast         85s
  76--80   7x7           6 Mixed advanced          fast         80s
  81--85   8x8           6 Master mixed            adaptive     100s
  86--90   8x8           6 Master mixed            adaptive     95s
  91--95   8x8           6 Final mixed             adaptive     110s
  96--99   8x8           6 Final challenge         adaptive     120s
  100      8x8           6 All mechanics           controlled   150s

## 3.3 Tutorial levels

Level 1: - teach tapping, - no chaos, - no special tiles.

Level 2: - reinforce color cycling, - introduce target color.

Level 3: - introduce time pressure lightly.

Level 4: - introduce chaos.

Level 21: - contextual Bomb tutorial.

Level 31: - contextual Freeze tutorial.

Level 41: - contextual Lock tutorial.

Do not force a long tutorial dialog before gameplay.

## 3.4 Level authoring

Each level must specify: - ID - world - display name - grid size - color
count - target color - initial tile state - special tile
positions/types - special tile timers - timer duration - chaos
configuration - star thresholds - seed - rules version - difficulty
tag - tutorial flag where applicable.

## 3.5 Names

Use short, playful names, for example: - First Tap - Little Shift -
Green Dream - Color Drift - Tiny Trouble - Boom Time - Freeze Frame -
Locked In - Chaos Garden - Final Change

Do not name every level with generic "Level 1, Level 2" in the UI if a
name can be displayed without clutter.

## 3.6 World completion

Completing all 10 levels in a world: - show world celebration, - unlock
next world, - update map, - optionally unlock a cosmetic milestone.

## 3.7 Star-based cosmetic milestones

Optional: - 10 total stars -\> free cosmetic - 30 total stars -\>
cosmetic - 60 total stars -\> cosmetic - 90 total stars -\> cosmetic -
150 total stars -\> cosmetic

These should not be necessary to complete the campaign.

## 3.8 Endless Mode

Unlock after Level 100.

Endless: - seeded generation, - solvability validation, - escalating
board constraints, - no campaign progression dependency.

Endless can be expanded later and is not required to publish the initial
campaign.
