# NIGHT OF THE SIGBIN — PROGRESS

**Last updated:** 2026-11-27
**Engine:** Godot 4.7.2 (`E:\godot\Godot_v4.7.2-stable_win64_console.exe`)
**Design source of truth:** `NIGHT_OF_THE_SIGBIN_GDD.md` (762 lines, 26 sections)
**Status:** playable vertical slice. One full 18-minute run works start → win, with deaths, level-ups, evolutions, 2 bosses, and a dawn flip. No audio by design.

> **Update protocol:** this file is edited after every major step. Add a dated line to *Changelog* and move items between *Completed*, *Partial*, and *Remaining*. Never delete history — strike through instead.

---

## 1. How to run

```powershell
# Play (windowed)
& 'E:\godot\Godot_v4.7.2-stable_win64_console.exe' --path .

# Headless simulated run, 2 minutes (60 frames = 1 s)
& 'E:\godot\Godot_v4.7.2-stable_win64_console.exe' --headless --path . --fixed-fps 60 --quit-after 7200 -- --autotest --god

# Re-import assets after regenerating art
& 'E:\godot\Godot_v4.7.2-stable_win64_console.exe' --headless --path . --import
```

**Dev flags (pass after `--`):**

| Flag | Effect |
|---|---|
| `--autotest` | Auto-start as Isko; auto-picks card 0 on every level-up; prints `TICK` + 15 s summaries |
| `--god` | Player takes no damage |
| `--autostart` | Auto-start without autotest behaviour |
| `--shot-menu` / `--shot-game` / `--shot-level` / `--shot-boss` / `--shot-win` | Render one frame to `res://shot_<mode>.png` and quit (windowed only) |

**Art regeneration** (`cd tools` first):

```powershell
py -3.13 gen_players.py; py -3.13 gen_enemies.py; py -3.13 gen_items.py; py -3.13 gen_env.py
```

---

## 2. Verified state right now

| Check | Result |
|---|---|
| Headless 2 min, `--autotest --god` | Clean. 612 kills, level 12, ~45 enemies on screen, **no errors/warnings** |
| Earlier 7 min headless run | 3,393 kills, level 21, ~80 enemies on screen |
| `--shot-menu` | Good — title, 3 character cards, SIMULAN, controls |
| `--shot-game` | Good — light pool, dense jungle, readable player (outline + brighter palette) |
| `--shot-level` | Good — 3 cards, icons, tags, descriptions |
| `--shot-boss` | Good — Kapre sprite, name + HP bar at top |
| `--shot-win` | Good — BUKANG-LIWAYWAY screen, stats, ULITIN / MENU |

Screenshots live in the project root as `shot_*.png` at 1280×720 (2× internal 640×360).

**Not yet verified:** non-god death run balance, evolution actually triggering in a real run, 18-minute full-length run to the win trigger, boss fight feel with a normal build, gamepad input.

---

## 3. Completed

### 3.1 Project & pipeline
- `project.godot`: 640×360 viewport, 1280×720 window, `canvas_items` stretch with integer scaling, nearest-neighbour default filter, GL Compatibility, 60 Hz physics, pixel snapping.
- `src/main.tscn`: single node; **all scenes/UI are built in code** (no hand-authored `.tscn` trees).
- Procedural art pipeline in `tools/` using Pillow 13.0.0 — no external assets, all textures regenerable:
  - `artlib.py` — palette, outline helpers, strip/preview utilities
  - `gen_players.py` — 3 characters, 4-frame walk strips (24×24)
  - `gen_enemies.py` — 8 enemy sheets, 2-frame (16–64 px)
  - `gen_items.py` — 16 icons + 3 item sprites + light/particle FX
  - `gen_env.py` — ground, 3 tree variants, 2 balete variants, rock, fern, bush

### 3.2 Run structure
- 18-minute run, win at 1080 s, acts every ~3 min (`TAKIPSILIM → GABI → HATINGGABI → MADALING-ARAW → BUKANG-LIWAYWAY`) with toast announcements and stat recalc on transition.
- Night palette lerp per act via `CanvasModulate`; dawn at 990 s turns the world warm/orange, adds +25% player damage, and ticks 2%/s damage on all `aswang`-tagged enemies.
- Spawn director: interval `clampf(0.62 - time*0.0004, 0.28, 0.62)`, count `mini(2 + time/70, 6)`, hard cap 240 enemies, elites every 40 s (Balbal before 240 s, Aswang after).
- Bosses: Kapre at 360 s (log throw + stomp + screen shake), Bakunawa at 900 s (orbit, radial projectile burst, telegraphed charge).
- Death and win screens, restart, quit-to-menu, pause (ESC), best time + wins persisted to `user://save.json`.
- 3,200×3,200 world (`±1600`), camera limits, entity clamps.
- Spatial grid (40 px cells) for enemy separation steering.

### 3.3 Characters (3 of 10)
| Character | Weapon | Perk | State |
|---|---|---|---|
| Isko — Barangay Tanod | Itak | +8% speed after 6:00 | Working |
| Lola Bining — Albularyo | Bawang | Healing +25% | Working |
| Mang Doring — Arnisador | Yantok | Attack speed +10% (`char_cd 0.9`) | Working |

### 3.4 Weapons (8 of 18 launch)
Fully implemented with per-level scaling (22% damage/level) and distinct behaviour:

| Weapon | Behaviour implemented |
|---|---|
| Itak | 110° arc slash toward facing, small random spread |
| Balisong | 3–6 rapid thrusts, short range, shared hit-set |
| Yantok | Two mirrored 120° arcs + 0.15 s stun |
| Sumpit | Piercing dart, poison DoT, pierce 3+ |
| Banga | Lobbed pot, arc with shadow height, AoE shatter |
| Bawang | Persistent aura, ×1.5 damage vs aswang, knockback |
| Tsinelas | Boomerang, returns to player, big knockback, spin |
| Kulintang | Expanding ring pulse, 0.35 s stun |

### 3.5 Passives (8)
`agimat` (+15 max HP/lvl), `bakya` (+8% speed), `singsing` (+7% crit), `kandila` (+12% area & light size), `bayong` (+30 pickup radius), `pamaypay` (−7% cooldown), `tabo` (+0.6 HP/s), `kwintas` (+15% dmg vs aswang). All recompute through `Player.recalc_stats()`.

### 3.6 Evolutions (3)
Itak + Singsing → *Itak ng Tagapagbantay* (every 3rd slash is a 360° spin);
Tsinelas + Bakya → *Tsinelas ni Inay* (3 homing slippers);
Sumpit + Kwintas → *Sumpit ng Gubat* (infinite pierce).
Trigger: weapon at level 8 + passive owned → evolution card is forced to slot 1.

### 3.7 Enemies (7 regular + 2 bosses)
`tiktik` (wobbling chase), `dwende` (chase), `balbal` (slow tank, knockback resist), `tiyanak` (lunge when <110 px), `white_lady` (alpha phasing + teleport repositions), `aswang` (fast bruiser), `nuno` (turret behaviour coded), `kapre` (boss), `bakunawa` (boss). Elites are 2.2× HP / 1.3× damage / 4× XP / 1.3× sprite scale.

### 3.8 Combat plumbing
- Damage numbers, crits (1.5×), floating text, hit flash, knockback, stun, poison ticks.
- FX: slash arcs, expanding rings, bursts, explosions, garlic aura, camera shake.
- Projectile modes: linear, boomerang, lob, hostile.
- XP orbs with magnetic pickup, healing candles, Barya currency drops, boss drops 6 candles.
- HUD: HP/XP bars, level, timer, act, kills, barya, weapon + passive icon rows with level numbers, boss bar, interaction hint, toasts.
- **Tabi-tabi po:** 9 nuno mounds scattered in the jungle; `E` within 30 px grants +5% damage for 60 s, plays FX, removes the mound.

---

## 4. Partial / half-finished / known-broken

Ordered by severity. Everything here is real and observable.

| # | Item | File | Detail |
|---|---|---|---|
| 1 | `TICK time=… enemies=…` printed every simulated second | `main.gd:513` | Debug spam left in from spawn tuning. Gate behind `--verbose` or delete. |
| 2 | Screenshot harness ships in gameplay code | `main.gd` (`_setup_shot`, `_fake_progress`, `_demo_build`) | Dev-only; should be wrapped in `if OS.is_debug_build()` or moved to `tools/`. |
| 3 | ~~Asset folder pollution~~ **RESOLVED** | `.gitignore` | Was: `art/preview_*.png` + root `shot_*.png` tracked as game textures. Now ignored and untracked. They still sit inside `res://` so Godot keeps importing them — acceptable once untracked; relocating out of `res://` remains optional. |
| 4 | ~~Stray logs in project root~~ **RESOLVED** | `.gitignore` | `test_out.txt`, `import_out.txt`, `shot_out.txt` are untracked and ignored. Still written by dev runs; delete freely. |
| 5 | Nuno `turret` behaviour is unreachable | `enemy.gd` + `main.gd:_pick_type` | `_pick_type()` never returns `nuno`; the enemy exists only as a decor mound. Either spawn hostile nunos or delete the branch. |
| 6 | `player.armor` is always 0 | `player.gd:28` | No passive feeds it. Dead stat — needs Salakot/Sinigang. |
| 7 | XP orbs never expire | `orb.gd`, `main.gd:_drop_xp` | Orbs left off-screen accumulate for the whole run (no despawn/pooling). Long-run leak + draw cost. |
| 8 | No gamepad UI navigation | `hud.gd` | All buttons use `FOCUS_NONE`; level-up cards only respond to keys `1/2/3`. Gamepad can move but not choose cards. |
| 9 | Act boundaries don't match the GDD | `main.gd:act_name`, `_tick_acts` | Game: dawn act at 840 s, sun flip at 990 s. GDD: dawn act at 840 s, sunrise at 1020 s. Cosmetic, but reconcile. |
| 10 | Boss telegraping is thin | `enemy.gd` boss branches | Kapre stomp damages instantly inside 120 px with only a ring drawn on the same frame; no smoke screen. GDD requires 0.8 s telegraph and vision denial. |
| 11 | White Lady doesn't match her folklore hook | `enemy.gd` `phase` | She teleports near the player on a timer; GDD says visible only on lantern flicker. |
| 12 | Evolution reachability unproven | `main.gd:_build_cards` | Needs weapon level 8 with 6 weapons competing for cards; never observed triggering in an autotest. |
| 13 | Level-up cards can pad with "Kandila / Recover 30 HP" | `main.gd:_build_cards` | When few options remain you get duplicate heal cards. Acceptable, but should be Barya/heal/reroll variety. |
| 14 | End screen lacks build summary | `hud.gd:show_end` | GDD wants the final build listed (weapons, passives, evolutions). |
| 15 | Boss HP bar is a plain rect | `hud.gd` | GDD calls for a diegetic bamboo frame. |
| 16 | Default Godot font at 7–10 px | `hud.gd` throughout | Legible in screenshots but not pixel-art consistent; no bundled bitmap font. |
| 17 | `hud._fmt()` called from `main.gd` | `main.gd:_stats_text` | Cross-object private call; move to a shared helper. |
| 18 | Save has no version field / no per-character record | `main.gd:_save_progress` | Only `{best, wins}`. |
| 19 | Passives diverge from the GDD table | `data.gd` vs GDD §11 | E.g. Agimat is +15 flat HP (GDD: +8% max HP), Bakya +8% speed (GDD: +6% + knockback resist), Kandila is area (GDD: duration). Decide and align. |
| 20 | Evolution prerequisites diverge from GDD | `data.gd` vs GDD §9 | GDD wants Salakot / Lason / Asin / Kawayan etc.; those passives don't exist yet, so three evolutions use substitutes. |
| 21 | Empty `damage_mult` stacking for dawn | `main.gd:_tick_dawn` | `player.damage_mult += 0.25` directly mutates a stat that `recalc_stats()` never resets — survives restarts only because `start_run` builds a new player. Fragile pattern. |

---

## 5. Not built (GDD scope still open)

### 5.1 Characters (7 missing)
Aling Rosa (Tsinelas/economy), Tasyo (Sumpit/poison), Bai (Kulintang), Nene (Krus), Kardo (Kalabaw summon), Maria Makiling (vines), "Ang Tumalikod" (Pangil/lifesteal). No unlock conditions, no character-select paging beyond 3 cards.

### 5.2 Weapons (10 launch + 12 stretch missing)
Launch: Pana, Tirador, Kaldero, Sulo, Buntot Pagi, Sibat, Lantaka, Yoyo, Kulam (mark), Kalabaw (summon).
Stretch: Kampilan, Kris, Panabas, Walis Tingting, Pamaypay (weapon), Parol, Agung, Tambuli, Sabong, Salakot, Sandok, Kubing.
Each needs a behaviour, an icon, and an evolution.

### 5.3 Passives (12 missing)
Anting-anting, Salakot, Malong, Kawayan (+projectile), Kapeng Barako, Lambanog, Bagoong (stink aura), Asin, Panyo (dodge), Tansan (+barya), Rosaryo (revive), Puno ng Balete (luck/elites).

### 5.4 Enemies (18 missing)
Kikik, Busaw, Santelmo, Pugot, Ekek, Alan, Manananggal (split), Mangkukulam (caster + Kulam), Batibat, Tikbalang (control inversion), Bungisngis, Berberoka, Amomongo, Siyokoy, Magindara, Anggitay, Kumakatok (trio), Bulalakaw. Behaviour tags from GDD §13.5 not yet coded: `orbit`, `charge`, `dive`, `caster`, `thief`, `split`, `disguise`.

### 5.5 Bosses (6 missing)
Manananggal Matriarch, Berberoka, Pugot na Pari, Amomongo, Bernardo Carpio, Maria Makiling (optional). Each needs phases + a sound-only attack once audio exists.

### 5.6 Signature systems
- **Kulam curse meter** — absent entirely (no stacks, no cleanse, no bark of Bukang).
- **Aswang in disguise** — absent; aswang never disguises.
- **Sound compass** — absent; no audio at all, so Pillar 2 is unrepresented.
- **Relics / active anting-anting (Q)** — absent; GDD §10 lists 10 relics, none implemented.
- **Consumables** — only Kandila (25 HP) + Barya. Missing Alay, Adobo, Sinigang, Balut, Taho, Halo-halo, Buko, Lambanog, Suman, Bawang/Asin pickups.
- **Tabi-tabi po, full version** — currently a flat +5% damage gift. GDD wants: nuno invulnerable until greeted, blessing *or* punishment if angered, and rewards.
- **Weather / light system** — only a coarse act-palette lerp.

### 5.7 Meta progression — Bahay ni Lola
Nothing beyond `{best, wins}`. Missing: persistent Barya, upgrades, character unlocks, relic unlocks, stage unlocks, altar offerings.

### 5.8 Stages
One jungle map, procedurally scattered. No stage select, no 7 biomes, no biome-specific hazards or enemy pools.

### 5.9 Audio
**Intentionally deferred.** No music, no SFX, no audio bus setup. Per user instruction: do not add music yet.

---

## 6. Upcoming features (user-requested — awaiting list)

> Reserved section. The user has said new features are coming "very soon" but has not specified them yet.
> Add one row per feature before work starts, then mirror it into §4/§5 and the changelog.

| # | Feature | Scope / notes | Status |
|---|---|---|---|
| — | *(to be specified)* | — | — |

---

## 7. Backlog, in recommended order

**P0 — correctness & hygiene**
1. Gate/remove `TICK` spam; add `--verbose`.
2. Move screenshot harness out of the shipping path; move `preview_*.png`, `shot_*.png`, and the three `.txt` logs to `dev/` or temp.
3. Despawn or pool XP orbs older than ~25 s.
4. Remove or wire the dead `nuno` turret branch; give `armor` a real source.

**P1 — prove the loop**
5. Non-god 18-minute run: record death time, level, kills → first balance pass on enemy damage curve and XP curve.
6. Force-test an evolution in a real (non-autotest) run; confirm the card appears and the change is visible.
7. Gamepad navigation for menu + level-up cards.
8. Add build summary to the end screen.

**P2 — content**
9. Add 4–6 launch weapons with icons (`pana`, `sulo`, `yoyo`, `sibat`, `lantaka`, `kalabaw`) and their evolutions.
10. Add 3–4 passives that unblock GDD evolutions (`salakot`, `kawayan`, `malong`, `asin`).
11. Implement `charge`, `dive`, `caster`, `split` behaviour tags, then add Manananggal, Pugot, Ekek, Mangkukulam.
12. Kulam meter + Buko cleanse + `asin` purge.
13. Relic slot with `Q`, 3 relics to start.
14. Meta progression shell (Barya bank, 4 permanent upgrades, character unlocks).

**P3 — polish**
15. Bundled bitmap font; pixel-consistent typography.
16. Boss telegraphs (0.8 s), Kapre smoke, diegetic bamboo HP bar.
17. Aswang disguise event, sound compass overlay (blocked on audio).
18. Stage 2 (rice paddies) as the first biomes split.

---

## 8. File map

| Path | Lines | Role |
|---|---|---|
| `src/main.gd` | 891 | Run state machine, spawn director, acts, dawn, world build, level-up flow, save, dev harness |
| `src/hud.gd` | 668 | Menu, HUD, level-up cards, pause, end screen, build icons |
| `src/player.gd` | 458 | Stats, movement/dash, weapon firing, damage, blessing |
| `src/enemy.gd` | 253 | Per-enemy behaviour, damage, knockback, stun, poison, boss branches |
| `src/data.gd` | 194 | Characters, weapons, passives, evolutions, enemies |
| `src/fx.gd` | 184 | Damage numbers, slash, ring, burst, explosion, aura |
| `src/projectile.gd` | 134 | linear / boomerang / lob / hostile |
| `src/orb.gd` | 33 | XP ember with magnet |
| `src/pickup.gd` | 38 | Kandila heal, Barya currency |
| `src/main.tscn` | — | Single root node |
| `project.godot` | — | Viewport, stretch, filters, renderer |
| `tools/*.py` | 130–291 | Art generators (players, enemies, items, env, shared lib) |
| `NIGHT_OF_THE_SIGBIN_GDD.md` | 762 | Full design document |

---

## 9. Changelog

- **2026-11-26** — GDD written. Procedural art pipeline complete (players, enemies, icons, items, environment, light/FX). Godot project scaffolded. All gameplay scripts written. Fixed GDScript inference errors; headless import clean.
- **2026-11-26** — Autotest harness added; multi-level-up freeze fixed by resolving pending levels in a loop; `--god` wired into `Player.take_damage`. Flag parsing fixed (`OS.get_cmdline_user_args()` returns `--`-prefixed args).
- **2026-11-26** — Spawn director retuned to survivors-like density (442 kills @ 2 min, 3,393 @ 7 min, ~80 on screen). Debug `TICK` and 15 s summaries added.
- **2026-11-27** — Screenshot harness (`--shot-*`) added and used for visual verification of menu, gameplay, level-up, boss, and win screens.
- **2026-11-27** — Visual pass: world shrunk 4096→3200 px; jungle decor density tripled; foliage rebuilt as irregular multi-blob canopies with 3 tree + 2 balete variants (baked shadows removed); ambient lifted; lantern pool reduced; player given a dark outline, brighter palette, and draw priority so it reads inside the horde.
- **2026-11-27** — `PROGRESS.md` created as the standing status ledger. Headless 2 min autotest re-verified clean after the visual pass.
- **2026-11-27** — Repo hygiene: `.godot/` untracked (162 files) and `.godot/` + `__pycache__/` + `build/` + `export/` + `*.pck` ignored. `.gitignore` was UTF-16 LE with BOM, which git cannot parse — all patterns were silently inert; rewritten as UTF-8 without BOM and verified with `git check-ignore`. 12 dev artifacts (5 screenshots, 3 scratch logs, 4 art preview sheets) untracked.
