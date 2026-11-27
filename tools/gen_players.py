"""Generate the three playable characters as 4-frame walk strips (24x24)."""
import sys
from PIL import ImageDraw
from artlib import (
    canvas, save, strip, rim, orect, opoly, px,
    OUT, SKIN, SKIN_D, HAIR, BONE, STEEL, STEEL_D, WOOD, WOOD_D,
    GOLD, RED, WHITE, GREEN_D, MOON, ART,
)

CFG = {
    "isko": dict(
        skin=SKIN, hair=HAIR, shirt=(52, 104, 128, 255), shirt_d=(30, 62, 80, 255),
        pants=(96, 84, 62, 255), accent=(208, 60, 52, 255), held="bolo",
    ),
    "bining": dict(
        skin=(210, 158, 112, 255), hair=(226, 222, 210, 255), shirt=(158, 58, 66, 255),
        shirt_d=(108, 36, 44, 255), pants=(104, 72, 62, 255), accent=(226, 190, 106, 255),
        held="bag", female=True, dress=True,
    ),
    "doring": dict(
        skin=(182, 124, 78, 255), hair=HAIR, shirt=(78, 104, 72, 255), shirt_d=(48, 68, 48, 255),
        pants=(72, 64, 52, 255), accent=(206, 72, 52, 255), held="sticks",
    ),
}


def draw_legs(d, fr, c):
    pants = c["pants"]
    foot = (36, 32, 28, 255)
    if fr in (0, 2):
        for x in (9, 13):
            orect(d, (x, 18, x + 1, 21), pants)
            orect(d, (x - 1, 22, x + 1, 22), foot)
    elif fr == 1:
        orect(d, (8, 18, 9, 21), pants)
        orect(d, (7, 22, 9, 22), foot)
        orect(d, (14, 18, 15, 20), pants)
        orect(d, (14, 21, 16, 21), foot)
    else:
        orect(d, (9, 18, 10, 20), pants)
        orect(d, (8, 21, 10, 21), foot)
        orect(d, (13, 18, 14, 21), pants)
        orect(d, (13, 22, 15, 22), foot)


def draw_arms(d, bob, c):
    sleeve = c["shirt"]
    skin = c["skin"]
    orect(d, (5, 12 + bob, 6, 16 + bob), sleeve)
    orect(d, (6, 16 + bob, 7, 17 + bob), skin)
    orect(d, (16, 12 + bob, 17, 15 + bob), sleeve)
    orect(d, (16, 15 + bob, 17, 17 + bob), skin)


def draw_held(d, bob, c):
    held = c["held"]
    if held == "bolo":
        orect(d, (16, 13 + bob, 17, 15 + bob), WOOD_D)
        opoly(d, [(18, 13 + bob), (21, 16 + bob), (20, 17 + bob), (17, 14 + bob)], STEEL)
        px(d, 20, 16 + bob, WHITE)
    elif held == "bag":
        orect(d, (17, 14 + bob, 20, 18 + bob), (176, 138, 82, 255))
        d.line([(17, 14 + bob), (15, 11 + bob)], fill=WOOD_D)
        d.line([(19, 15 + bob), (19, 17 + bob)], fill=WOOD_D)
    elif held == "sticks":
        d.line([(15, 11 + bob), (21, 17 + bob)], fill=OUT, width=3)
        d.line([(15, 11 + bob), (21, 17 + bob)], fill=WOOD, width=1)
        d.line([(21, 11 + bob), (15, 17 + bob)], fill=OUT, width=3)
        d.line([(21, 11 + bob), (15, 17 + bob)], fill=WOOD, width=1)


def draw_head(d, bob, c):
    skin = c["skin"]
    hair = c["hair"]
    orect(d, (8, 3 + bob, 15, 10 + bob), skin)
    # hair
    orect(d, (8, 3 + bob, 15, 5 + bob), hair)
    orect(d, (7, 4 + bob, 8, 8 + bob), hair)
    orect(d, (15, 4 + bob, 16, 8 + bob), hair)
    if c.get("female"):
        orect(d, (7, 6 + bob, 8, 11), hair)
        orect(d, (15, 6 + bob, 16, 11), hair)
        orect(d, (10, 1 + bob, 12, 2 + bob), hair)  # bun
    # face
    px(d, 10, 7 + bob, OUT)
    px(d, 13, 7 + bob, OUT)
    d.line([(11, 9 + bob), (13, 9 + bob)], fill=SKIN_D)
    # accent (bandana / scarf)
    orect(d, (8, 5 + bob, 15, 6 + bob), c["accent"])


def draw_body(d, bob, c):
    shirt = c["shirt"]
    shirt_d = c["shirt_d"]
    if c.get("dress"):
        opoly(d, [(7, 15), (16, 15), (18, 21), (5, 21)], shirt)
        d.line([(7, 16), (16, 16)], fill=shirt_d)
        d.line([(6, 19), (17, 19)], fill=c["accent"])
    else:
        orect(d, (8, 11 + bob, 15, 17 + bob), shirt)
        d.line([(8, 12 + bob), (15, 12 + bob)], fill=shirt_d)
        d.rectangle([10, 13 + bob, 13, 16 + bob], fill=shirt_d)
        d.line([(9, 11 + bob), (14, 17 + bob)], fill=c["accent"])


def build(key):
    c = CFG[key]
    frames = []
    for fr in range(4):
        img, d = canvas(24, 24)
        bob = -1 if fr in (1, 3) else 0
        draw_legs(d, fr, c)
        draw_body(d, bob, c)
        draw_arms(d, bob, c)
        draw_head(d, bob, c)
        draw_held(d, bob, c)
        rim(img, MOON, 70)
        frames.append(img)
    return strip(frames)


if __name__ == "__main__":
    made = []
    for key in CFG:
        img = build(key)
        made.append(save(img, "players", key + ".png"))
        print("wrote", made[-1])
    from artlib import preview
    preview(made, "preview_players.png", scale=6, cols=3)
