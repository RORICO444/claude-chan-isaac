"""Repair cell-boundary defects in the generated character atlases.

Usage: python3 tools/fix_character_cells.py

The engine crops every head/body frame to its 32x32 cell, so art that spills
over a cell border is cut off and leaks into the neighbouring frame. This tool:

1. Splits each head (top-row cells 0-5 and 8, following the layout of the
   character template) from its neighbours along the thinnest column between
   them, drops stray fragments, and scales the head down just enough to sit
   inside its own cell (bottom-aligned, horizontally centred, nearest-neighbour).
2. Rebuilds DeepSeek-chan's walking bodies (the base cells: row 1 cells 0-7,
   row 2 cells 0-7, row 3 cells 0-1). They were copies of a front-facing,
   arms-raised alternate pose, so she slid sideways while facing the camera.
   The silhouettes come from Claude-chan's matching cells, recoloured to
   DeepSeek's blue-and-white maid palette (skin is kept).

3. Claude-chan's side-shooting head (cell 3) was generated with the front of
   her face cut off at the cell border, which can't be recovered; it reuses
   her side head (cell 2), the same approach already used for the rear heads.

It is idempotent: running it again on a fixed atlas changes nothing.
"""

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
COSTUMES = ROOT / "resources/gfx/characters/costumes"
CELL = 32
MARGIN = 1          # transparent pixels kept around a fitted head
SEAM_SEARCH = 10    # how far either side of a cell border to look for a seam


def opaque(px, x, y):
    return px[x, y][3] >= 128


# Top-row head frames in the template layout. Cells 6-7 are hand parts and
# cells 14-15 alternate bodies; they are left untouched.
HEAD_CELLS = [0, 1, 2, 3, 4, 5, 8]
# Base walking-body cells (row, first cell, last cell).
BODY_CELLS = [(1, 0, 7), (2, 0, 7), (3, 0, 1)]


def main_component(piece):
    """Keep the largest blob plus anything touching its box; drop stray fragments."""
    px = piece.load()
    w, h = piece.size
    seen, blobs = set(), []
    for y in range(h):
        for x in range(w):
            if px[x, y][3] and (x, y) not in seen:
                stack, pts = [(x, y)], []
                seen.add((x, y))
                while stack:
                    cx, cy = stack.pop()
                    pts.append((cx, cy))
                    for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                        if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in seen and px[nx, ny][3]:
                            seen.add((nx, ny))
                            stack.append((nx, ny))
                blobs.append(pts)
    if not blobs:
        return piece
    blobs.sort(key=len, reverse=True)
    xs = [p[0] for p in blobs[0]]
    ys = [p[1] for p in blobs[0]]
    x0, x1, y0, y1 = min(xs) - 2, max(xs) + 2, min(ys) - 2, max(ys) + 2
    for pts in blobs[1:]:
        if not any(x0 <= x <= x1 and y0 <= y <= y1 for x, y in pts):
            for x, y in pts:
                px[x, y] = (0, 0, 0, 0)
    return piece


def seam(px, border, top, bottom):
    """Column near `border` with the fewest opaque pixels (where two heads meet)."""
    best, best_count = border, None
    for x in range(max(0, border - SEAM_SEARCH), border + SEAM_SEARCH + 1):
        count = sum(opaque(px, x, y) for y in range(top, bottom))
        if best_count is None or count < best_count or (count == best_count and abs(x - border) < abs(best - border)):
            best, best_count = x, count
    return best


def spill(px, border, step, limit):
    """From a cell border, follow non-empty columns into a non-head neighbour:
    the head's spill-over ends at the first fully empty column."""
    x = border
    while 0 <= x + step < limit and any(opaque(px, x + (0 if step > 0 else -1), y) for y in range(CELL)):
        x += step
    return x


def fit_heads(image):
    px = image.load()
    cells = HEAD_CELLS
    heads = set(cells)
    cuts = {}
    for c in cells:
        left_border, right_border = c * CELL, (c + 1) * CELL
        # Between two heads: cut at the seam. Next to anything else (hand
        # parts, empty cells): take only the spill that is connected to the border.
        left = seam(px, left_border, 0, CELL) if c - 1 in heads else spill(px, left_border, -1, image.width)
        right = seam(px, right_border, 0, CELL) if c + 1 in heads else spill(px, right_border, 1, image.width)
        cuts[c] = (left, right)

    pieces = {}
    for c, (left, right) in cuts.items():
        piece = main_component(image.crop((left, 0, right, CELL)))
        bbox = piece.getchannel("A").point(lambda a: 255 if a >= 128 else 0).getbbox()
        if bbox:
            pieces[c] = piece.crop(bbox)

    # Clear each head's whole cut window, including spill into neighbour cells.
    for c, (left, right) in cuts.items():
        image.paste(Image.new("RGBA", (right - left, CELL)), (left, 0))
    changed = 0
    for c, piece in pieces.items():
        limit = CELL - 2 * MARGIN
        if piece.width > limit or piece.height > CELL - MARGIN:
            scale = min(limit / piece.width, (CELL - MARGIN) / piece.height)
            piece = piece.resize((max(1, round(piece.width * scale)), max(1, round(piece.height * scale))), Image.NEAREST)
            changed += 1
        x = c * CELL + (CELL - piece.width) // 2
        y = CELL - MARGIN - piece.height
        image.alpha_composite(piece, (x, y))
    return changed


def classify(rgb):
    """Map a pixel of Claude's side-walk art to a role: outline, skin, dress, trim, shadow."""
    r, g, b = rgb
    if r + g + b < 150:
        return "outline"
    if r > 200 and g > 150 and b > 120 and r - b < 90:
        return "dress"          # cream
    if r > 150 and g < 150 and b < 110:
        return "trim"           # orange
    if r > 180 and g > 120 and b > 90:
        return "skin"
    return "shadow"


DEEPSEEK_ROLE = {
    "outline": (20, 24, 48),
    "dress": (58, 98, 190),     # maid-dress blue
    "trim": (240, 246, 255),    # white apron / collar
    "shadow": (30, 48, 110),    # navy
}


def deepseek_bodies(claude, deepseek):
    """Recolour Claude's base walking bodies into DeepSeek's palette, keeping skin."""
    cpx = claude.load()
    for row, first, last in BODY_CELLS:
        box = (first * CELL, row * CELL, (last + 1) * CELL, (row + 1) * CELL)
        out = Image.new("RGBA", (box[2] - box[0], CELL))
        opx = out.load()
        for y in range(CELL):
            for x in range(out.width):
                r, g, b, a = cpx[box[0] + x, box[1] + y]
                if a == 0:
                    continue
                role = classify((r, g, b))
                opx[x, y] = (r, g, b, a) if role == "skin" else DEEPSEEK_ROLE[role] + (a,)
        deepseek.paste(out, box[:2])


def main():
    claude_path = COSTUMES / "character_claudechan.png"
    deepseek_path = COSTUMES / "character_deepseekchan.png"
    claude = Image.open(claude_path).convert("RGBA")
    deepseek = Image.open(deepseek_path).convert("RGBA")

    print(f"Claude-chan: refitted {fit_heads(claude)} head(s)")
    claude.paste(claude.crop((2 * CELL, 0, 3 * CELL, CELL)), (3 * CELL, 0))
    print(f"DeepSeek-chan: refitted {fit_heads(deepseek)} head(s)")
    deepseek_bodies(claude, deepseek)
    print("DeepSeek-chan: walking bodies rebuilt from Claude-chan's silhouettes")

    claude.save(claude_path)
    deepseek.save(deepseek_path)


if __name__ == "__main__":
    main()
