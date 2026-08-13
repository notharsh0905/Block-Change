# 9. SKINS AND THEMES

## Principle

Cosmetics modify presentation only.

A skin must never change: - color cycle rules, - board state, - timer, -
chaos, - bomb behavior, - freeze, - lock, - solvability, - star
thresholds.

## Initial skin catalog

### Free

Classic Blocks

### Rewarded unlock candidates

Cute Cats Cute Dogs Bunny

### Premium cosmetic candidates

Panda Space Candy

## Cosmetic architecture

Skin contains: - id - display name - tile asset set - special tile
assets - optional UI accent - unlock method - product ID if premium -
ownership state.

## Cat skin

Each logical color maps to a cat expression/appearance.

The logical color remains unchanged internally.

## Dog skin

Same principle.

## Special tiles

Do not rely on emoji. Use custom assets: - Bomb icon - Freeze icon -
Lock icon

## Rewarded skin unlock

The product must decide whether an ad unlock is: - permanent, or -
temporary.

Recommended: **Permanent cosmetic unlock after successful rewarded ad.**

However, implement a configurable reward definition so this can be
changed without rewriting the skin system.

## Premium skins

Use Google Play Billing if sold as individual cosmetic products.

Do not hardcode localized price strings.

## Theme vs skin

Theme: - application-level visual system (Light/Dark).

Skin: - board/tile cosmetic appearance.

Keep these concepts separate.
