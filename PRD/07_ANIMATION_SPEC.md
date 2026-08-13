# 7. ANIMATION SPECIFICATION

## Motion principles

-   Fast enough to preserve game flow.
-   Slow enough to communicate cause/effect.
-   No animation should block input unnecessarily.
-   Respect reduced-motion/accessibility needs where supported.

## Tile press

Sequence: 1. scale down \~0.95 2. color changes 3. scale back to 1.0 4.
optional tiny bounce.

## Normal color change

Use a short transition or pop rather than a jarring instant replacement.

## Bomb

1.  small shake
2.  anticipation
3.  impact
4.  radial tile pulses
5.  particle burst
6.  settle.

## Freeze

1.  blue/ice overlay expands
2.  timer icon changes
3.  subtle frost particles
4.  freeze SFX.

## Lock

Locked: - visual badge, - slightly muted tile, - countdown.

Unlock: - crack/open animation, - small bounce, - unlock SFX.

## Timer warning

-   subtle pulse
-   optional screen-edge cue
-   SFX/haptic only when appropriate.

## Level complete

1.  board settles
2.  target confirmation
3.  star 1
4.  star 2
5.  star 3
6.  celebration particles
7.  CTA becomes available.

## Screen transitions

Use short fades/slides. Avoid long transition durations.

## Performance

Avoid large numbers of simultaneous expensive animations on 8x8 boards.
