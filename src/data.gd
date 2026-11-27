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
		"hp": 100.0,
		"speed": 110.0,
		"tex": "res://art/players/isko.png",
		"perk": "+8% speed after 6:00",
	},
	"bining": {
		"name": "LOLA BINING",
		"title": "Albularyo",
		"weapon": "bawang",
		"hp": 90.0,
		"speed": 104.0,
		"tex": "res://art/players/bining.png",
		"perk": "Healing +25%",
	},
	"doring": {
		"name": "MANG DORING",
		"title": "Arnisador",
		"weapon": "yantok",
		"hp": 110.0,
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
}

const WEAPON_ORDER := ["itak", "balisong", "yantok", "sumpit", "banga", "bawang", "tsinelas", "kulintang"]

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
}

const PASSIVE_ORDER := ["agimat", "bakya", "singsing", "kandila", "bayong", "pamaypay", "tabo", "kwintas"]

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
}

# ---------------------------------------------------------------------------
# Enemies
# ---------------------------------------------------------------------------
const ENEMIES := {
	"tiktik": {
		"name": "Tiktik", "tex": "res://art/enemies/tiktik.png",
		"hp": 7.0, "speed": 80.0, "dmg": 5.0, "radius": 6.0, "xp": 1,
		"behavior": "chase", "tags": ["aswang"], "scale": 1.0,
	},
	"dwende": {
		"name": "Dwende", "tex": "res://art/enemies/dwende.png",
		"hp": 9.0, "speed": 64.0, "dmg": 5.0, "radius": 6.0, "xp": 1,
		"behavior": "chase", "tags": ["spirit"], "scale": 1.0,
	},
	"balbal": {
		"name": "Balbal", "tex": "res://art/enemies/balbal.png",
		"hp": 36.0, "speed": 34.0, "dmg": 11.0, "radius": 8.0, "xp": 3,
		"behavior": "tank", "tags": ["undead"], "scale": 1.0,
	},
	"tiyanak": {
		"name": "Tiyanak", "tex": "res://art/enemies/tiyanak.png",
		"hp": 16.0, "speed": 58.0, "dmg": 9.0, "radius": 6.5, "xp": 2,
		"behavior": "lunge", "tags": ["aswang"], "scale": 1.0,
	},
	"white_lady": {
		"name": "White Lady", "tex": "res://art/enemies/white_lady.png",
		"hp": 26.0, "speed": 42.0, "dmg": 9.0, "radius": 8.0, "xp": 3,
		"behavior": "phase", "tags": ["spirit"], "scale": 1.0,
	},
	"aswang": {
		"name": "Aswang", "tex": "res://art/enemies/aswang.png",
		"hp": 80.0, "speed": 60.0, "dmg": 15.0, "radius": 9.0, "xp": 8,
		"behavior": "chase", "tags": ["aswang"], "scale": 1.0,
	},
	"nuno": {
		"name": "Nuno sa Punso", "tex": "res://art/enemies/nuno.png",
		"hp": 24.0, "speed": 0.0, "dmg": 8.0, "radius": 7.0, "xp": 2,
		"behavior": "turret", "tags": ["spirit"], "scale": 1.0,
	},
	"kapre": {
		"name": "Kapre", "tex": "res://art/enemies/kapre.png",
		"hp": 720.0, "speed": 28.0, "dmg": 18.0, "radius": 18.0, "xp": 60,
		"behavior": "boss_kapre", "tags": ["spirit"], "scale": 1.0, "boss": true,
	},
	"bakunawa": {
		"name": "Bakunawa", "tex": "res://art/enemies/bakunawa.png",
		"hp": 2200.0, "speed": 46.0, "dmg": 22.0, "radius": 24.0, "xp": 200,
		"behavior": "boss_bakunawa", "tags": ["aswang"], "scale": 1.0, "boss": true,
	},
}

const BOSS_ORDER := ["kapre", "bakunawa"]
