"""Derive the Tainted (裏) character art from the normal art by recolouring.

Usage: python3 tools/make_tainted_art.py   (run after tools/fix_character_cells.py)

No new pixels are drawn: every sprite keeps its normal counterpart's exact
shape, outline and frame placement, so the cell fixes carry over. Only colours
change, by pixel role (skin / pale cloth / everything else):

- Tainted Claude-chan ("banned"): crimson hair, charcoal dress, pale skin.
- Tainted DeepSeek-chan ("open source"): teal hair and dress, pale-cyan apron.

Outputs (sizes identical to the inputs):
  resources/gfx/characters/costumes/character_*chan_b.png
  resources/gfx/ui/stage/playerportrait_*chan_b.png
  content/gfx/ai_portraits_b.png   (menu portraits for characterportraitsalt.anm2)
"""

import colorsys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent

STYLES = {
    "claudechan": {"hue": 0.985, "sat": 1.0, "val": 0.72, "pale_val": 0.32, "pale_hue": None},
    "deepseekchan": {"hue": 0.48, "sat": 0.85, "val": 1.0, "pale_val": 0.97, "pale_hue": 0.50},
}


def role(h, s, v):
    if v < 0.18:
        return "outline"
    if 0.02 <= h <= 0.12 and 0.12 <= s <= 0.5 and v >= 0.65:
        return "skin"
    if s < 0.14 and v >= 0.6:
        return "pale"
    return "colour"


def recolour(image, style):
    out = image.copy()
    px = out.load()
    for y in range(out.height):
        for x in range(out.width):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
            kind = role(h, s, v)
            if kind == "outline":
                continue
            if kind == "skin":
                h, s, v = h, s * 0.45, v * 0.92            # pale, slightly grey
            elif kind == "pale":
                if style["pale_hue"] is None:
                    v = v * style["pale_val"]                # cream -> charcoal
                else:
                    h, s, v = style["pale_hue"], max(s, 0.12), min(1.0, v * style["pale_val"])
            else:
                h, s, v = style["hue"], min(1.0, s * style["sat"]), v * style["val"]
            nr, ng, nb = colorsys.hsv_to_rgb(h, s, v)
            px[x, y] = (round(nr * 255), round(ng * 255), round(nb * 255), a)
    return out


def main():
    for name, style in STYLES.items():
        for src, dst in [
            (f"resources/gfx/characters/costumes/character_{name}.png",
             f"resources/gfx/characters/costumes/character_{name}_b.png"),
            (f"resources/gfx/ui/stage/playerportrait_{name}.png",
             f"resources/gfx/ui/stage/playerportrait_{name}_b.png"),
        ]:
            recolour(Image.open(ROOT / src).convert("RGBA"), style).save(ROOT / dst)
            print(f"wrote {dst}")

    # Menu portraits: one 64x64 cell per character, Claude first (see characterportraits.anm2).
    menu = Image.open(ROOT / "content/gfx/ai_portraits.png").convert("RGBA")
    out = menu.copy()
    for index, name in enumerate(["claudechan", "deepseekchan"]):
        box = (index * 64, 0, index * 64 + 64, 64)
        out.paste(recolour(menu.crop(box), STYLES[name]), box[:2])
    out.save(ROOT / "content/gfx/ai_portraits_b.png")
    print("wrote content/gfx/ai_portraits_b.png")


if __name__ == "__main__":
    main()
