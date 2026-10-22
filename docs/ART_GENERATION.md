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

The image tool does not guarantee per-cell correctness. An offline visual pass found Claude's two rear-facing head cells still faced forward, and one DeepSeek rear-facing cell was bald. These three cells have now been corrected with imagegen and imported without changing any unrelated pixels. Claude's idle and firing rear views share the same corrected hair frame, because there is no visible mouth in a rear view. DeepSeek keeps her existing rear firing frame.

The correction prompt specified the 32x32 cells at x=128..159 and x=160..191, y=0..31, requested back hair with no eyes, mouth or skin disk, and required the rest of the atlas to remain unchanged. Claude's patch requested orange-red hair and the sunflower silhouette; DeepSeek's requested navy hair and fin ornaments, matching her adjacent rear frame. The importer takes only the designated generated cells and checks that all other RGBA pixels are identical to the input. Both corrected sheets were inspected offline after import.

These remain first-pass assets. Inspect all four head directions, special poses, walking, hurt/death and costume overlays in game. PNG and animation-bound validation checks file structure, not the correctness of a rendered engine pose. Steam's Cloud sync-failed warning currently blocks the final runtime pass, pending the owner's decision. The game has been closed; the corrected art is installed in the existing mod location.
