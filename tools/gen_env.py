"""Environment textures: tileable ground, trees, rocks, ferns."""
import random
from PIL import Image, ImageDraw
from artlib import (
    canvas, new, save, orect, oellipse, opoly, px,
    OUT, WOOD, WOOD_D, GREEN, GREEN_D, GREEN_L, MOON, GREY, GREY_D, AMBER,
    ART,
)


def ground():
    size = 128
    img = Image.new("RGBA", (size, size), (40, 72, 50, 255))
    d = ImageDraw.Draw(img)
    rng = random.Random(7)
    # noise
    for _ in range(900):
        x, y = rng.randrange(size), rng.randrange(size)
        c = rng.choice(((36, 66, 46, 255), (44, 78, 54, 255), (48, 84, 58, 255)))
        d.point((x, y), fill=c)
    # dirt patches (kept away from edges)
    for _ in range(3):
        cx, cy = rng.randrange(16, size - 16), rng.randrange(16, size - 16)
        rx, ry = rng.randrange(5, 10), rng.randrange(4, 7)
        d.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=(52, 60, 42, 255))
        d.ellipse([cx - rx + 2, cy - ry + 2, cx + rx - 2, cy + ry - 2], fill=(58, 66, 46, 255))
        for _ in range(10):
            d.point((cx + rng.randint(-rx, rx), cy + rng.randint(-ry, ry)), fill=(46, 54, 38, 255))
    # leaf litter
    for _ in range(46):
        x, y = rng.randrange(2, size - 2), rng.randrange(2, size - 2)
        c = rng.choice(((64, 58, 40, 255), (52, 50, 36, 255), (70, 62, 44, 255)))
        d.point((x, y), fill=c)
        if rng.random() < 0.4:
            d.point((x + 1, y), fill=c)
    # grass tufts
    for _ in range(90):
        x, y = rng.randrange(6, size - 6), rng.randrange(6, size - 6)
        h = rng.randint(2, 4)
        c = rng.choice((GREEN_L, (72, 112, 76, 255), (52, 92, 62, 255)))
        d.line([(x, y), (x, y - h)], fill=c)
        if rng.random() < 0.5:
            d.line([(x + 1, y), (x + 2, y - h + 1)], fill=c)
    # tiny flowers
    for _ in range(14):
        x, y = rng.randrange(8, size - 8), rng.randrange(8, size - 8)
        c = rng.choice(((214, 200, 160, 255), (200, 176, 96, 255), (176, 150, 196, 255)))
        d.point((x, y), fill=c)
        d.point((x + 1, y), fill=(70, 100, 66, 255))
    return img


def tree(seed=0):
    rng = random.Random(seed)
    img, d = canvas(48, 64)
    trunk = (70, 52, 36, 255)
    trunk_d = (42, 32, 24, 255)
    can_d = (20, 44, 32, 255)
    can_m = (32, 68, 46, 255)
    can_l = (50, 94, 60, 255)
    can_h = (70, 118, 72, 255)

    # trunk first so the canopy sits over it
    orect(d, (20, 40, 27, 62), trunk)
    d.line([(21, 44), (21, 61)], fill=trunk_d)
    d.line([(26, 44), (26, 61)], fill=trunk_d)
    d.line([(20, 62), (13, 63)], fill=trunk_d)
    d.line([(27, 62), (34, 63)], fill=trunk_d)

    blobs = []
    for _ in range(8):
        cx = rng.randint(13, 35)
        cy = rng.randint(13, 30)
        rx = rng.randint(8, 15)
        ry = rng.randint(7, 12)
        blobs.append((cx, cy, rx, ry))

    for cx, cy, rx, ry in blobs:
        d.ellipse([cx - rx - 1, cy - ry - 1, cx + rx + 1, cy + ry + 1], fill=can_d)
    for cx, cy, rx, ry in blobs:
        d.ellipse([cx - rx + 1, cy - ry + 1, cx + rx - 1, cy + ry - 1], fill=can_m)
    for _ in range(6):
        cx = rng.randint(12, 32)
        cy = rng.randint(10, 26)
        rx = rng.randint(4, 9)
        ry = rng.randint(3, 7)
        d.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=can_l)
    for _ in range(3):
        cx = rng.randint(14, 28)
        cy = rng.randint(10, 22)
        rx = rng.randint(2, 5)
        ry = rng.randint(2, 4)
        d.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=can_h)

    for _ in range(90):
        x, y = rng.randrange(3, 45), rng.randrange(3, 42)
        if img.getpixel((x, y))[3] > 0:
            d.point((x, y), fill=rng.choice((can_d, can_l, can_h)))
    return img


def balete(seed=0):
    rng = random.Random(seed)
    img, d = canvas(64, 80)
    trunk = (62, 48, 36, 255)
    trunk_d = (38, 30, 24, 255)
    can_d = (16, 38, 30, 255)
    can_m = (26, 58, 44, 255)
    can_l = (40, 78, 54, 255)
    can_h = (56, 100, 64, 255)

    orect(d, (26, 42, 38, 78), trunk)
    d.line([(28, 46), (28, 77)], fill=trunk_d)
    d.line([(36, 46), (36, 77)], fill=trunk_d)
    opoly(d, [(26, 66), (14, 79), (22, 79), (28, 70)], trunk_d)
    opoly(d, [(38, 66), (50, 79), (42, 79), (36, 70)], trunk_d)

    blobs = []
    for _ in range(11):
        cx = rng.randint(16, 48)
        cy = rng.randint(14, 34)
        rx = rng.randint(10, 18)
        ry = rng.randint(8, 13)
        blobs.append((cx, cy, rx, ry))
    for cx, cy, rx, ry in blobs:
        d.ellipse([cx - rx - 1, cy - ry - 1, cx + rx + 1, cy + ry + 1], fill=can_d)
    for cx, cy, rx, ry in blobs:
        d.ellipse([cx - rx + 1, cy - ry + 1, cx + rx - 1, cy + ry - 1], fill=can_m)
    for _ in range(8):
        cx = rng.randint(14, 46)
        cy = rng.randint(10, 30)
        rx = rng.randint(4, 10)
        ry = rng.randint(3, 7)
        d.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=can_l)
    for _ in range(4):
        cx = rng.randint(16, 42)
        cy = rng.randint(10, 26)
        rx = rng.randint(2, 6)
        ry = rng.randint(2, 4)
        d.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=can_h)

    for x in range(8, 58, 6):
        y0 = rng.randint(30, 40)
        y1 = rng.randint(48, 72)
        d.line([(x, y0), (x, y1)], fill=trunk_d)
        d.line([(x, y0), (x + 1, y1 - 2)], fill=trunk)
    for _ in range(90):
        x, y = rng.randrange(3, 61), rng.randrange(3, 48)
        if img.getpixel((x, y))[3] > 0:
            d.point((x, y), fill=rng.choice((can_d, can_l, can_h)))
    return img


def rock():
    img, d = canvas(16, 12)
    oellipse(d, (1, 3, 14, 11), GREY_D)
    oellipse(d, (2, 2, 12, 9), GREY)
    d.line([(4, 4), (9, 4)], fill=(184, 184, 176, 255))
    d.point((5, 8), fill=(110, 112, 108, 255))
    return img


def fern():
    img, d = canvas(16, 16)
    dark = (24, 52, 34, 255)
    mid = (42, 82, 50, 255)
    lit = (62, 108, 62, 255)
    base = (8, 15)
    for dx, dy in ((-6, -9), (-3, -12), (0, -14), (3, -12), (6, -9), (-4, -6), (4, -6)):
        tip = (base[0] + dx, base[1] + dy)
        d.line([base, tip], fill=dark, width=2)
        d.line([base, tip], fill=mid, width=1)
        for t in (0.45, 0.65, 0.85):
            x = int(base[0] + dx * t)
            y = int(base[1] + dy * t)
            d.point((x - 1, y), fill=dark)
            d.point((x + 1, y), fill=lit)
    return img


def bush():
    img, d = canvas(24, 16)
    dark = (20, 44, 30, 255)
    mid = (32, 66, 42, 255)
    lit = (50, 92, 54, 255)
    d.ellipse([1, 6, 22, 15], fill=dark)
    d.ellipse([3, 4, 15, 13], fill=mid)
    d.ellipse([10, 3, 22, 13], fill=mid)
    d.ellipse([6, 4, 14, 10], fill=lit)
    d.ellipse([13, 5, 20, 11], fill=lit)
    return img


if __name__ == "__main__":
    made = [
        save(ground(), "env", "ground.png"),
        save(rock(), "env", "rock.png"),
        save(fern(), "env", "fern.png"),
        save(bush(), "env", "bush.png"),
    ]
    for i in range(3):
        made.append(save(tree(i), "env", "tree_%d.png" % i))
    for i in range(2):
        made.append(save(balete(i), "env", "balete_%d.png" % i))
    print("wrote", len(made), "files")
    from artlib import preview
    preview(made, "preview_env.png", scale=3, cols=3)
