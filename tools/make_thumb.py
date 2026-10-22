"""Generate a 512x512 placeholder Workshop preview (thumb.png). No dependencies.

Usage: python3 tools/make_thumb.py
Replace with a real cover (Claude-chan art) once it exists.
"""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location("placeholders", ROOT / "tools" / "make_placeholders.py")
ph = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ph)

BG = (40, 32, 30, 255)
SIZE = 512
CELL = 32  # each art cell becomes 32x32 px: 16x16 art -> 512x512


def main():
    art = ph.ART["ban_hammer"]
    palette = ph.PALETTES["ban_hammer"]
    pixels = []
    for row in art:
        line = []
        for ch in row:
            rgba = palette[ch] + (255,) if ch in palette else BG
            line += [rgba] * CELL
        pixels += [line] * CELL
    ph.write_png(ROOT / "thumb.png", pixels, SIZE)
    print(f"wrote {ROOT / 'thumb.png'}")


if __name__ == "__main__":
    main()
