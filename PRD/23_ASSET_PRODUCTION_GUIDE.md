# 23. ASSET PRODUCTION GUIDE

## 23.1 Logo

Create a simple memorable Block Change logo: - block motif, - color
transition concept, - rounded shape, - readable at small size.

Do not imitate another game logo.

## 23.2 App icon

Concept: - one or several rounded blocks, - visible color
transformation, - simple high contrast, - minimal detail.

The icon must remain recognizable at small launcher size.

## 23.3 Game tiles

Prefer vector/Flutter-rendered geometry for simple blocks where
possible.

Use raster/vector assets for: - character skins, - special icons, -
decorative illustrations.

## 23.4 Skin art

Cat/dog/bunny/panda/etc. must: - have consistent proportions, - support
six logical color states, - be readable on small boards, - have a
unified art direction.

## 23.5 Special icons

Use bundled custom icons: - Bomb - Freeze - Lock

Do not rely on platform emoji.

## 23.6 Sound sourcing

Sources may include: - original recordings, - commissioned sound
design, - commercial libraries with explicit game/commercial rights, -
public-domain/appropriate CC assets.

Keep a `ASSET_LICENSES.md` file recording: - asset, - source, -
creator, - license, - commercial-use permission, - attribution
requirement.

## 23.7 Music

Use short looping tracks with mobile-friendly file sizes.

Avoid copyright-risky music.

## 23.8 Asset optimization

-   resize images to actual needed dimensions,
-   compress large files,
-   avoid giant 4K textures,
-   avoid duplicate assets,
-   load large assets only when needed.

## 23.9 Production asset checklist

-   [ ] logo
-   [ ] launcher icon
-   [ ] adaptive icon
-   [ ] splash art if needed
-   [ ] tile visuals
-   [ ] special icons
-   [ ] 7+ skin sets
-   [ ] SFX
-   [ ] music
-   [ ] completion effects
-   [ ] world/map decorations
-   [ ] store screenshots
