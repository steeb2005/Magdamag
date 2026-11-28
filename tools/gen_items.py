"""Items, weapon/passive icons, and FX textures."""
from PIL import Image, ImageDraw
from artlib import (
    canvas, save, orect, opoly, oellipse, px, new,
    OUT, SKIN, BONE, STEEL, STEEL_D, WOOD, WOOD_D, GOLD, GOLD_D,
    AMBER, EMBER, RED, RED_D, WHITE, GREY, GREY_D, GREEN, GREEN_D, GREEN_L,
    MOON, PURPLE, PURPLE_L, ART,
)


def icon_itak():
    img, d = canvas(16, 16)
    d.line([(3, 13), (12, 3)], fill=OUT, width=4)
    d.line([(3, 13), (12, 3)], fill=STEEL, width=2)
    d.line([(4, 12), (10, 4)], fill=WHITE, width=1)
    d.line([(1, 15), (5, 11)], fill=OUT, width=4)
    d.line([(1, 15), (5, 11)], fill=WOOD, width=2)
    return img


def icon_balisong():
    img, d = canvas(16, 16)
    d.line([(8, 8), (12, 2)], fill=OUT, width=3)
    d.line([(8, 8), (12, 2)], fill=STEEL, width=1)
    d.line([(8, 8), (4, 14)], fill=OUT, width=3)
    d.line([(8, 8), (4, 14)], fill=WOOD, width=1)
    d.line([(8, 8), (12, 14)], fill=OUT, width=3)
    d.line([(8, 8), (12, 14)], fill=WOOD, width=1)
    return img


def icon_yantok():
    img, d = canvas(16, 16)
    for a, b in (((2, 13), (13, 2)), ((2, 2), (13, 13))):
        d.line([a, b], fill=OUT, width=4)
        d.line([a, b], fill=WOOD, width=2)
        d.point((a[0], a[1]), fill=GOLD_D)
    return img


def icon_sumpit():
    img, d = canvas(16, 16)
    d.line([(1, 14), (11, 4)], fill=OUT, width=4)
    d.line([(1, 14), (11, 4)], fill=(96, 78, 52, 255), width=2)
    d.line([(9, 4), (14, 2)], fill=OUT, width=2)
    d.line([(9, 4), (14, 2)], fill=BONE, width=1)
    d.point((15, 1), fill=GREEN_L)
    return img


def icon_banga():
    img, d = canvas(16, 16)
    oellipse(d, (2, 6, 13, 15), (150, 96, 62, 255))
    orect(d, (6, 3, 9, 6), (120, 74, 48, 255))
    d.line([(5, 8), (10, 8)], fill=(96, 58, 40, 255))
    d.line([(4, 11), (11, 11)], fill=(96, 58, 40, 255))
    return img


def icon_bawang():
    img, d = canvas(16, 16)
    oellipse(d, (3, 5, 12, 14), BONE)
    d.line([(5, 6), (4, 2)], fill=GREEN_D)
    d.line([(8, 5), (8, 1)], fill=GREEN)
    d.line([(11, 6), (12, 2)], fill=GREEN_D)
    d.line([(6, 9), (6, 12)], fill=(190, 184, 160, 255))
    d.line([(9, 9), (9, 12)], fill=(190, 184, 160, 255))
    return img


def icon_tsinelas():
    img, d = canvas(16, 16)
    oellipse(d, (1, 7, 14, 13), (58, 78, 96, 255))
    d.ellipse([3, 8, 12, 12], fill=(78, 104, 124, 255))
    d.line([(4, 8), (8, 11)], fill=OUT, width=2)
    d.line([(12, 8), (8, 11)], fill=OUT, width=2)
    d.line([(4, 8), (8, 11)], fill=(36, 50, 64, 255), width=1)
    d.line([(12, 8), (8, 11)], fill=(36, 50, 64, 255), width=1)
    return img


def icon_kulintang():
    img, d = canvas(16, 16)
    d.rectangle([1, 12, 14, 13], fill=WOOD_D)
    for x, r in ((4, 3), (8, 4), (12, 3)):
        oellipse(d, (x - r, 8 - r, x + r, 8 + r), GOLD)
        d.ellipse([x - r + 2, 8 - r + 2, x + r - 2, 8 + r - 2], fill=GOLD_D)
    return img


def icon_agimat():
    img, d = canvas(16, 16)
    opoly(d, [(8, 1), (14, 8), (8, 15), (2, 8)], GOLD)
    opoly(d, [(8, 4), (11, 8), (8, 12), (5, 8)], PURPLE)
    px(d, 8, 8, AMBER)
    return img


def icon_bakya():
    img, d = canvas(16, 16)
    orect(d, (2, 8, 13, 13), WOOD)
    d.rectangle([3, 6, 12, 8], fill=WOOD_D)
    d.rectangle([5, 13, 6, 14], fill=WOOD_D)
    d.rectangle([10, 13, 11, 14], fill=WOOD_D)
    return img


def icon_singsing():
    img, d = canvas(16, 16)
    d.arc([3, 5, 12, 14], 0, 360, fill=OUT, width=4)
    d.arc([3, 5, 12, 14], 0, 360, fill=GOLD, width=2)
    opoly(d, [(8, 1), (11, 5), (8, 8), (5, 5)], MOON)
    return img


def icon_kandila():
    img, d = canvas(16, 16)
    orect(d, (6, 6, 9, 15), BONE)
    d.line([(7, 6), (7, 4)], fill=OUT)
    opoly(d, [(7, 1), (9, 4), (7, 5), (5, 4)], AMBER)
    px(d, 7, 4, WHITE)
    d.rectangle([5, 14, 10, 15], fill=GREY)
    return img


def icon_bayong():
    img, d = canvas(16, 16)
    opoly(d, [(3, 5), (12, 5), (14, 14), (1, 14)], (168, 132, 78, 255))
    d.line([(4, 7), (13, 7)], fill=(120, 92, 52, 255))
    d.line([(3, 10), (13, 10)], fill=(120, 92, 52, 255))
    d.arc([4, 1, 11, 7], 200, 340, fill=OUT, width=2)
    return img


def icon_pamaypay():
    img, d = canvas(16, 16)
    d.pieslice([1, 2, 15, 14], 180, 360, fill=OUT)
    d.pieslice([2, 3, 14, 13], 180, 360, fill=(196, 168, 120, 255))
    for x in (5, 8, 11):
        d.line([(8, 13), (x, 4)], fill=(140, 116, 80, 255))
    d.line([(7, 13), (9, 15)], fill=WOOD_D, width=2)
    return img


def icon_tabo():
    img, d = canvas(16, 16)
    oellipse(d, (3, 5, 11, 13), (90, 120, 110, 255))
    d.rectangle([3, 5, 11, 7], fill=(64, 88, 82, 255))
    d.line([(11, 7), (15, 4)], fill=OUT, width=3)
    d.line([(11, 7), (15, 4)], fill=WOOD_D, width=1)
    return img


def icon_kwintas():
    img, d = canvas(16, 16)
    d.arc([2, 2, 14, 14], 20, 160, fill=OUT, width=3)
    for x, y in ((4, 9), (6, 11), (8, 12), (10, 11), (12, 9)):
        d.rectangle([x - 1, y - 1, x + 1, y + 1], fill=BONE)
    d.rectangle([7, 12, 9, 14], fill=GOLD)
    return img


def icon_salakot():
    img, d = canvas(16, 16)
    # Wide brim
    orect(d, (2, 9, 13, 11), WOOD)
    d.rectangle([3, 7, 12, 9], fill=WOOD_D)
    # Crown
    opoly(d, [(8, 1), (12, 6), (4, 6)], WOOD)
    d.line([(5, 6), (11, 6)], fill=WOOD_D)
    # Chin strap
    d.line([(4, 6), (3, 10)], fill=WOOD_D, width=2)
    d.line([(12, 6), (13, 10)], fill=WOOD_D, width=2)
    return img


def icon_pana():
    img, d = canvas(16, 16)
    # Bow curve
    d.arc([3, 3, 12, 13], 220, 320, fill=OUT, width=3)
    d.arc([4, 4, 11, 12], 220, 320, fill=WOOD, width=2)
    # Arrow
    d.line([(10, 5), (15, 5)], fill=OUT, width=3)
    d.line([(10, 5), (15, 5)], fill=WOOD_D, width=1)
    d.line([(14, 3), (16, 5)], fill=OUT, width=2)
    d.line([(14, 7), (16, 5)], fill=OUT, width=2)
    return img


def icon_sulo():
    img, d = canvas(16, 16)
    # Torch handle
    orect(d, (6, 10, 9, 15), WOOD_D)
    # Flame
    opoly(d, [(7, 10), (9, 10), (8, 3)], EMBER)
    opoly(d, [(7, 7), (9, 7), (8, 5)], AMBER)
    px(d, 8, 4, WHITE)
    return img


def icon_yoyo():
    img, d = canvas(16, 16)
    # Two yoyo discs
    oellipse(d, (3, 6, 7, 10), STEEL)
    oellipse(d, (8, 6, 12, 10), STEEL)
    d.ellipse([4, 7, 6, 9], fill=STEEL_D)
    d.ellipse([9, 7, 11, 9], fill=STEEL_D)
    # String
    d.line([(7, 11), (7, 15)], fill=OUT, width=2)
    return img


def icon_sibat():
    img, d = canvas(16, 16)
    # Spear shaft
    d.line([(7, 14), (9, 2)], fill=OUT, width=4)
    d.line([(7, 14), (9, 2)], fill=WOOD, width=2)
    # Spear head
    opoly(d, [(8, 1), (10, 1), (8, 4)], STEEL_D)
    return img


def icon_lantaka():
    img, d = canvas(16, 16)
    # Cannon barrel
    orect(d, (2, 6, 13, 10), WOOD_D)
    d.rectangle([3, 7, 12, 9], fill=WOOD)
    # Fuse
    d.line([(13, 8), (15, 6)], fill=OUT, width=2)
    d.line([(13, 8), (15, 6)], fill=(190, 160, 100, 255), width=1)
    px(d, 15, 5, AMBER)
    return img


def icon_kalabaw():
    img, d = canvas(16, 16)
    # Body
    oellipse(d, (2, 8, 12, 14), WOOD_D)
    d.ellipse([4, 9, 11, 13], fill=(120, 96, 68, 255))
    # Head
    opoly(d, [(11, 7), (14, 7), (14, 10), (11, 10)], WOOD_D)
    # Legs
    d.line([(4, 14), (4, 15)], fill=WOOD_D, width=3)
    d.line([(7, 14), (7, 15)], fill=WOOD_D, width=3)
    d.line([(10, 14), (10, 15)], fill=WOOD_D, width=3)
    d.line([(13, 14), (13, 15)], fill=WOOD_D, width=3)
    return img


def icon_kawayan():
    img, d = canvas(16, 16)
    # Bamboo stalks
    orect(d, (4, 2, 6, 14), (120, 150, 100, 255))
    orect(d, (9, 4, 11, 14), (120, 150, 100, 255))
    for x in (4, 10):
        d.line([(x, 4), (x, 14)], fill=(80, 100, 70, 255), width=1)
    d.line([(5, 6), (5, 14)], fill=(80, 100, 70, 255), width=1)
    d.line([(10, 8), (10, 14)], fill=(80, 100, 70, 255), width=1)
    return img


def icon_panyo():
    img, d = canvas(16, 16)
    # Handkerchief
    opoly(d, [(4, 14), (12, 14), (14, 12), (14, 4), (12, 2), (4, 2), (2, 4), (2, 12)], WHITE)
    d.line([(4, 6), (12, 6)], fill=OUT, width=1)
    d.line([(6, 4), (6, 14)], fill=OUT, width=1)
    return img


def icon_puno_ng_balete():
    img, d = canvas(16, 16)
    # Tree with aerial roots
    oellipse(d, (3, 4, 12, 12), GREEN_D)
    d.ellipse([5, 6, 10, 10], fill=GREEN)
    d.line([(7, 12), (6, 15)], fill=WOOD_D, width=2)
    d.line([(8, 12), (9, 15)], fill=WOOD_D, width=2)
    d.line([(6, 12), (4, 15)], fill=WOOD_D, width=2)
    d.line([(9, 12), (11, 15)], fill=WOOD_D, width=2)
    return img


def icon_bagoong():
    img, d = canvas(16, 16)
    # Jar with fermented contents
    orect(d, (4, 6, 11, 14), GREY_D)
    oellipse(d, (4, 4, 11, 10), (110, 140, 60, 255))
    d.line([(5, 7), (10, 7)], fill=(80, 100, 50, 255))
    d.line([(5, 9), (10, 9)], fill=(80, 100, 50, 255))
    return img


ICONS = {
    "itak": icon_itak, "balisong": icon_balisong, "yantok": icon_yantok,
    "sumpit": icon_sumpit, "banga": icon_banga, "bawang": icon_bawang,
    "tsinelas": icon_tsinelas, "kulintang": icon_kulintang,
    "pana": icon_pana, "sulo": icon_sulo, "yoyo": icon_yoyo,
    "sibat": icon_sibat, "lantaka": icon_lantaka, "kalabaw": icon_kalabaw,
    "agimat": icon_agimat, "bakya": icon_bakya, "singsing": icon_singsing,
    "kandila": icon_kandila, "bayong": icon_bayong, "pamaypay": icon_pamaypay,
    "tabo": icon_tabo, "kwintas": icon_kwintas, "salakot": icon_salakot,
    "kawayan": icon_kawayan, "panyo": icon_panyo,
    "puno_ng_balete": icon_puno_ng_balete, "bagoong": icon_bagoong,
}


def alab():
    img, d = canvas(8, 8)
    opoly(d, [(4, 0), (7, 4), (5, 7), (2, 6), (1, 3)], AMBER)
    opoly(d, [(4, 2), (5, 4), (4, 6), (3, 4)], WHITE)
    return img


def barya():
    img, d = canvas(8, 8)
    oellipse(d, (0, 0, 7, 7), GOLD)
    d.ellipse([2, 2, 5, 5], fill=GOLD_D)
    px(d, 2, 1, (255, 236, 170, 255))
    return img


def kandila_world():
    img, d = canvas(12, 12)
    orect(d, (5, 5, 7, 11), BONE)
    opoly(d, [(6, 0), (8, 3), (6, 4), (4, 3)], AMBER)
    px(d, 6, 3, WHITE)
    d.rectangle([3, 10, 9, 11], fill=GREY_D)
    return img


def light_tex():
    size = 256
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px_data = img.load()
    c = size / 2
    for y in range(size):
        for x in range(size):
            dx = (x - c) / c
            dy = (y - c) / c
            r = min(1.0, (dx * dx + dy * dy) ** 0.5)
            a = max(0.0, 1.0 - r)
            a = a ** 1.6
            px_data[x, y] = (255, 244, 214, int(a * 255))
    return img


def particle():
    img = new(4, 4)
    p = img.load()
    p[1, 1] = (255, 255, 255, 255)
    p[2, 1] = (255, 255, 255, 255)
    p[1, 2] = (255, 255, 255, 255)
    p[2, 2] = (255, 255, 255, 255)
    return img


if __name__ == "__main__":
    made = []
    for name, fn in ICONS.items():
        made.append(save(fn(), "icons", name + ".png"))
    made.append(save(alab(), "items", "alab.png"))
    made.append(save(barya(), "items", "barya.png"))
    made.append(save(kandila_world(), "items", "kandila.png"))
    made.append(save(light_tex(), "fx", "light.png"))
    made.append(save(particle(), "fx", "particle.png"))
    print("wrote", len(made), "files")
    from artlib import preview
    preview(made[:19], "preview_items.png", scale=6, cols=7)
