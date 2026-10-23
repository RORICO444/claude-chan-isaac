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

## Runtime-driven frame repair

Repentance+ testing exposed two defects hidden by file-level validation: Reactions Port Pack supplies an Isaac-face fallback for unknown custom characters, and the generated Claude walk cells contained miniature heads. DeepSeek's dressed alternate cells were mechanically copied to the base walk cells. `scripts/compatibility/reaction_pack.lua` registers empty fallback costume lists only for these two player IDs, preserving any explicit support supplied by a reaction pack and leaving its sounds/music intact.

A subsequent imagegen repair requests an evenly spaced 4x4 grid: rear head cutouts in the first row, and headless cream/orange dress walk poses (front, side, rear) in the remaining rows. These are production patches to the generated Claude art, not downloaded Bilibili assets. The importer must fit each complete cutout inside its engine cell before installation; a source-image cell may never be assumed aligned without inspection.

The repair prompt specifies a square 4x4 grid without grid lines: row zero contains complete rear-facing orange-haired heads with a sunflower and no visible face; rows one, two and three contain four alternating front, side and rear walking poses, all headless, in a cream dress with a black collar and orange trim. Every sprite must remain within its cell with transparent padding. `--claude-parts` normalizes this generated grid, measures visible cutouts at alpha >= 128 to ignore faint stray pixels, and fits the rear heads inside 28x28 pixels and bodies inside 18x18 pixels in their 32px engine cells. Only these repair cells are imported; special poses and UI portraits retain their previous artwork. The built-in imagegen tool was used; no API key or CLI fallback was used.
