"""Shared helpers and palette for Night of the Sigbin pixel art."""
import os
from PIL import Image, ImageDraw

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
ART = os.path.join(ROOT, "art")

for _d in ("players", "enemies", "items", "icons", "env", "fx"):
    os.makedirs(os.path.join(ART, _d), exist_ok=True)

# --- palette ---------------------------------------------------------------
OUT = (13, 15, 24, 255)
OUT_SOFT = (26, 30, 44, 255)
SKIN = (198, 139, 92, 255)
SKIN_D = (142, 94, 58, 255)
HAIR = (24, 22, 30, 255)
BONE = (214, 205, 178, 255)
STEEL = (196, 200, 198, 255)
STEEL_D = (120, 128, 132, 255)
WOOD = (104, 72, 44, 255)
WOOD_D = (66, 44, 28, 255)
GOLD = (232, 186, 84, 255)
GOLD_D = (160, 116, 40, 255)
AMBER = (255, 179, 71, 255)
EMBER = (255, 132, 52, 255)
RED = (176, 44, 48, 255)
RED_D = (104, 24, 32, 255)
BLOOD = (139, 30, 30, 255)
MOON = (159, 216, 232, 255)
WHITE = (238, 236, 226, 255)
GREY = (150, 150, 142, 255)
GREY_D = (88, 90, 92, 255)
GREEN = (58, 96, 66, 255)
GREEN_D = (34, 62, 46, 255)
GREEN_L = (92, 138, 92, 255)
PURPLE = (91, 42, 110, 255)
PURPLE_L = (140, 84, 160, 255)


def new(w, h):
    return Image.new("RGBA", (w, h), (0, 0, 0, 0))


def canvas(w, h):
    img = new(w, h)
    return img, ImageDraw.Draw(img)


def orect(d, box, fill, outline=OUT):
    """Rectangle with a 1px outline."""
    x0, y0, x1, y1 = box
    d.rectangle([x0 - 1, y0 - 1, x1 + 1, y1 + 1], fill=outline)
    d.rectangle(box, fill=fill)


def opoly(d, pts, fill, outline=OUT):
    d.polygon([(x, y) for x, y in pts], fill=outline)
    # shrink by 1px toward centroid for an inner fill
    cx = sum(p[0] for p in pts) / len(pts)
    cy = sum(p[1] for p in pts) / len(pts)
    inner = []
    for x, y in pts:
        dx, dy = x - cx, y - cy
        l = max(1.0, (dx * dx + dy * dy) ** 0.5)
        inner.append((round(x - dx / l), round(y - dy / l)))
    d.polygon(inner, fill=fill)


def oellipse(d, box, fill, outline=OUT):
    x0, y0, x1, y1 = box
    d.ellipse([x0 - 1, y0 - 1, x1 + 1, y1 + 1], fill=outline)
    d.ellipse(box, fill=fill)


def px(d, x, y, fill):
    d.point((x, y), fill=fill)


def rim(img, color=MOON, alpha=90):
    """Add a subtle moonlight rim on top edges of opaque pixels."""
    w, h = img.size
    p = img.load()
    c = (color[0], color[1], color[2], alpha)
    for y in range(1, h):
        for x in range(w):
            if p[x, y][3] > 0 and p[x, y - 1][3] == 0:
                r, g, b, a = p[x, y]
                p[x, y] = (
                    min(255, int(r * 0.55 + c[0] * 0.45)),
                    min(255, int(g * 0.55 + c[1] * 0.45)),
                    min(255, int(b * 0.55 + c[2] * 0.45)),
                    a,
                )
    return img


def save(img, sub, name):
    path = os.path.join(ART, sub, name)
    img.save(path)
    return path


def strip(frames):
    w, h = frames[0].size
    out = new(w * len(frames), h)
    for i, f in enumerate(frames):
        out.paste(f, (i * w, 0))
    return out


def preview(paths, out_name="preview.png", scale=4, cols=8):
    """Contact sheet of all generated art, upscaled, for eyeballing."""
    imgs = []
    for p in paths:
        im = Image.open(p).convert("RGBA")
        if im.width > 96:
            im = im.resize((im.width // 2, im.height // 2), Image.NEAREST)
        imgs.append((os.path.basename(p), im))
    cell_w = max(i.width for _, i in imgs) * scale + 8
    cell_h = max(i.height for _, i in imgs) * scale + 8
    rows = (len(imgs) + cols - 1) // cols
    sheet = Image.new("RGBA", (cell_w * cols, cell_h * rows), (20, 22, 34, 255))
    for n, (_, im) in enumerate(imgs):
        big = im.resize((im.width * scale, im.height * scale), Image.NEAREST)
        x = (n % cols) * cell_w + 4
        y = (n // cols) * cell_h + 4
        sheet.alpha_composite(big, (x, y))
    path = os.path.join(ART, out_name)
    sheet.save(path)
    return path
