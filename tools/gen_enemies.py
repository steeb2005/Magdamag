"""Generate enemy sprites. Two-frame strips, native pixel sizes."""
import random
from PIL import ImageDraw
from artlib import (
    canvas, save, strip, rim, orect, opoly, oellipse, px,
    OUT, OUT_SOFT, SKIN, SKIN_D, HAIR, BONE, STEEL, WOOD, WOOD_D,
    GOLD, AMBER, EMBER, RED, RED_D, BLOOD, MOON, WHITE, GREY, GREY_D,
    GREEN, GREEN_D, GREEN_L, PURPLE, PURPLE_L, ART,
)


def speckle(d, box, color, n, seed=1):
    rng = random.Random(seed)
    x0, y0, x1, y1 = box
    for _ in range(n):
        d.point((rng.randint(x0, x1), rng.randint(y0, y1)), fill=color)


def tiktik(fr):
    img, d = canvas(16, 16)
    body = (46, 42, 56, 255)
    wing = (62, 56, 74, 255)
    if fr == 0:
        opoly(d, [(7, 6), (0, 2), (2, 8), (7, 9)], wing)
        opoly(d, [(8, 6), (15, 2), (13, 8), (8, 9)], wing)
    else:
        opoly(d, [(7, 7), (1, 11), (3, 14), (7, 10)], wing)
        opoly(d, [(8, 7), (14, 11), (12, 14), (8, 10)], wing)
    opoly(d, [(5, 4), (6, 0), (8, 4)], body)
    opoly(d, [(10, 4), (9, 0), (11, 4)], body)
    orect(d, (6, 4, 9, 10), body)
    orect(d, (6, 10, 9, 12), body)
    px(d, 7, 7, RED)
    px(d, 9, 7, RED)
    return rim(img)


def dwende(fr):
    img, d = canvas(16, 16)
    skin = (150, 110, 76, 255)
    hat = (150, 44, 48, 255)
    beard = (214, 206, 186, 255)
    step = 0 if fr == 0 else 1
    opoly(d, [(5, 1), (11, 6), (4, 6)], hat)
    orect(d, (5, 6, 10, 9), skin)
    px(d, 6, 7, OUT)
    px(d, 9, 7, OUT)
    d.rectangle([5, 9, 10, 11], fill=beard)
    orect(d, (5, 11, 10, 13), (86, 62, 44, 255))
    orect(d, (4, 14 - step, 6, 15), (58, 40, 30, 255))
    orect(d, (9, 14 + step - 1, 11, 15), (58, 40, 30, 255))
    return rim(img)


def balbal(fr):
    img, d = canvas(20, 20)
    skin = (150, 148, 136, 255)
    skin_d = (108, 108, 100, 255)
    sway = 1 if fr else 0
    orect(d, (7, 2, 13, 8), skin)
    d.rectangle([8, 4, 9, 5], fill=OUT)
    d.rectangle([11, 4, 12, 5], fill=OUT)
    px(d, 8, 4, RED)
    px(d, 11, 4, RED)
    d.line([(9, 7), (11, 7)], fill=skin_d)
    orect(d, (6, 8, 14, 15), skin)
    # long arms
    d.line([(6, 9), (3 + sway, 17)], fill=OUT, width=3)
    d.line([(6, 9), (3 + sway, 17)], fill=skin, width=1)
    d.line([(14, 9), (17 - sway, 17)], fill=OUT, width=3)
    d.line([(14, 9), (17 - sway, 17)], fill=skin, width=1)
    # loincloth
    d.rectangle([6, 14, 14, 17], fill=(58, 44, 40, 255))
    # legs
    orect(d, (7, 17, 8, 19), skin_d)
    orect(d, (11, 17, 12, 19), skin_d)
    speckle(d, (7, 9, 13, 14), skin_d, 6, 3)
    return rim(img)


def tiyanak(fr):
    img, d = canvas(16, 16)
    skin = (196, 172, 158, 255)
    step = 1 if fr else 0
    oellipse(d, (3, 2, 12, 10), skin)
    d.rectangle([5, 5, 6, 6], fill=OUT)
    d.rectangle([9, 5, 10, 6], fill=OUT)
    px(d, 6, 5, RED)
    px(d, 9, 5, RED)
    # fangs
    d.point((6, 8), fill=WHITE)
    d.point((9, 8), fill=WHITE)
    orect(d, (5, 10, 10, 13), (120, 104, 96, 255))
    # claws
    d.line([(4, 11), (1, 13 - step)], fill=OUT, width=2)
    d.line([(11, 11), (14, 13 + step)], fill=OUT, width=2)
    d.point((1, 14 - step), fill=WHITE)
    d.point((14, 14 + step), fill=WHITE)
    orect(d, (5, 14, 6, 15), skin)
    orect(d, (9, 14, 10, 15), skin)
    return rim(img)


def white_lady(fr):
    img, d = canvas(24, 24)
    dress = (222, 226, 232, 255)
    dress_d = (160, 174, 190, 255)
    sway = 1 if fr else 0
    opoly(d, [(9, 8), (15, 8), (19 + sway, 22), (4 - sway, 22)], dress)
    d.line([(6, 18), (18, 18)], fill=dress_d)
    d.line([(5, 21), (19, 21)], fill=dress_d)
    # wispy hem
    for x in range(5, 20, 3):
        d.point((x, 23), fill=dress)
    orect(d, (10, 4, 14, 9), (208, 200, 190, 255))
    orect(d, (8, 2, 16, 6), HAIR)
    orect(d, (8, 6, 9, 13), HAIR)
    orect(d, (15, 6, 16, 13), HAIR)
    px(d, 11, 8, (60, 30, 40, 255))
    px(d, 13, 8, (60, 30, 40, 255))
    d.line([(10, 9), (14, 9)], fill=(90, 40, 50, 255))
    # reaching arms
    d.line([(9, 11), (6, 15 + sway)], fill=OUT, width=3)
    d.line([(9, 11), (6, 15 + sway)], fill=dress, width=1)
    d.line([(15, 11), (18, 15 - sway)], fill=OUT, width=3)
    d.line([(15, 11), (18, 15 - sway)], fill=dress, width=1)
    return rim(img, MOON, 110)


def aswang(fr):
    img, d = canvas(24, 24)
    body = (54, 50, 60, 255)
    body_l = (82, 76, 88, 255)
    cloth = (70, 40, 44, 255)
    sway = 1 if fr else 0
    orect(d, (8, 3, 15, 9), body)
    d.rectangle([10, 5, 11, 6], fill=OUT)
    d.rectangle([13, 5, 14, 6], fill=OUT)
    px(d, 10, 5, RED)
    px(d, 13, 5, RED)
    # long tongue
    d.line([(12, 8), (12 + sway, 15)], fill=RED_D, width=3)
    d.line([(12, 8), (12 + sway, 15)], fill=RED, width=1)
    orect(d, (7, 9, 16, 17), body)
    d.line([(8, 11), (15, 11)], fill=body_l)
    # tattered skirt
    opoly(d, [(7, 16), (16, 16), (18, 21), (14, 19), (12, 22), (9, 19), (5, 21)], cloth)
    # arms + claws
    d.line([(7, 10), (3, 16 + sway)], fill=OUT, width=3)
    d.line([(7, 10), (3, 16 + sway)], fill=body, width=1)
    d.line([(16, 10), (20, 16 - sway)], fill=OUT, width=3)
    d.line([(16, 10), (20, 16 - sway)], fill=body, width=1)
    for tip in ((2, 17 + sway), (3, 18 + sway), (21, 17 - sway), (22, 18 - sway)):
        d.point(tip, fill=BONE)
    orect(d, (9, 21, 10, 22), body_l)
    orect(d, (13, 21, 14, 22), body_l)
    return rim(img)


def nuno(fr):
    img, d = canvas(16, 16)
    soil = (104, 78, 50, 255)
    soil_d = (74, 54, 36, 255)
    oellipse(d, (1, 8, 14, 15), soil)
    speckle(d, (2, 9, 13, 14), soil_d, 8, 5)
    # grass tuft
    d.line([(3, 8), (2, 5)], fill=GREEN_D)
    d.line([(4, 8), (5, 4)], fill=GREEN)
    d.line([(12, 8), (13, 5)], fill=GREEN_D)
    # face
    d.rectangle([6, 10, 7, 11], fill=OUT)
    d.rectangle([10, 10, 11, 11], fill=OUT)
    px(d, 7, 10, AMBER)
    px(d, 10, 10, AMBER)
    d.rectangle([6, 12, 11, 13], fill=(206, 198, 180, 255))
    # tiny hat
    opoly(d, [(7, 6), (9, 9), (6, 9)], (96, 70, 46, 255))
    return rim(img)


def kapre(fr):
    img, d = canvas(48, 48)
    bark = (56, 54, 42, 255)
    bark_l = (82, 78, 60, 255)
    bark_d = (34, 34, 28, 255)
    moss = (50, 84, 52, 255)
    moss_l = (78, 118, 68, 255)
    smoke = (116, 116, 118, 255)
    sway = 1 if fr else 0
    # canopy growing out of its head
    oellipse(d, (14, 0, 34, 10), moss)
    oellipse(d, (8, 2, 21, 9), moss)
    oellipse(d, (27, 1, 40, 9), moss_l)
    oellipse(d, (17, 0, 27, 6), moss_l)
    # legs
    orect(d, (13, 38, 20, 47), bark_d)
    orect(d, (27, 38, 34, 47), bark_d)
    # torso
    oellipse(d, (9, 17, 38, 43), bark)
    d.arc([12, 21, 35, 42], 200, 340, fill=bark_l, width=2)
    for y in range(24, 40, 5):
        d.line([(13, y), (33, y + 1)], fill=bark_d)
    # arms
    orect(d, (3, 20, 10, 39), bark_d)
    orect(d, (37, 20, 44, 39), bark_d)
    oellipse(d, (0, 36, 11, 44), bark_d)
    oellipse(d, (36, 36, 47, 44), bark_d)
    # head
    oellipse(d, (16, 7, 32, 21), bark)
    d.rectangle([19, 12, 22, 14], fill=OUT)
    d.rectangle([26, 12, 29, 14], fill=OUT)
    px(d, 20, 13, AMBER)
    px(d, 27, 13, AMBER)
    d.line([(18, 10), (22, 11)], fill=bark_d)
    d.line([(26, 11), (30, 10)], fill=bark_d)
    # mossy beard
    opoly(d, [(17, 16), (31, 16), (30, 23), (26, 26), (22, 24), (18, 23)], (142, 138, 122, 255))
    d.point((22, 20), fill=(96, 92, 80, 255))
    d.point((26, 21), fill=(96, 92, 80, 255))
    # pipe with ember
    d.line([(30, 18), (37, 15)], fill=OUT, width=3)
    d.line([(30, 18), (37, 15)], fill=WOOD_D, width=1)
    d.rectangle([36, 13, 38, 16], fill=(70, 70, 70, 255))
    px(d, 37, 13, EMBER)
    for i, (sx, sy) in enumerate(((40, 10 + sway), (43, 6), (39, 3))):
        oellipse(d, (sx - 3, sy - 2, sx + 2, sy + 2), smoke)
    return rim(img, AMBER, 40)


def bakunawa(fr):
    img, d = canvas(64, 64)
    scale = (46, 92, 88, 255)
    scale_l = (82, 142, 130, 255)
    scale_d = (26, 58, 58, 255)
    # coiled body sweeping right and down
    d.arc([26, 24, 62, 62], 250, 90, fill=scale_d, width=12)
    d.arc([29, 27, 59, 59], 250, 90, fill=scale, width=7)
    for y in range(30, 58, 5):
        for x in range(34, 60, 6):
            d.point((x, y), fill=scale_l)
    # head
    opoly(d, [(2, 26), (12, 16), (30, 14), (40, 22), (38, 32), (30, 38), (12, 38), (4, 34)], scale)
    opoly(d, [(4, 26), (13, 19), (29, 17), (37, 23), (35, 30), (28, 35), (13, 35), (6, 32)], scale_d)
    opoly(d, [(6, 26), (14, 21), (28, 19), (34, 24), (32, 29), (27, 32), (14, 32), (8, 30)], scale)
    # horns
    opoly(d, [(20, 15), (16, 3), (26, 12)], BONE)
    opoly(d, [(30, 15), (34, 4), (37, 16)], BONE)
    # brow + eye
    d.rectangle([13, 22, 20, 27], fill=OUT)
    d.rectangle([14, 23, 19, 26], fill=RED)
    px(d, 15, 24, AMBER)
    d.line([(12, 21), (21, 20)], fill=scale_d)
    # jaw
    if fr == 0:
        d.line([(4, 31), (30, 33)], fill=OUT, width=2)
        for x in range(7, 30, 4):
            d.point((x, 31), fill=WHITE)
    else:
        opoly(d, [(4, 30), (30, 31), (27, 42), (7, 40)], (42, 26, 32, 255))
        for x in range(7, 27, 4):
            d.point((x, 31), fill=WHITE)
            d.point((x + 1, 39), fill=WHITE)
        d.line([(13, 35), (23, 37)], fill=RED)
    # scales + fin
    for y in range(20, 34, 4):
        for x in range(10, 34, 5):
            d.point((x, y), fill=scale_l)
    opoly(d, [(24, 14), (27, 6), (30, 14)], scale_l)
    return rim(img, MOON, 90)


ENEMIES = {
    "tiktik": (tiktik, 16),
    "dwende": (dwende, 16),
    "balbal": (balbal, 20),
    "tiyanak": (tiyanak, 16),
    "white_lady": (white_lady, 24),
    "aswang": (aswang, 24),
    "nuno": (nuno, 16),
    "kapre": (kapre, 48),
    "bakunawa": (bakunawa, 64),
}

if __name__ == "__main__":
    made = []
    for name, (fn, size) in ENEMIES.items():
        frames = [fn(0), fn(1)]
        made.append(save(strip(frames), "enemies", name + ".png"))
        print("wrote", made[-1])
    from artlib import preview
    preview(made, "preview_enemies.png", scale=3, cols=3)
