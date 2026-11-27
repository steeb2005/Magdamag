# NIGHT OF THE SIGBIN
### Game Design Document — v0.1 (concept)

| | |
|---|---|
| **Working title** | *Night of the Sigbin* |
| **Alt titles** | *Hatinggabi*, *Tabi-Tabi Po*, *Bukang-Liwayway* |
| **Genre** | Survivors-like / bullet-heaven roguelite (Vampire Survivors–like) |
| **Perspective** | Top-down 2D, pixel art |
| **Engine** | Godot 4.x |
| **Target** | PC first (Steam), gamepad + keyboard/mouse |
| **Session length** | 15–20 min per run |
| **Status** | Concept — not yet in production |
| **Date** | 26 Nov 2026 |

---

## Table of contents

1. [The pitch](#1-the-pitch)
2. [Design pillars](#2-design-pillars)
3. [The twist, in one paragraph](#3-the-twist-in-one-paragraph)
4. [Core loop and run structure](#4-core-loop-and-run-structure)
5. [Controls and game feel](#5-controls-and-game-feel)
6. [Playable characters](#6-playable-characters)
7. [Weapons — launch roster (18)](#7-weapons--launch-roster-18)
8. [Weapons — stretch roster (12)](#8-weapons--stretch-roster-12)
9. [Evolutions](#9-evolutions)
10. [Active relics (anting-anting)](#10-active-relics-anting-anting)
11. [Passive items](#11-passive-items)
12. [Consumables and pickups](#12-consumables-and-pickups)
13. [Enemies — the urban legend roster](#13-enemies--the-urban-legend-roster)
14. [Bosses](#14-bosses)
15. [Stages and biomes](#15-stages-and-biomes)
16. [Signature systems (the good stuff)](#16-signature-systems-the-good-stuff)
17. [Meta progression — Bahay ni Lola](#17-meta-progression--bahay-ni-lola)
18. [UI / HUD](#18-ui--hud)
19. [Art direction and pixel spec](#19-art-direction-and-pixel-spec)
20. [Audio direction](#20-audio-direction)
21. [Technical notes (Godot 4)](#21-technical-notes-godot-4)
22. [Sample 10-minute run](#22-sample-10-minute-run)
23. [Scope and milestones](#23-scope-and-milestones)
24. [Risks and open questions](#24-risks-and-open-questions)
25. [Cultural notes and sources](#25-cultural-notes-and-sources)
26. [Glossary](#26-glossary)

---

## 1. The pitch

**Vampire Survivors, but the horde is every monster your lola warned you about.**

You are a barangay watchman, an albularyo, an arnisador — an ordinary Filipino on the worst night of the year. The balete tree at the edge of town has opened, and the gubat is emptying out. Aswang, manananggal, tiyanak, kapre, tikbalang, the White Lady from the old school, all of them. You have a bolo, a bag of salt, and until sunrise.

Survive 18 minutes of escalating folk-horror swarms. Level up, stack absurd Filipino weapons, evolve them into legendary versions, and hold out until the rooster crows. At dawn, the sun itself becomes your best weapon.

**Hook line:** *"The jungle is loud tonight. Every sound is something that wants to eat you."*

---

## 2. Design pillars

| Pillar | What it means in practice |
|---|---|
| **1. Folk horror, not costume horror** | Every enemy is a real creature from Philippine folklore with its actual reported behavior (the manananggal's detachable torso, the tikbalang leading travelers in circles, the batibat sitting on your chest). The joke is never "haha Philippines"; the horror is played straight. |
| **2. Sound is the map** | You can't see offscreen. Audio tells you what's coming and from where. The tiktik's call is louder when it's *farther* — a deliberate folklore detail turned into a mechanic. |
| **3. Escalation to a sunrise** | Runs end at dawn, not at a timer. The last 60 seconds are a cathartic power flip where the sun burns the horde and you finally get to be the scary thing. |
| **4. Respect is a mechanic** | "Tabi-tabi po" is a real courtesy. In-game, disturbing a nuno sa punso without asking spawns punishment; asking gives a blessing. Culture becomes gameplay, not decoration. |
| **5. Absurd builds, straight face** | Tsinelas boomerang. Garlic aura. A carabao summon. A yo-yo that was historically a weapon. Everything is played deadpan, which is funnier than winking. |

---

## 3. The twist, in one paragraph

Vampire Survivors' fantasy is "become a god of destruction." Ours is **"survive the folklore until the sun saves you."** Three things change the formula:

1. **The horde is culturally specific.** Not skeletons and bats — a manananggal whose lower half you must find and salt, a kapre who drops logs from offscreen, a bungisngis whose laugh is a telegraphed shockwave.
2. **Information is scarce and audio-driven.** Darkness + a lantern cone + directional sound cues. The game rewards listening, not just kiting.
3. **The run has a moral texture.** Salt, garlic, and courtesy are resources. You can be efficient or you can be respectful, and the game notices.

---

## 4. Core loop and run structure

### 4.1 The loop

```
Pick character + stage
      ↓
Spawn in the gubat at dusk
      ↓
Move → auto-attack → kill → collect Alab (XP)
      ↓
Level up → choose 1 of 3–4 cards (new weapon / upgrade / passive)
      ↓
Every ~3 min: new enemy tier + elite
      ↓
6 min: mini-boss → 10 min: swarm event → 14 min: boss
      ↓
18 min: BUKANG-LIWAYWAY (dawn) → sun damages everything
      ↓
Win screen → Barya + Alay → spend at Bahay ni Lola
```

### 4.2 The five acts of the night

| Time | Act | What happens |
|---|---|---|
| 0:00–3:00 | **Takipsilim** (dusk) | Tier-1 trash only. Tutorial-by-pressure. One weapon, one passive. |
| 3:00–6:00 | **Gabi** (night) | Tier-2 mix, first elite, first nuno mound. Lantern light shrinks slightly. |
| 6:00–10:00 | **Hatinggabi** (midnight) | Mini-boss. Aswang-in-disguise event. Screen gets darker and audio denser. |
| 10:00–14:00 | **Madaling-araw** (small hours) | Swarm wall, 2 elites at once, curse (Kulam) pressure peaks. |
| 14:00–18:00 | **Bukang-liwayway** (dawn) | Final boss. At 17:00 the sky turns orange, the rooster crows, and sunlight starts ticking damage on all aswang-type enemies. |

> **Design note:** the dawn flip is the emotional payoff. Players should feel the last 60 seconds as a *release valve*, not another spike. Boss still hits hard; you just finally hit harder.

### 4.3 Failure and retry

- Death is instant, no lives. Run summary shows: time survived, kills by type, weapons taken, damage dealt, "most hated enemy."
- Retry is one button, same seed option available.
- No mid-run saves in v1. (Stretch: suspend/resume.)

---

## 5. Controls and game feel

| Input | Action |
|---|---|
| WASD / Left stick | Move (8-directional, analog on stick) |
| Auto | Weapons fire automatically; no attack button |
| Space / A | **Lundag** (dash) — 0.15 s i-frames, 2.5 s cooldown, leaves a small dust puff |
| Q / LB | Active anting-anting (relic) |
| E / RB | Interact — "Tabi-tabi po" at mounds, open sari-sari crate, light altar |
| Tab / Back | Pause + build summary |
| F / Y | Toggle "sound compass" accessibility overlay |

**Feel targets**
- Base move speed 110 px/s, dash 420 px/s for 0.12 s.
- Hitstop: 2 frames on melee connect, 1 frame on ranged. Screen shake 1–3 px, scaled by damage.
- Damage numbers pooled, max 40 on screen, oldest recycled.
- Enemies flash white 1 frame on hit; death = 3-frame squash + 6-particle burst.
- Pickups magnetize at 60 px radius, accelerate toward player, never overshoot.

**Camera:** follows player with 0.08 s smoothing, 8 px deadzone, slight look-ahead in movement direction. Never rotates. Zoom is fixed per stage (1.0 base, 1.15 in palengke corridors).

---

## 6. Playable characters

Each character = starting weapon + unique passive + one stat quirk. Unlock conditions in parentheses.

| # | Character | Role | Starting weapon | Unique passive | Unlock |
|---|---|---|---|---|---|
| 1 | **Isko** — Barangay Tanod | Balanced starter | Itak | *Night Shift:* +8% move speed after 6:00 | Default |
| 2 | **Lola Bining** — Albularyo | Sustain / anti-aswang | Bawang (garlic aura) | *Hilot:* all healing +25% | Default |
| 3 | **Mang Doring** — Arnisador | Melee DPS | Yantok (dual sticks) | *Redoble:* +10% attack speed, +5% per 3 levels | Default |
| 4 | **Aling Rosa** — Tindera | Economy / utility | Tsinelas | *Bayong:* +50% pickup radius, +10% Barya | Default |
| 5 | **Tasyo** — Mangangaso | Ranged / DoT | Sumpit | *Lason:* poison stacks +1 and last 2 s longer | 300 kills with poison |
| 6 | **Bai** — Babaylan | AoE / cooldowns | Kulintang | *Anito:* −12% cooldowns, relic charges +1 | Clear stage 2 |
| 7 | **Nene** — Sacristan | Holy / risk-reward | Krus (orbiting rosary) | *Panata:* +20% damage vs undead, −10% max HP | Clear stage 4 |
| 8 | **Kardo** — Magsasaka | Tank / summon | Kalabaw | *Buhay sa Bukid:* +20% max HP, +1 HP/s out of combat | Clear stage 3 |
| 9 | **Maria Makiling** — Diwata | Nature / control | Sampaguita vines | *Sanggalang:* thorns reflect 15% melee damage | Secret — 3 offerings at the balete altar |
| 10 | **"Ang Tumalikod"** — Reformed Aswang | Lifesteal / fragile | Pangil (claw) | *Sumpa:* 3% lifesteal, but villagers (NPC events) flee | Secret — survive 18:00 as any character |

> **Design note:** characters should not be "same kit, different numbers." Each starting weapon implies a different first 5 minutes. The Tanod kites; the Arnisador walks into the horde; the Tindera spends the early game rich and weak.

---

## 7. Weapons — launch roster (18)

**Archetypes:** Arc (swing), Stab (short thrust), Line (piercing path), Projectile (travels), Bounce (ricochet), Lob (arcs to a point), Aura (persistent circle), Pulse (expanding ring), Orbit (circles the player), Trail (leaves hazards), Summon (AI ally), Mark (debuff application), Push (knockback / reflect).

| # | Weapon | Archetype | Behavior | Evolution (needs) |
|---|---|---|---|---|
| 1 | **Itak** (bolo) | Arc | Wide slash in facing direction. 3-hit combo; 3rd hit is 180°. | **Itak ng Tagapagbantay** + Salakot — every 3rd swing becomes a full 360° spin with +50% range |
| 2 | **Balisong** (butterfly knife) | Stab | Rapid triple thrust, very short range, high crit. | **Balisong na Bibang Dalawa** + Singsing — throws a fan of 7 knives that bleed |
| 3 | **Yantok** (arnis sticks) | Arc/Combo | Alternating left/right strikes, small stun on hit. | **Sinawali** + Bakya — weaving pattern hits everything in a 90 px radius at 2× rate |
| 4 | **Sumpit** (blowgun) | Line | Piercing dart, low damage, applies poison DoT. Quiet — doesn't aggro. | **Sumpit ng Gubat** + Lason — leaves a poison cloud at the end of the line |
| 5 | **Pana** (bow) | Projectile | Spread of 2 arrows, slight arc, pierces 1 enemy. | **Pana ng Diwata** + Kawayan — homing arrows, pierce 3, +1 projectile |
| 6 | **Tirador** (slingshot) | Bounce | Pellet bounces 3× off enemies. | **Tirador ng Kalye** + Tansan — 8 bounces, +15% crit, bounces off walls too |
| 7 | **Banga** (clay jar) | Lob | Tossed pot shatters for AoE + shrapnel. | **Banga ng Albularyo** + Asin — leaves a holy-water pool that damages aswang |
| 8 | **Kaldero** (pot) | Bounce/Trail | Heavy pot rolls, bounces off walls, burns on contact. | **Kalderong Kumukulo** + Kandila — rolling lava pot, leaves a fire trail |
| 9 | **Sulo** (torch) | Trail | Leaves a short fire trail behind you. | **Santelmo** + Kandila — orbiting fireball that seeks the nearest enemy |
| 10 | **Bawang** (garlic) | Aura | Damages and lightly repels aswang-type enemies in a circle. | **Bawang at Asin** + Asin — expanding salt ring that slows and purges Kulam |
| 11 | **Kulintang** (gongs) | Pulse | Rhythmic expanding rings; enemies hit on the beat are stunned 0.3 s. | **Kulintang ng Diwata** + Tambuli — overlapping rings, charmed enemies fight for you for 2 s |
| 12 | **Buntot Pagi** (stingray tail) | Arc/Whip | Long thin arc, strong knockback, +30% vs aswang. | **Buntot ng Bagyo** + Pamaypay — whip crack chains lightning to 3 nearby enemies |
| 13 | **Sibat** (spear) | Line/Dash | Thrust pierces a line; small forward step. | **Sibat ng Kidlat** + Agimat — calls a lightning spear from the sky on the furthest enemy |
| 14 | **Lantaka** (bamboo cannon) | Lob/Artillery | Slow, heavy shell, big AoE, long cooldown. | **Lantaka ng Moog** + Puno ng Balete — cluster shells, 3 explosions |
| 15 | **Yoyo** | Orbit/Return | Loops out and back, hits on both passes. | **Yoyo ng Bayan** + Panyo — two yoyos orbit and pull enemies inward |
| 16 | **Kulam** (curse doll) | Mark | Marks an enemy; all damage you deal to it echoes 20% to the nearest enemy. | **Kulam ng Mangkukulam** + Anting-anting — curse spreads to 3 enemies, +50% echo |
| 17 | **Kalabaw** (carabao) | Summon | Carabao charges across the screen, trampling a line. | **Kalabaw ng Bukid** + Bagoong — two carabaos, wider trample, 1 s stun |
| 18 | **Tsinelas** (slipper) | Boomerang | Thrown slipper returns; huge knockback, low damage, comedic. | **Tsinelas ni Inay** + Tsinelas — three homing slippers, stun on hit |

### 7.1 Why these 18

- **Archetype coverage:** 3 arc, 2 line, 2 projectile, 2 bounce, 2 lob, 1 aura, 1 pulse, 1 orbit, 1 trail, 1 summon, 1 mark, 1 boomerang. No two weapons share a feel.
- **Range spread:** 24 px (Balisong) → 400 px (Lantaka). Forces different kiting distances.
- **Cultural spread:** blade, blunt, projectile, folk magic, food/kitchen, farm, festival. The kit reads as "a Filipino household emptied onto a monster."

---

## 8. Weapons — stretch roster (12)

Cut these if scope tightens. They're designed, not required.

| # | Weapon | Archetype | Behavior | Evolution |
|---|---|---|---|---|
| 19 | **Kampilan** (great sword) | Arc/Heavy | Slow 220° cleave, armor break (−20% enemy armor 3 s). | **Kampilan ng Datu** + Malong — cleave sends a shockwave |
| 20 | **Kris** (wavy blade) | Stab/Bleed | Applies bleed stacks; damage scales with stacks. | **Kris ng Bulkan** + Lambanog — bleed explodes at 5 stacks |
| 21 | **Panabas** (chopper) | Arc/Execute | +100% damage to enemies below 30% HP. | **Panabas ng Berdugo** + Agimat — executed enemies explode for 20% max HP |
| 22 | **Walis Tingting** (broom) | Sweep | 180° sweep, destroys enemy projectiles. | **Walis ng Babaylan** + Bayong — whirlwind that vacuums projectiles into a damaging vortex |
| 23 | **Pamaypay** (fan) | Push | Gust cone pushes enemies and reflects projectiles. | **Pamaypay ng Hangin** + Panyo — tornado that wanders and lifts small enemies |
| 24 | **Parol** (lantern) | Burst/Light | Flash blinds and stuns in a radius; reveals hidden enemies. | **Parol ng Pasko** + Kandila — chain-light between three parols |
| 25 | **Agung** (gong) | Pulse | Heavy shockwave, big knockback, slow. | **Agung ng Bundok** + Puno ng Balete — screen-wide quake, cracks the ground |
| 26 | **Tambuli** (horn) | Buff aura | +15% attack speed to you inside the radius. | **Tambuli ng Kalabaw** + Bagoong — war horn: buff doubles, enemies flee 1 s |
| 27 | **Sabong** (rooster) | Summon | Rooster pecks nearby enemies; crows at dawn. | **Tari** + Singsing — bladed rooster; its crow stuns the screen |
| 28 | **Salakot** (hat) | Orbit | Hat spins out and returns like a disc. | **Salakot ng Bulkan** + Bakya — orbiting shield ring, reflects projectiles |
| 29 | **Sandok** (ladle) | Arc/Pull | Scoops small enemies toward you. | **Sandok ng Kusinera** + Kaldero — giant ladle slam, AoE + pull |
| 30 | **Kubing** (jaw harp) | Sonic | Cone sound wave, brief confuse (enemies walk wrong way). | **Kubing ng Diwata** + Kulintang — resonance rings stun in a wide area |

**Backlog ideas (not specced):** *Tabo* (dipper splash), *Payong* (umbrella shield), *Panyo* (blindfold), *Bakyâ* (clog stomp), *Sungka* (shell scatter), *Tumbang Preso* (can knockdown), *Luksong Baka* (leap slam), *Piko* (hopscotch minefield).

---

## 9. Evolutions

Rules (VS-style, tuned for our pacing):

- A weapon evolves when it is **max level (8)** and you hold the **required passive at level 1+**.
- Evolution happens on the next level-up; the card appears guaranteed in the choice.
- Evolved weapons free their weapon slot? **No** — they keep it, but the slot's level is "MAX" and no longer offers upgrades.
- One evolution per weapon. No branching in v1.
- **Visual rule:** every evolution changes silhouette, color, and trail VFX. The player must feel the upgrade in 1 frame.

**Evolution flavor pass (examples):**

| Base | + Passive | Evolved | The fantasy |
|---|---|---|---|
| Itak | Salakot | Itak ng Tagapagbantay | You stop running. You become the checkpoint. |
| Bawang | Asin | Bawang at Asin | The oldest anti-aswang recipe, weaponized. |
| Kulintang | Tambuli | Kulintang ng Diwata | The ensemble becomes a summoning. |
| Tsinelas | Tsinelas | Tsinelas ni Inay | The joke escalates into a screen-clearing tantrum. |
| Kalabaw | Bagoong | Kalabaw ng Bukid | The farm arrives. |

---

## 10. Active relics (anting-anting)

One slot, one charge, long cooldown. Dropped by elites, bought at altars, or found in sari-sari crates. This is the "panic button" layer VS doesn't have.

| Relic | Effect | Charges | Cooldown |
|---|---|---|---|
| **Anting-anting ng Bakal** | 3 s invulnerability, thorns 50% | 1 | 45 s |
| **Agimat ng Diwata** | Heal 40% max HP, cleanse Kulam | 1 | 60 s |
| **Banal na Tubig** | Holy nova: 300% damage to undead/aswang, purges nearby | 2 | 25 s |
| **Kandila ng Patay** | Reveal all hidden enemies + slow them 50% for 4 s | 2 | 30 s |
| **Salakot ng Hangin** | Reflect all projectiles for 2 s | 1 | 35 s |
| **Panyo ng Multo** | Teleport 200 px in facing direction, leave a decoy | 1 | 20 s |
| **Barya ni Judas**? | *(cut — religious sensitivity)* | — | — |

> Keep relics folk-magical, not liturgical. Holy water and rosaries are fine as protective folk practice; avoid sacrament parody.

---

## 11. Passive items

Each passive is a Filipino object with a folk use. 5 levels each.

| Passive | Effect per level | Max |
|---|---|---|
| **Anting-anting** | +1 random minor blessing (luck) | 5 |
| **Agimat** | +8% max HP | 5 |
| **Bakya** (clogs) | +6% move speed, +10% knockback resist | 5 |
| **Salakot** (hat) | +1 flat armor | 5 |
| **Malong** (cloth) | +8% area of effect | 5 |
| **Bayong** (bag) | +25% pickup radius | 5 |
| **Pamaypay** (fan) | +6% cooldown reduction | 5 |
| **Kandila** (candle) | +10% duration, +8% light radius | 5 |
| **Kwintas ng Bawang** | +10% damage vs aswang | 5 |
| **Singsing** (ring) | +8% crit chance | 5 |
| **Kawayan** (bamboo) | +1 projectile (weapons that fire projectiles) | 3 |
| **Kapeng Barako** | +10% attack speed; immune to Batibat sleep | 5 |
| **Lambanog** | +15% damage, −5% max HP | 5 |
| **Bagoong** | Stink aura: 20 dps in 48 px (comedic, real) | 5 |
| **Asin** (salt) | +10% damage to undead; +1 s purge duration | 5 |
| **Panyo** (handkerchief) | +5% dodge | 5 |
| **Tabo** (dipper) | +0.5 HP/s regen | 5 |
| **Tansan** (bottle cap) | +15% Barya | 5 |
| **Rosaryo** | Revive once at 30% HP (one total, not per level) | 1 |
| **Puno ng Balete** | +20% luck, +25% elite spawn rate | 3 |

**Cap:** 6 weapon slots + 6 passive slots. Level-up cards offer 3 (4 with luck procs).

---

## 12. Consumables and pickups

| Item | Type | Effect |
|---|---|---|
| **Alab** (ember) | XP | Blue ember; 1/5/25 XP tiers |
| **Barya** (coin) | Currency | Run currency → meta currency at 1:1 |
| **Alay** (offering) | Meta | Rare drop; unlocks characters/relics |
| **Kandila** (candle) | Heal | Restores 20% HP |
| **Adobo** | Buff | +20% damage for 30 s |
| **Sinigang** | Buff | +15% armor for 30 s |
| **Balut** | Rare | Full heal + 1 s invuln |
| **Taho** | Buff | +20% speed, +1 HP/s for 20 s |
| **Halo-halo** | Chaos | Two random buffs, one random debuff |
| **Buko juice** | Cleanse | Removes all Kulam stacks |
| **Lambanog** | Risk | +40% damage, −25% armor for 20 s |
| **Suman** | Heal | 10% HP, +5% XP for the run |
| **Bawang** | Utility | Burst: repels aswang in 120 px |
| **Asin** | Utility | Drops a 3 s salt circle; aswang cannot enter |

---

## 13. Enemies — the urban legend roster

**Design rule:** every enemy has one readable behavior the player can learn in 2 seconds. Folk accuracy is the flavor; clarity is the job.

### 13.1 Tier 1 — Takipsilim fodder (0–3 min)

| Enemy | Role | Behavior | Counter |
|---|---|---|---|
| **Tiktik** | Scout | Fast, low HP, circles you. Its chirp is **louder when farther** (folklore-accurate). | Ignore the sound, watch the screen edge |
| **Kikik** | Mimic | Spawns in pairs; mimics the tiktik sound from the *wrong* direction | Trust your eyes at close range |
| **Dwende** | Swarmer | Small, fast, steals 1 Barya on contact and flees | Kill before it reaches you |
| **Balbal** | Slow tank | Walks straight, ignores knockback, licks corpses | Kite; never stand still |
| **Busaw** | Thief | Targets pickups, not you; steals Alab and runs | Chase or let it go |
| **Santelmo** | Floating hazard | Drifts toward you, leaves a 1 s fire patch on death | Kill at range, don't pop it on yourself |

### 13.2 Tier 2 — Gabi (3–6 min)

| Enemy | Role | Behavior | Counter |
|---|---|---|---|
| **Tiyanak** | Ambusher | Sits as a crying baby; if you get within 40 px it leaps and shreds | Kill from range; the crying is a lure |
| **Pugot** | Charger | Headless, charges in a straight line, slams into walls | Sidestep, let it stun itself |
| **White Lady** | Phaser | Visible only when your lantern flickers (every 4 s); ignores collision | Keep moving; light reveals her |
| **Nuno sa Punso** | Turret | Stationary on an anthill, throws pebbles. **Invulnerable until you "Tabi-tabi po"** | Interact to make it dormant or anger it for a reward |
| **Ekek** | Dive bomber | Hovers, then dives in a telegraphed line | Dodge on the wing-flap audio cue |
| **Alan** | Grabber | Drops from the canopy, grabs and drags you 100 px | Watch the shadow; dash out |

### 13.3 Tier 3 — Hatinggabi (6–10 min)

| Enemy | Role | Behavior | Counter |
|---|---|---|---|
| **Aswang** | Elite bruiser | Disguised as a villager for 3 s, then transforms; heals from corpses | Burn it before it eats; salt blocks healing |
| **Manananggal** | Split elite | Torso flies and dive-bombs; **lower half stays on the ground and must be destroyed** | Find and salt the lower half |
| **Mangkukulam** | Caster | Stays at range, applies Kulam stacks, summons dolls | Dive her first; dolls die in 1 hit |
| **Batibat** | Controller | Sits on you: screen darkens, movement slows 60%, must mash to wake | Kapeng Barako = immunity; otherwise dash out |
| **Tikbalang** | Disruptor | Gallops, then **inverts your controls for 1.5 s** | Memorize the neigh cue; stop moving |
| **Bungisngis** | Elite | One-eyed giant; laugh = 120 px shockwave, eye beam = line attack | Hug its blind side |
| **Berberoka** | Zoner | Drains a water area, then floods it for heavy damage | Leave the drained zone |

### 13.4 Tier 4 — Madaling-araw (10–14 min)

| Enemy | Role | Behavior |
|---|---|---|
| **Amomongo** | Leaper | Long pounce, bleeds on hit, retreats to range |
| **Siyokoy** | Grabber (water stages) | Drags you underwater; 3 s to mash free |
| **Magindara** | Charmer | Song cone: enemies in it turn and walk toward her (and so do you, briefly) |
| **Anggitay** | Cavalry | Rides in circles firing arrows; dismounts at 50% HP |
| **Kumakatok** | Trio | Three hooded figures knock; if all three reach you, −50% max HP for 10 s |
| **Bulalakaw** | Meteor | Telegraphed falling star, 80 px AoE, leaves fire |
| **Kapre** | Mini-boss | Throws logs from offscreen, smoke cloud blocks vision |

### 13.5 Enemy behavior cheat sheet

| Behavior tag | Implementation note |
|---|---|
| `chase` | Direct steering, separation from neighbors |
| `orbit` | Maintain 80–140 px ring |
| `charge` | Wind-up 0.6 s → straight dash → 0.8 s stun on wall hit |
| `dive` | Hover → telegraph line → dash → return |
| `turret` | Stationary, periodic projectile |
| `caster` | Keep 200 px, cast on cooldown, flee if player < 80 px |
| `thief` | Target nearest pickup, flee on pickup |
| `phaser` | Alpha 0 except during lantern flicker |
| `split` | Spawn a second body on death or at HP threshold |
| `disguise` | Render as villager sprite, swap on timer or damage |

---

## 14. Bosses

| Boss | Stage | Gimmick | Phases | Reward |
|---|---|---|---|---|
| **Kapre** | 1 — Balete Forest | Log throws, smoke screen, stomps that shake the screen | 2 | Relic drop + 1 evolution card |
| **Manananggal Matriarch** | 2 — Rice Paddies | Flying torso + 3 grounded lower halves; only one is real | 3 | Unlock Bai |
| **Berberoka** | 3 — Mangrove | Arena floods and drains; platforms of roots | 2 | Unlock Kardo |
| **Pugot na Pari** | 4 — Cemetery/Church | Headless teleport-charge; holy ground burns you | 3 | Unlock Nene |
| **Amomongo** | 5 — Night Market | Leap chains across stalls; throws produce (yes) | 2 | Tsinelas evolution unlock |
| **Bernardo Carpio** | 6 — Volcano | Earthquake slams; rocks fall; "trapped between mountains" arena shrink | 3 | Secret character |
| **Bakunawa** | 7 — Under the Moon | Eats the moon → total darkness; you fight by lantern and sound only | 4 | True ending |
| **Maria Makiling** *(optional)* | Any — Balete altar | Not evil; a test. She fights to see if you respect the forest | 1 | Diwata character + best relic |

**Boss design rules**
- Every boss has **one attack that can only be solved by sound** (fits Pillar 2).
- Bosses never spawn with trash on top of them; trash pauses 2 s at boss intro.
- Boss HP bar is diegetic: a bamboo frame at the top, not a generic bar.
- No boss one-shots from full HP. Max single hit = 60% HP, telegraphed 0.8 s.

---

## 15. Stages and biomes

| # | Stage | Biome | Visual identity | Hazard | Signature enemies | Boss |
|---|---|---|---|---|---|---|
| 1 | **Gubat ng Balete** | Rainforest | Deep indigo + moss, giant balete roots, fireflies | Falling branches | Tiktik, Dwende, Balbal | Kapre |
| 2 | **Palayan sa Gabi** | Rice terraces | Moonlit water mirrors, bamboo fences, carabao silhouettes | Mud slows 30% | Tiyanak, Ekek, Alan | Manananggal |
| 3 | **Bakawan** | Mangrove swamp | Teal + rust, stilt roots, fog | Water: 20% slow, siyokoy grabs | Siyokoy, Berberoka spawns | Berberoka |
| 4 | **Sementeryo at Simbahan** | Cemetery + ruined church | Grey stone, candle glow, broken santos statues | Holy ground burns aswang (and you, if cursed) | White Lady, Pugot, Kumakatok | Pugot na Pari |
| 5 | **Palengke sa Gabi** | Night market | Warm tungsten, tarpaulin stalls, hanging bulbs | Tight corridors, collapsing stalls | Busaw, Mangkukulam, Amomongo | Amomongo |
| 6 | **Bulkang Makiling** | Volcano slope | Ash grey + ember orange, steam vents | Lava pools, ash reduces light | Bulalakaw, Aswang, Anggitay | Bernardo Carpio |
| 7 | **Ilalim ng Buwan** | Dream / sky | Black + silver, floating islands, no ground | Moonlight is the only light; moon can be eaten | Everything, buffed | Bakunawa |

**Stage modifiers (unlock after first clear):**
- **Bagyo** (storm): rain, reduced visibility, lightning strikes.
- **Walang Buwan** (moonless): no ambient light at all; lantern only.
- **Banal na Araw** (Holy Week): aswang +50% damage, but salt and holy items +50% too.
- **Gabi ng Puno** (tree night): balete roots move, map layout shifts.

---

## 16. Signature systems (the good stuff)

### 16.1 Sound compass (Pillar 2)

- Offscreen enemies emit directional audio. The mix is binaural-ish (pan + lowpass by distance).
- **Tiktik rule:** the call is *inversely* attenuated — louder = farther. This is folklore-accurate and creates delicious paranoia.
- HUD option: a subtle edge indicator (toggleable, accessibility).
- Elites get unique stings so players learn "that sound = that problem."

### 16.2 Tabi-tabi po (Pillar 4)

- Nuno mounds spawn on every map. Walking within 24 px without interacting **angers** the nuno: it becomes a turret and curses you with 1 Kulam stack.
- Pressing **E** performs the courtesy: the mound goes dormant and grants a small blessing (+5% damage for 60 s, or a Barya).
- Interacting 3× at the balete altar summons **Maria Makiling**.
- Design intent: a tiny, learnable etiquette that makes the world feel inhabited.

### 16.3 Kulam (curse meter)

- Certain enemies apply stacks (max 5).
- At 3 stacks: −10% damage. At 5: random debuff (blind, slow, invert, silence).
- Cleansed by Buko juice, altars, Agimat relic, or completing a "respect" interaction.
- Visual: black veins creeping up the HP bar. Audio: a low drone that intensifies.

### 16.4 Aswang in disguise

- At 6:00 and 12:00, a "villager" NPC walks into the arena, waves, and stands still.
- After 4 s (or if damaged), it transforms into an Aswang elite.
- Killing it before transformation grants a bonus relic.
- This is the game's best "oh no" moment and should be in the trailer.

### 16.5 Dawn flip

- At 17:00 the sky lerps to orange over 4 s. Rooster crow SFX. 
- All `aswang`-tagged enemies take 2% max HP/s and lose 20% damage.
- The player gains +25% damage. Music switches from kulintang dread to full rondalla triumph.
- Boss still must be killed; dawn is a buff, not a win button.

### 16.6 Weather / time-of-night light

- Lantern cone: 140° arc, 160 px, flickers every 4 s (White Lady reveal window).
- Ambient light drops per act; by Madaling-araw the screen is 70% black outside the cone.
- Light is a resource: Kandila passives and Parol weapons literally expand what you can see.

---

## 17. Meta progression — Bahay ni Lola

A hut hub between runs. Four interactables:

| Station | Function |
|---|---|
| **Sari-sari store** | Spend **Barya** on permanent stat nodes (a small tree, 40 nodes max) |
| **Altar** | Spend **Alay** to unlock characters, relics, and stage modifiers |
| **Wall of anting-anting** | Equip up to 2 starting relics for the next run |
| **Radio** | Daily challenge (fixed seed), leaderboard, "Walang Hanggang Gabi" endless mode |

**Permanent node examples**
- +2% move speed (5 ranks)
- +1 starting reroll (3 ranks)
- Start with 1 extra passive slot (1 rank, expensive)
- +10% Alab pickup range
- +1 relic charge
- Unlock weapon in starting pool

**Anti-grind rule:** total meta power capped at ~15% stat advantage. Skill and build should dominate.

---

## 18. UI / HUD

```
┌──────────────────────────────────────────────────────────────┐
│ [HP: bamboo segments]        🌙 06:42        [Kulam: ●●●○○]  │
│ [XP: lantern glow bar]                                       │
│                                                              │
│                     (play area)                              │
│                                                              │
│ [weapon icons ×6]                          [passives ×6]     │
│ [relic: Q]                                                   │
└──────────────────────────────────────────────────────────────┘
```

- **HP:** bamboo frame with segments, not a flat bar.
- **XP:** a lantern that fills with light; level-up = the lantern flares.
- **Timer:** moon-phase icon that fills toward sunrise.
- **Level-up screen:** 3 cards fanned like tarot, drawn on a banig (woven mat) background. Reroll = "Bawi" button.
- **Damage numbers:** off-white, crits in amber with a small "anito" glyph.
- **Pause/build screen:** a page of a handwritten *lampara* notebook.

Accessibility: colorblind-safe enemy tells, damage-number size option, screen-shake slider, "sound compass" overlay, full remap, pause-on-focus-loss.

---

## 19. Art direction and pixel spec

### 19.1 Technical spec

| Item | Spec |
|---|---|
| Internal resolution | **640 × 360** (16:9), integer-scaled to 1920×1080 (3×) |
| Tile size | 16 × 16 px |
| Player sprite | 24 × 24 px (hitbox 10 × 12) |
| Trash enemy | 16 × 16 to 24 × 24 |
| Elite | 32 × 32 |
| Boss | 64 × 64 to 96 × 96 |
| Animation | 6–8 fps for locomotion, 10–12 fps for attacks |
| Palette | 32 colors per biome + 8 shared UI colors |
| Rendering | Nearest-neighbor, no filtering, pixel-snapped camera |
| Particles | 8 × 8 max, dithered, no soft alpha |

### 19.2 Core palette ("Gabi")

| Role | Hex |
|---|---|
| Night indigo | `#141626` |
| Deep jungle | `#1E3328` |
| Moss | `#2F4F3F` |
| Bamboo / bone | `#C8B273` |
| Lantern amber | `#FFB347` |
| Moonlight cyan | `#9FD8E8` |
| Blood / aswang red | `#8B1E1E` |
| Holy gold | `#F2D06B` |
| Kulam purple | `#5B2A6E` |

### 19.3 Visual rules

1. **Warm vs cold:** the player's lantern is the only warm light. Everything hostile is cold or sickly. The dawn sequence is the one time the whole screen goes warm.
2. **Silhouette first:** every enemy must be identifiable as a 1-color silhouette at 16 px.
3. **Dither, don't blur:** gradients via ordered dithering, never soft brushes.
4. **Readable telegraphs:** 2-frame wind-up flash on every attack, in a color no other system uses (white).
5. **Death juice:** squash 3 frames, 6 particles, 1-frame white flash, small screen shake.
6. **No gore beyond pixel restraint:** blood is 3–4 dark red pixels, not splatter. Keep it spooky, not gross.

### 19.4 Animation set per enemy

`idle (4f) → walk (6f) → attack_windup (2f) → attack (3f) → hurt (1f) → death (4f)`

Bosses add: `phase_transition (8f)`, `roar (6f)`.

---

## 20. Audio direction

**Music:** kulintang ensemble (melodic gongs) + agung (low gong) + gangsa + bamboo percussion, layered with a low drone and occasional bandurria/laud for rondalla warmth at dawn.

| Act | Music |
|---|---|
| Takipsilim | Sparse kulintang, cicadas, distant dogs |
| Gabi | Add agung pulse, low strings |
| Hatinggabi | Dissonant kulintang, breath sounds, heartbeat |
| Madaling-araw | Fast tongatong rhythm, rising drone |
| Bukang-liwayway | Full rondalla, major key, rooster |

**SFX priorities**
1. **Enemy identity stings** — each elite gets a unique 0.5 s motif.
2. **Tiktik / kikik / wakwak calls** — the core tension tool.
3. **Weapon signatures** — itak *shing*, yantok *thwack*, sumpit *ptew*, kulintang *tling*.
4. **UI** — bamboo clicks, not synth beeps.

**Ambience:** kuliglig (crickets), frogs, wind through bamboo, distant church bells at act transitions, a rooster at 17:00.

---

## 21. Technical notes (Godot 4)

### 21.1 Project structure

```
res://
├── autoload/
│   ├── game_state.gd        # run state, seed, save
│   ├── audio.gd             # buses, music layers, ducking
│   ├── pool.gd              # projectile / damage-number / particle pools
│   └── events.gd            # global signal bus
├── data/
│   ├── weapons/*.tres       # WeaponData resources
│   ├── enemies/*.tres       # EnemyData
│   ├── evolutions/*.tres    # EvolutionRecipe
│   └── stages/*.tres        # StageData (waves, palette, hazards)
├── scenes/
│   ├── player/  enemy/  projectile/  pickup/  stage/  ui/
├── systems/
│   ├── spawner.gd           # wave director
│   ├── spatial_hash.gd      # enemy neighbor queries
│   ├── damage.gd            # damage pipeline + tags
│   └── sound_compass.gd
└── art/  audio/  shaders/
```

### 21.2 Performance targets

| Metric | Target |
|---|---|
| Enemies on screen | 800 (peak 1,200 with spawner throttle) |
| Frame budget | 16.6 ms @ 1080p on a GTX 1050 / integrated Iris Xe |
| Allocations per frame | ~0 (pooled) |
| Draw calls | < 40 (atlas + MultiMesh for particles) |

**Techniques**
- **Spatial hash grid** (cell 32 px) for enemy separation and hit queries. No `Area2D` per enemy.
- **MultiMeshInstance2D** or a single `RenderingServer` canvas batch for trash enemies and particles.
- **Object pooling** for projectiles, damage numbers, XP orbs, particles.
- **Data-driven weapons** — `WeaponData` resource holds cooldown, damage, projectile scene, evolution recipe. No per-weapon scripts unless behavior is unique.
- **Damage tags** (`aswang`, `undead`, `beast`, `spirit`) for conditional bonuses — one integer bitmask.
- **Deterministic RNG** seeded per run for daily mode and reproducible bug reports.
- Avoid `get_nodes_in_group()` in `_process`; cache references.
- Fixed timestep for gameplay logic (60 Hz) with interpolation for visuals if needed.

### 21.3 Save data

`user://save.json` — meta nodes, unlocks, best times, settings. Version field + migration stub from day one.

---

## 22. Sample 10-minute run

| Time | Beat |
|---|---|
| 0:00 | Isko spawns under the balete. Lantern cone. Cicadas. A tiktik chirps — *from behind*. |
| 0:40 | First level-up: Itak or Yantok or Bawang. Player picks Itak. |
| 1:30 | A dwende steals a coin and runs. Player learns pickups matter. |
| 2:20 | A nuno mound appears. Player walks over it. Pebbles. "Ano ba." Learns to press E. |
| 3:00 | Act 2. Tiyanak crying starts. Player kills it from range. |
| 4:10 | First elite: a Bungisngis. Laugh shockwave. Player dashes through the gap. |
| 5:00 | Evolution card offered early (Itak 8 + Salakot 1) — *Itak ng Tagapagbantay*. |
| 6:00 | Mini-boss: Kapre. Logs from offscreen. Smoke. Player fights by sound. |
| 7:30 | A villager walks in and waves. Player hesitates. It transforms. Aswang. |
| 8:00 | Kulam stacks at 3. Screen edges darken. Buko juice found. |
| 9:00 | Swarm wall. Kulintang + Sinawali. Screen is full of numbers. |
| 9:50 | Player at 12% HP, dashes into a Kandila. 22%. "Sige pa." |

---

## 23. Scope and milestones

### Phase 0 — Feel prototype (1–2 weeks)
- 1 character, 1 weapon (Itak), 1 enemy (Tiktik), flat arena.
- Movement, auto-attack, XP, level-up card, death.
- **Exit criteria:** is moving and killing fun for 3 minutes with placeholder art?

### Phase 1 — Vertical slice (4–6 weeks)
- 1 stage (Gubat ng Balete), 8 weapons, 10 enemies, 1 boss, 1 relic.
- Level-up, evolutions, dawn sequence, meta save, hub stub.
- Full pixel art pass on player + 5 enemies, 1 music track, core SFX.
- **Exit criteria:** a 15-minute run that a stranger can finish and want to replay.

### Phase 2 — Content (8–12 weeks)
- 3 stages, 18 weapons, 25 enemies, 5 bosses, 20 passives, 8 characters.
- Meta tree, stage modifiers, daily seed, settings, accessibility.
- **Exit criteria:** 8+ hours of progression, no run-breaking bugs.

### Phase 3 — Ship (4 weeks)
- 6–7 stages, 30 weapons, 30 enemies, 7 bosses, all evolutions.
- Trailer, store page, demo build, localization pass (EN/Tagalog).
- **Exit criteria:** stable 60 fps at peak, controller parity, verified save migration.

### Explicit cuts if time runs out
1. Stretch weapons 19–30 → post-launch.
2. Stages 6–7 → post-launch.
3. Endless mode → post-launch.
4. Co-op → never in v1 (survivors co-op is a netcode project, not a feature).

---

## 24. Risks and open questions

| Risk | Mitigation |
|---|---|
| **Cultural misstep** — folklore as punchline | Play horror straight; consult Filipino writers/artists; credit regional sources; avoid religious parody; "respect" is a mechanic, not a joke |
| **Scope** — 30 weapons is a lot of tuning | Data-driven weapons, 18 at launch, rest as stretch |
| **Audio-dependent design** — deaf/hard-of-hearing players | Sound compass overlay is a first-class accessibility feature, not a patch |
| **Genre saturation** — "another VS clone" | Lead with the folklore + sound + dawn hook in all marketing; the first 15 seconds of the trailer must show a manananggal splitting |
| **Performance** — 1,000 enemies in GDScript | Spatial hash + pooling + MultiMesh; profile from week 1, not month 3 |
| **Readability in darkness** | Lantern cone tuning; enemy edge-glow in silhouette; playtest at 640×360 first |
| **Cultural naming confusion** | Bilingual UI (Tagalog term + English subtitle in tooltips), glossary in-game |

### Open questions (decide before Phase 1)
1. **Title:** *Night of the Sigbin* (evocative, but sigbin is one creature) vs *Hatinggabi* (clean, one word) vs *Tabi-Tabi Po* (charming, harder to say). Recommendation: ship as *Night of the Sigbin*, keep *Hatinggabi* as subtitle.
2. **Sigbin's role:** mascot enemy, recurring stalker, or the final boss's herald? Recommendation: a recurring named stalker that appears at each act transition and can't be killed until the final stage.
3. **Tagalog voice lines or text only?** Text only at launch; voice is a stretch goal.
4. **Run length:** 18 min (recommended) vs 20 (more build time) vs 12 (snappier).
5. **Does the player ever get to play as a monster?** The Reformed Aswang unlock says yes — but keep it one character, not a mode.

---

## 25. Cultural notes and sources

This game draws on living folk belief, not a dead mythology. Regional variations are real: the manananggal is Visayan, the batibat is Ilocano, the nuno sa punso is Tagalog, the amomongo is from Negros, the bakunawa is a Visayan eclipse serpent. Pick one region's flavor per stage rather than blending everything into mush.

**Guidelines**
- Name the creature correctly; don't invent "generic Filipino demon" designs.
- Keep the horror respectful — these are stories grandparents told to keep kids home at night.
- The "Tabi-tabi po" mechanic should feel sincere, not ironic.
- Credit consultants in the game credits.
- Avoid mixing Catholic liturgy with folk magic in ways that read as mockery; folk practice (salt, garlic, holy water as protection) is fine.

**Starting references** *(verify before writing lore text — do not cite from memory)*
- [PLACEHOLDER] Academic folklore collection (e.g., a university press anthology of Philippine lower mythology)
- [PLACEHOLDER] Regional oral history source per creature
- [PLACEHOLDER] Consultant credit(s)
- [PLACEHOLDER] Public-domain art/photo references for costume and architecture

> Per project rules: no invented citations. Fill these in with real, checked sources before the lore bible is written.

---

## 26. Glossary

| Tagalog | English | In-game use |
|---|---|---|
| **Aswang** | shapeshifting ghoul/witch | Enemy tag; salt/garlic bonuses |
| **Manananggal** | self-severing flying torso | Split elite |
| **Tiyanak** | infant-shaped demon | Ambusher |
| **Tikbalang** | horse-headed trickster | Control inverter |
| **Kapre** | tree giant | Mini-boss |
| **Sigbin** | backwards-walking bloodsucker | Named stalker |
| **Dwende / Nuno sa punso** | dwarf / anthill spirit | Swarmer / turret |
| **Batibat** | sleep-paralysis hag | Controller |
| **Mangkukulam** | curse-worker | Caster |
| **Bakunawa** | moon-eating serpent | Final boss |
| **Albularyo** | folk healer | Character / shop |
| **Babaylan** | shaman (Visayan) | Character |
| **Anting-anting / Agimat** | amulet / charm | Relics |
| **Kulam** | curse | Curse meter |
| **Tabi-tabi po** | "excuse me, spirits" | Respect interaction |
| **Alab** | ember/flame | XP |
| **Barya** | coin/change | Run currency |
| **Alay** | offering | Meta currency |
| **Bukang-liwayway** | dawn | Win condition |
| **Hatinggabi** | midnight | Act 3 |
| **Gubat** | forest/jungle | Stage 1 |
| **Palengke** | market | Stage 5 |
| **Sari-sari store** | corner shop | Hub station |
| **Bahay kubo** | stilt hut | Hub building |

---

*End of document. Next step: prototype Phase 0 (movement + Itak + Tiktik) before writing any lore text.*
