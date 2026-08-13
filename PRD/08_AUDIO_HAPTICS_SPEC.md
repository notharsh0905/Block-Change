# 8. AUDIO AND HAPTICS

## SFX events

Required: - button tap - tile tap - color change - bomb trigger - bomb
impact - freeze trigger - lock countdown/unlock - timer warning - time
up - star award - level complete - error/blocked action - purchase
success - skin unlock.

## Music

At minimum: - menu track - gameplay track - completion/victory cue.

Music should loop cleanly.

## Volume

Use separate logical controls: - music enabled/disabled - SFX
enabled/disabled.

A future volume slider is optional.

## Haptics

Use short haptics for: - normal tap, - special tile activation, - timer
warning, - completion.

Never make haptics required for understanding.

## Synchronization

Animation is the source of truth for timing; audio triggers at the
visual impact point.

## Asset licensing

Only use: - original assets, - properly licensed assets, - public-domain
assets with suitable rights, - or assets whose license explicitly allows
commercial game use.

Maintain a simple asset license/source record.

## Suggested asset formats

SFX: - compressed short audio such as OGG/MP3 depending on
package/platform support.

Music: - compressed format suitable for mobile.

Avoid uncompressed huge files unless justified.
