# 21. GIT WORKFLOW

## Goal

Maintain a real, understandable history.

Frequent commits are encouraged because the work is performed in small
logical units.

## Commit cadence

A commit can be made after: - a new file is correctly implemented, - a
coherent feature is completed, - a test suite for a feature is added, -
a bug is fixed, - a configuration milestone is completed.

Do not commit every individual line or every keystroke.

## Suggested history

``` text
chore: initialize flutter project
chore: add project configuration
chore: add design tokens
feat: add game models
feat: add game state
feat: implement color cycle
feat: implement board rendering
feat: implement timer
feat: implement pause state
feat: implement chaos
feat: implement bomb tile
feat: implement freeze tile
feat: implement lock tile
feat: add win detection
feat: add level data
test: add level validation
feat: add level map
feat: add progression persistence
feat: add star calculation
feat: add audio service
feat: add haptic service
feat: add skin system
feat: add settings
feat: add connectivity service
feat: add offline blocking
feat: add admob test integration
feat: add rewarded ads
feat: add interstitial ads
feat: add banner ads
feat: add remove ads purchase
test: add purchase tests
fix: correct background resume behavior
fix: prevent duplicate rewarded rewards
chore: prepare release configuration
chore: remove debug tools
test: finalize release regression suite
```

## Branching

Recommended: - `main` --- stable/release - `develop` --- integration -
feature branches for substantial features.

For a solo developer, a simpler `main` + feature branches is also
acceptable.

## Commit quality

Every commit should: - compile where practical, - have a focused
purpose, - avoid unrelated changes.

Never create fake commits just to increase GitHub contribution dots.
