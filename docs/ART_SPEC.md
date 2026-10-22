# Art spec: Claude-chan

What a pixel artist needs to deliver to replace the placeholder (vanilla Isaac) art.

## Reference design

Claude-chan's design is by **ZipZipPipe**: [Pixiv《AI娘化》#148186519](https://www.pixiv.net/artworks/148186519) (page p02) and the chibi version in [《大AI和小AI们》](https://www.bilibili.com/video/BV1tE9XBbErS/) at around 0:17.

Things she must keep so she reads as Claude-chan even at Isaac's tiny sprite size:

- long **orange-red hair**
- **sun / sunflower** hair ornament
- long classical dress in **cream, black and orange**
- a **book** (good candidate for the tear-firing animation or an idle pose)

Do not use Anthropic's logo or other official brand assets.

## Templates

Extract the vanilla files with the game's own tool, `The Binding of Isaac Rebirth/tools/ResourceExtractor/ResourceExtractor.exe`, and draw over them. **Keep each file's exact size and layout**; the animations depend on it.

| Placeholder now (vanilla) | Replace with (mod path) | Purpose |
|---|---|---|
| `gfx/characters/costumes/character_001_isaac.png` | `resources/gfx/characters/costumes/character_claudechan.png` | In-game body and head sheet |
| (none) | `resources/gfx/characters/claudechan_hair.png` + `.anm2` + `content/costumes2.xml` entry | Hair as a costume layer, drawn over the head |
| `gfx/ui/stage/PlayerPortrait_01_Isaac.png` | `resources/gfx/ui/stage/playerportrait_claudechan.png` | Floor transition portrait |
| `gfx/ui/stage/PlayerPortraitBig_01_Isaac.png` | `resources/gfx/ui/stage/playerportraitbig_claudechan.png` | Boss VS screen portrait |
| `gfx/ui/boss/PlayerName_01_Isaac.png` | `resources/gfx/ui/boss/playername_claudechan.png` | "CLAUDE-CHAN" name text on the VS screen |

Once a file is ready, update the matching attribute in `content/players.xml`.

## Art license

Art made for this mod is a derivative of ZipZipPipe's design, so it is released **non-commercially with credit to ZipZipPipe**, not under the code's MIT license. See [`resources/ART_LICENSE.md`](../resources/ART_LICENSE.md).
