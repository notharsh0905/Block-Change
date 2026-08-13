# 4. LEVEL DATA SCHEMA

## Required fields

Conceptual Dart model:

``` text
LevelModel
- id: int
- worldId: int
- name: String
- gridSize: int
- colorCount: int
- targetColor: int
- initialBoard: List<List<int>>
- specialTiles: List<TileDefinition>
- timeLimitSeconds: double
- chaosConfig: ChaosConfig
- starRules: StarRules
- seed: int
- difficulty: Difficulty
- tutorialStep: optional
- rulesVersion: int
```

## TileDefinition

``` text
- row
- column
- type
- lockDuration
```

## ChaosConfig

``` text
- enabled
- initialInterval
- minimumInterval
- eligibleTilePolicy
- colorChangePolicy
- adaptive: bool
```

## StarRules

``` text
- threeStarMaxMoves
- threeStarMinRemainingSeconds
- twoStarMaxMoves
- twoStarMinRemainingSeconds
```

Use a rule strategy if a level needs a different star formula.

## Data integrity

Validator must reject: - invalid grid dimensions, - invalid color IDs, -
missing target color, - special tile outside board, - duplicate
incompatible tile definitions, - negative timers, - impossible star
thresholds, - invalid seed, - unsolvable puzzle.

## Versioning

Every level has `rulesVersion`.

If game mechanics change later, old levels can remain reproducible under
their original rules where necessary.
