# Generated character art, 2026-10-23

The built-in `imagegen` tool produced two transparent character atlases. `tools/import_character_art.py` mechanically resizes them to the engine's 512x512 sheet size with nearest-neighbour sampling, crops the first full-body special pose into portraits, and builds name/selection assets. Pillow is a development dependency only. No image API, account or runtime dependency is required by the mod.

The technical frame-layout reference was `character_gabriel.png` from [catinsurance/isaac-character-template](https://github.com/catinsurance/isaac-character-template), the template linked by the [Isaac Blueprints character tutorial](https://isaacblueprints.com/tutorials/crash_course/character/). It was used as a layout reference, not as a character-design reference. The source template illustration and extracted vanilla files are not included. Character design references remain credited separately in `resources/ART_LICENSE.md`; these are generated fan adaptations, not downloaded Bilibili sprites.

## Shared prompt

> Use case: stylized-concept. Asset type: actual playable character sprite atlas for The Binding of Isaac. The supplied image is ONLY a technical frame-layout reference, not a character identity reference. Create an ORIGINAL 512 by 512 pixel transparent RGBA sprite sheet with EXACT SAME per-frame cell placements, head/body locations, sizes and pose directions as this layout. Preserve the animation grid rigorously: the upper four 32px rows include normal down/right/up/left heads, walking torsos, side torsos, hands, legs and small detached parts; the 64px cells lower down are special happy, hurt, dead, sleeping and flying poses. Redraw every visible sprite as the requested character; do not leave the old blond male character. Use authentic tiny 1px hard edged black outlines, limited palette, readable chibi Isaac proportions, no smooth painting, no text, no logos, no gridlines, no labels. Keep all unused space genuinely transparent, not black. Do NOT shift or rearrange frames. The pixel content must stay inside its original frame so the game animations crop it correctly. All body animation frames must wear the character outfit, and normal head frames must have the distinctive hair.

## Claude prompt addition

> Character: Claude-chan, an anime inspired girl with long orange-red hair, a small sunflower hair ornament, cream dress with black collar and orange trim, cream skin, large dark eyes. Orange-red hair on every head-facing frame. Dress on every body frame. No brand logo. Newly drawn fan sprite art, not official art.

## DeepSeek prompt addition

> Character: DeepSeek-chan, an anime inspired blue whale girl, dark navy-blue long hair, small whale-fin hair ornaments, blue and white maid-like dress, white collar and small apron, cream skin, large dark eyes. Blue hair on every head-facing frame. Blue-white dress on every torso frame. No brand logo. Newly drawn fan sprite art, not official art.

## Known QA work

The image tool does not guarantee per-cell correctness. These are first-pass assets. Inspect all four head directions, especially back-head cells, special poses, walking, hurt/death and costume overlays in game. PNG and animation-bound validation checks file structure, not the visual correctness of a pose. The owner stopped Computer Use before that final runtime pass.
