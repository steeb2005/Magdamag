extends RefCounted
class_name Data

# ---------------------------------------------------------------------------
# Playable characters
# ---------------------------------------------------------------------------
const CHARACTERS := {
	"isko": {
		"name": "ISKO",
		"title": "Barangay Tanod",
		"weapon": "itak",
		"hp": 160.0,
		"speed": 95.0,
		"tex": "res://art/players/isko.png",
		"perk": "+8% speed after 6:00",
	},
	"bining": {
		"name": "LOLA BINING",
		"title": "Albularyo",
		"weapon": "bawang",
		"hp": 140.0,
		"speed": 104.0,
		"tex": "res://art/players/bining.png",
		"perk": "Healing +25%",
	},
	"doring": {
		"name": "MANG DORING",
		"title": "Arnisador",
		"weapon": "yantok",
		"hp": 170.0,
		"speed": 112.0,
		"tex": "res://art/players/doring.png",
		"perk": "Attack speed +10%",
	},
}

const CHAR_ORDER := ["isko", "bining", "doring"]

# ---------------------------------------------------------------------------
# Weapons. Damage/cooldown are level-1 values; levels add 22% damage each.
# ---------------------------------------------------------------------------
const WEAPONS := {
	"itak": {
		"name": "Itak",
		"icon": "res://art/icons/itak.png",
		"cd": 0.85,
		"dmg": 10.0,
		"desc": "Wide bolo slash toward your facing.",
	},
	"balisong": {
		"name": "Balisong",
		"icon": "res://art/icons/balisong.png",
		"cd": 0.6,
		"dmg": 5.0,
		"desc": "Rapid triple thrust. Short range, high crit.",
	},
	"yantok": {
		"name": "Yantok",
		"icon": "res://art/icons/yantok.png",
		"cd": 1.0,
		"dmg": 8.0,
		"desc": "Arnis sticks strike both sides and stun.",
	},
	"sumpit": {
		"name": "Sumpit",
		"icon": "res://art/icons/sumpit.png",
		"cd": 1.15,
		"dmg": 12.0,
		"desc": "Piercing poison dart in a straight line.",
	},
	"banga": {
		"name": "Banga",
		"icon": "res://art/icons/banga.png",
		"cd": 2.0,
		"dmg": 18.0,
		"desc": "Lobbed clay pot. Shatters for area damage.",
	},
	"bawang": {
		"name": "Bawang",
		"icon": "res://art/icons/bawang.png",
		"cd": 0.55,
		"dmg": 4.0,
		"desc": "Garlic aura. Damages and repels aswang.",
	},
	"tsinelas": {
		"name": "Tsinelas",
		"icon": "res://art/icons/tsinelas.png",
		"cd": 1.5,
		"dmg": 9.0,
		"desc": "Thrown slipper. Boomerangs back. Huge knockback.",
	},
	"kulintang": {
		"name": "Kulintang",
		"icon": "res://art/icons/kulintang.png",
		"cd": 2.4,
		"dmg": 14.0,
		"desc": "Gong pulse expands around you and stuns.",
	},
	"pana": {
		"name": "Pana",
		"icon": "res://art/icons/pana.png",
		"cd": 1.0,
		"dmg": 9.0,
		"desc": "Bow fires a spread of 2 arrows that pierce.",
	},
	"sulo": {
		"name": "Sulo",
		"icon": "res://art/icons/sulo.png",
		"cd": 0.4,
		"dmg": 4.0,
		"desc": "Torch leaves a short fire trail behind you.",
	},
	"yoyo": {
		"name": "Yoyo",
		"icon": "res://art/icons/yoyo.png",
		"cd": 1.5,
		"dmg": 7.0,
		"desc": "Yoyo loops out and back, hitting on both passes.",
	},
	"sibat": {
		"name": "Sibat",
		"icon": "res://art/icons/sibat.png",
		"cd": 1.2,
		"dmg": 11.0,
		"desc": "Spear thrust pierces a line with a small forward step.",
	},
	"lantaka": {
		"name": "Lantaka",
		"icon": "res://art/icons/lantaka.png",
		"cd": 3.0,
		"dmg": 28.0,
		"desc": "Bamboo cannon fires a slow shell with big AoE.",
	},
	"kalabaw": {
		"name": "Kalabaw",
		"icon": "res://art/icons/kalabaw.png",
		"cd": 4.0,
		"dmg": 16.0,
		"desc": "Carabao charges across the screen, trampling a line.",
	},
}

const WEAPON_ORDER := ["itak", "balisong", "yantok", "sumpit", "banga", "bawang", "tsinelas", "kulintang", "pana", "sulo", "yoyo", "sibat", "lantaka", "kalabaw"]

# ---------------------------------------------------------------------------
# Passives
# ---------------------------------------------------------------------------
const PASSIVES := {
	"agimat": {"name": "Agimat", "icon": "res://art/icons/agimat.png", "max": 5, "desc": "+15 max HP."},
	"bakya": {"name": "Bakya", "icon": "res://art/icons/bakya.png", "max": 5, "desc": "+8% move speed."},
	"singsing": {"name": "Singsing", "icon": "res://art/icons/singsing.png", "max": 5, "desc": "+7% crit chance."},
	"kandila": {"name": "Kandila", "icon": "res://art/icons/kandila.png", "max": 5, "desc": "+12% area, bigger lantern."},
	"bayong": {"name": "Bayong", "icon": "res://art/icons/bayong.png", "max": 5, "desc": "+30 pickup radius."},
	"pamaypay": {"name": "Pamaypay", "icon": "res://art/icons/pamaypay.png", "max": 5, "desc": "-7% weapon cooldown."},
	"tabo": {"name": "Tabo", "icon": "res://art/icons/tabo.png", "max": 5, "desc": "+0.6 HP per second."},
	"kwintas": {"name": "Kwintas", "icon": "res://art/icons/kwintas.png", "max": 5, "desc": "+15% damage vs aswang."},
	"salakot": {"name": "Salakot", "icon": "res://art/icons/salakot.png", "max": 5, "desc": "+1 armor."},
	"kawayan": {"name": "Kawayan", "icon": "res://art/icons/kawayan.png", "max": 3, "desc": "+1 projectile."},
	"panyo": {"name": "Panyo", "icon": "res://art/icons/panyo.png", "max": 5, "desc": "+5% dodge chance."},
	"puno_ng_balete": {"name": "Puno ng Balete", "icon": "res://art/icons/puno_ng_balete.png", "max": 3, "desc": "+20% luck, +25% elite spawn rate."},
	"bagoong": {"name": "Bagoong", "icon": "res://art/icons/bagoong.png", "max": 5, "desc": "Stink aura: 20 dps in 48 px."},
}

const PASSIVE_ORDER := ["agimat", "bakya", "singsing", "kandila", "bayong", "pamaypay", "tabo", "kwintas", "salakot", "kawayan", "panyo", "puno_ng_balete", "bagoong"]

# ---------------------------------------------------------------------------
# Evolutions: weapon at level 8 + required passive
# ---------------------------------------------------------------------------
const EVOLUTIONS := {
	"itak": {
		"passive": "singsing",
		"name": "Itak ng Tagapagbantay",
		"desc": "Every 3rd slash becomes a full 360 spin.",
		"icon": "res://art/icons/itak.png",
	},
	"tsinelas": {
		"passive": "bakya",
		"name": "Tsinelas ni Inay",
		"desc": "Three homing slippers. Maximum tsinelas.",
		"icon": "res://art/icons/tsinelas.png",
	},
	"sumpit": {
		"passive": "kwintas",
		"name": "Sumpit ng Gubat",
		"desc": "Darts pierce everything and leave poison.",
		"icon": "res://art/icons/sumpit.png",
	},
	"pana": {
		"passive": "kawayan",
		"name": "Pana ng Diwata",
		"desc": "Homing arrows, pierce 3, +1 projectile.",
		"icon": "res://art/icons/pana.png",
	},
	"sulo": {
		"passive": "kandila",
		"name": "Santelmo",
		"desc": "Orbiting fireball that seeks the nearest enemy.",
		"icon": "res://art/icons/sulo.png",
	},
	"yoyo": {
		"passive": "panyo",
		"name": "Yoyo ng Bayan",
		"desc": "Two yoyos orbit and pull enemies inward.",
		"icon": "res://art/icons/yoyo.png",
	},
	"sibat": {
		"passive": "agimat",
		"name": "Sibat ng Kidlat",
		"desc": "Calls a lightning spear from the sky on the furthest enemy.",
		"icon": "res://art/icons/sibat.png",
	},
	"lantaka": {
		"passive": "puno_ng_balete",
		"name": "Lantaka ng Moog",
		"desc": "Cluster shells, 3 explosions.",
		"icon": "res://art/icons/lantaka.png",
	},
	"kalabaw": {
		"passive": "bagoong",
		"name": "Kalabaw ng Bukid",
		"desc": "Two carabaos, wider trample, 1 s stun.",
		"icon": "res://art/icons/kalabaw.png",
	},
}

# ---------------------------------------------------------------------------
# Enemies
# ---------------------------------------------------------------------------
const ENEMIES := {
	"tiktik": {
		"name": "Bat", "tex": "res://art/enemies/tiktik.png",
		"hp": 7.0, "speed": 60.0, "dmg": 2.0, "radius": 6.0, "xp": 1,
		"behavior": "chase", "tags": ["aswang"], "scale": 1.0,
	},
	"dwende": {
		"name": "Imp", "tex": "res://art/enemies/dwende.png",
		"hp": 9.0, "speed": 48.0, "dmg": 2.0, "radius": 6.0, "xp": 1,
		"behavior": "chase", "tags": ["spirit"], "scale": 1.0,
	},
	"balbal": {
		"name": "Ghoul", "tex": "res://art/enemies/balbal.png",
		"hp": 36.0, "speed": 26.0, "dmg": 5.0, "radius": 8.0, "xp": 3,
		"behavior": "tank", "tags": ["undead"], "scale": 1.0,
	},
	"tiyanak": {
		"name": "Changeling", "tex": "res://art/enemies/tiyanak.png",
		"hp": 16.0, "speed": 44.0, "dmg": 5.0, "radius": 6.5, "xp": 2,
		"behavior": "lunge", "tags": ["aswang"], "scale": 1.0,
	},
	"white_lady": {
		"name": "White Lady", "tex": "res://art/enemies/white_lady.png",
		"hp": 26.0, "speed": 32.0, "dmg": 5.0, "radius": 8.0, "xp": 3,
		"behavior": "phase", "tags": ["spirit"], "scale": 1.0,
	},
	"aswang": {
		"name": "Aswang", "tex": "res://art/enemies/aswang.png",
		"hp": 80.0, "speed": 45.0, "dmg": 8.0, "radius": 9.0, "xp": 8,
		"behavior": "chase", "tags": ["aswang"], "scale": 1.0,
	},
	"kapre": {
		"name": "Kapre", "tex": "res://art/enemies/kapre.png",
		"hp": 720.0, "speed": 22.0, "dmg": 14.0, "radius": 18.0, "xp": 60,
		"behavior": "boss_kapre", "tags": ["spirit"], "scale": 1.0, "boss": true,
	},
	"bakunawa": {
		"name": "Bakunawa", "tex": "res://art/enemies/bakunawa.png",
		"hp": 2200.0, "speed": 35.0, "dmg": 18.0, "radius": 24.0, "xp": 200,
		"behavior": "boss_bakunawa", "tags": ["aswang"], "scale": 1.0, "boss": true,
	},
}

const BOSS_ORDER := ["kapre", "bakunawa"]
