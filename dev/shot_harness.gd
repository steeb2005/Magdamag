extends Node

# Dev-only screenshot harness. Not included in exported builds.
# Usage: instantiate from main.gd when --shot-* flag is detected.

const MainScript = preload("res://src/main.gd")
const PlayerScript = preload("res://src/player.gd")
const EnemyScript = preload("res://src/enemy.gd")
const OrbScript = preload("res://src/orb.gd")
const PickupScript = preload("res://src/pickup.gd")
const ProjectileScript = preload("res://src/projectile.gd")
const HUDScene = preload("res://src/hud.gd")
const DataRef = preload("res://src/data.gd")
const FXRef = preload("res://src/fx.gd")

const GROUND_TEX = preload("res://art/env/ground.png")
const TREE_TEXES = [
	preload("res://art/env/tree_0.png"),
	preload("res://art/env/tree_1.png"),
	preload("res://art/env/tree_2.png"),
]
const BALETE_TEXES = [
	preload("res://art/env/balete_0.png"),
	preload("res://art/env/balete_1.png"),
]
const ROCK_TEX = preload("res://art/env/rock.png")
const FERN_TEX = preload("res://art/env/fern.png")
const BUSH_TEX = preload("res://art/env/bush.png")
const NUNO_TEX = preload("res://art/enemies/nuno.png")

var main_ref: MainScript
var rng := RandomNumberGenerator.new()
var shot_mode: String = ""
var player = null
var entities: Node2D = null
var fx_layer: Node2D = null
var world: Node2D = null
var canvas_mod: CanvasModulate = null
var mounds: Array = []
var hud = null
var boss = null

func setup(main: MainScript, mode: String) -> void:
	main_ref = main
	shot_mode = mode
	rng.seed = 20261126
	_build_world()
	await _run_shot()

func _build_world() -> void:
	world = Node2D.new()
	main_ref.add_child(world)

	var ground := ColorRect.new()
	ground.position = Vector2(-1600, -1600)
	ground.size = Vector2(3200, 3200)
	ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mat := ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = """
	shader_type canvas_item;
	uniform sampler2D ground_tex : repeat_enable;
	uniform float tile_size = 128.0;
	uniform float world_size = 3200.0;
	void fragment() {
		vec2 uv = (UV * world_size) / tile_size;
		COLOR = texture(ground_tex, uv);
	}
	"""
	mat.shader = sh
	mat.set_shader_parameter("ground_tex", GROUND_TEX)
	ground.material = mat
	world.add_child(ground)

	canvas_mod = CanvasModulate.new()
	canvas_mod.color = Color(0.30, 0.32, 0.46)
	world.add_child(canvas_mod)

	entities = Node2D.new()
	entities.y_sort_enabled = true
	world.add_child(entities)

	fx_layer = Node2D.new()
	fx_layer.z_index = 20
	world.add_child(fx_layer)

	# Decor (same as main.gd _build_world)
	for i in 8:
		_decor(BALETE_TEXES[rng.randi_range(0, BALETE_TEXES.size() - 1)], _scatter_point(300.0), 1.0)

	for i in 200:
		var tc := _scatter_point(170.0)
		for j in rng.randi_range(1, 3):
			var tp := tc + Vector2(rng.randf_range(-62, 62), rng.randf_range(-44, 44))
			_decor(TREE_TEXES[rng.randi_range(0, TREE_TEXES.size() - 1)], tp, rng.randf_range(0.8, 1.15))

	for i in 210:
		var fc := _scatter_point(60.0)
		for j in rng.randi_range(2, 4):
			var fp := fc + Vector2(rng.randf_range(-42, 42), rng.randf_range(-30, 30))
			_decor(FERN_TEX, fp, rng.randf_range(0.85, 1.4))

	for i in 90:
		var rc := _scatter_point(60.0)
		for j in rng.randi_range(1, 3):
			_decor(ROCK_TEX, rc + Vector2(rng.randf_range(-36, 36), rng.randf_range(-28, 28)), rng.randf_range(0.8, 1.25))

	for i in 95:
		var bc := _scatter_point(80.0)
		for j in rng.randi_range(1, 3):
			_decor(BUSH_TEX, bc + Vector2(rng.randf_range(-36, 36), rng.randf_range(-28, 28)), rng.randf_range(0.9, 1.35))

	# nuno mounds
	for i in 9:
		var pos := _scatter_point(140.0)
		var holder := _decor(NUNO_TEX, pos, 1.0)
		mounds.append({"pos": pos, "used": false, "node": holder})

func _scatter_point(min_center: float) -> Vector2:
	for attempt in 40:
		var p := Vector2(rng.randf_range(-1500.0, 1500.0), rng.randf_range(-1500.0, 1500.0))
		if p.length() > min_center:
			return p
	return Vector2(400, 400)

func _decor(tex: Texture2D, pos: Vector2, sc: float) -> Node2D:
	var holder := Node2D.new()
	holder.position = pos
	var s := Sprite2D.new()
	s.texture = tex
	s.centered = false
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.scale = Vector2(sc, sc)
	s.position = Vector2(-tex.get_width() * 0.5 * sc, -tex.get_height() * sc)
	holder.add_child(s)
	entities.add_child(holder)
	return holder

func _run_shot() -> void:
	print("SHOT: creating player...")
	player = PlayerScript.new()
	player.position = Vector2.ZERO
	entities.add_child(player)
	player.setup(main_ref, "isko")
	print("SHOT: player ready, creating hud...")

	hud = HUDScene.new()
	main_ref.add_child(hud)
	hud.setup(main_ref)
	hud.begin_run("isko")
	print("SHOT: hud ready, mode: " + shot_mode)

	match shot_mode:
		"menu":
			hud.show_menu(0.0, 0)
		"game":
			_fake_progress(215.0)
		"level":
			_fake_progress(150.0)
			player.pending_levels = 1
			_open_levelup()
		"boss":
			_fake_progress(365.0)
			_spawn_boss("kapre")
			boss.position = player.position + Vector2(110, -40)
		"win":
			_fake_progress(1080.0)
			_win()
		"evo":
			_setup_evo_test()
			_open_levelup()
			print("EVO TEST: levelup opened, waiting for timer...")

	# For evo test, don't pause so timer works
	if shot_mode == "evo":
		print("EVO TEST: starting timer...")
		await get_tree().create_timer(1.0, false).timeout
		print("EVO TEST: timer done")
	else:
		await get_tree().create_timer(1.4, true).timeout
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	# Save to dev/ folder (ignored by Godot via .gdignore)
	var path := "res://dev/shot_%s.png" % shot_mode
	var err := img.save_png(path)
	print("SHOT %s -> %s (err=%d)" % [shot_mode, path, err])
	get_tree().quit()

func _fake_progress(t: float) -> void:
	main_ref.time = t
	_demo_build()
	var kinds := ["tiktik", "dwende", "balbal", "tiyanak", "white_lady", "aswang"]
	for i in 46:
		var ang := rng.randf() * TAU
		var dist := rng.randf_range(60.0, 250.0)
		var kind: String = kinds[rng.randi_range(0, min(kinds.size() - 1, 1 + int(t / 90.0)))]
		spawn_enemy(kind, player.position + Vector2(cos(ang), sin(ang)) * dist)

func _demo_build() -> void:
	for id in ["itak", "banga", "tsinelas", "sumpit", "kulintang"]:
		if not player.has_weapon(id):
			player.add_weapon(id)
	player.upgrade_weapon("itak")
	player.upgrade_weapon("banga")
	player.upgrade_weapon("kulintang")
	for id in ["agimat", "bakya", "singsing", "kandila"]:
		player.add_passive(id)
	player.level = 14
	player.xp = 14
	player.xp_next = 48
	hud.refresh_build()
	hud.update_game()

func _open_levelup() -> void:
	main_ref.state = MainScript.State.LEVELUP
	if shot_mode != "evo":
		get_tree().paused = true
	var cards = _build_cards()
	hud.show_levelup(cards)

func _build_cards() -> Array:
	var cards: Array = []
	var p = player

	for w in p.weapons:
		var id: String = w["id"]
		if int(w["level"]) >= 8 and not bool(w["evo"]) and DataRef.EVOLUTIONS.has(id):
			var evo: Dictionary = DataRef.EVOLUTIONS[id]
			if p.passives.has(evo["passive"]):
				cards.append({
					"kind": "evolve", "id": id, "title": evo["name"], "desc": evo["desc"],
					"icon": evo["icon"], "tag": "EVOLUTION",
				})

	for w in p.weapons:
		var id: String = w["id"]
		if int(w["level"]) < 8:
			var wd: Dictionary = DataRef.WEAPONS[id]
			cards.append({
				"kind": "weapon_up", "id": id, "title": wd["name"], "desc": wd["desc"],
				"icon": wd["icon"], "tag": "LV %d > %d" % [int(w["level"]), int(w["level"]) + 1],
			})

	if p.weapons.size() < 6:
		for id in DataRef.WEAPON_ORDER:
			if not p.has_weapon(id):
				var wd: Dictionary = DataRef.WEAPONS[id]
				cards.append({
					"kind": "weapon_new", "id": id, "title": wd["name"], "desc": wd["desc"],
					"icon": wd["icon"], "tag": "NEW WEAPON",
				})

	for id in p.passives:
		var pd: Dictionary = DataRef.PASSIVES[id]
		if int(p.passives[id]) < int(pd["max"]):
			cards.append({
				"kind": "passive_up", "id": id, "title": pd["name"], "desc": pd["desc"],
				"icon": pd["icon"], "tag": "LV %d" % (int(p.passives[id]) + 1),
			})

	if p.passives.size() < 6:
		for id in DataRef.PASSIVE_ORDER:
			if not p.passives.has(id):
				var pd: Dictionary = DataRef.PASSIVES[id]
				cards.append({
					"kind": "passive_new", "id": id, "title": pd["name"], "desc": pd["desc"],
					"icon": pd["icon"], "tag": "NEW",
				})

	cards.shuffle()

	var evo_card: Dictionary = {}
	for c in cards:
		if c["kind"] == "evolve":
			evo_card = c
			break
	if not evo_card.is_empty():
		cards.erase(evo_card)
		cards.insert(0, evo_card)

	var picked: Array = cards.slice(0, 3)
	while picked.size() < 3:
		picked.append({
			"kind": "heal", "id": "", "title": "Kandila", "desc": "Recover 30 HP.",
			"icon": "res://art/icons/kandila.png", "tag": "RECOVER",
		})
	return picked

func spawn_enemy(enemy_id: String, pos: Vector2, elite := false):
	var e = EnemyScript.new()
	e.position = pos
	entities.add_child(e)
	e.setup(main_ref, enemy_id, elite)
	main_ref.enemies.append(e)
	return e

func _spawn_boss(enemy_id: String) -> void:
	var ang := rng.randf() * TAU
	var pos: Vector2 = player.position + Vector2(cos(ang), sin(ang)) * 300.0
	boss = spawn_enemy(enemy_id, pos, false)
	main_ref.boss = boss
	hud.toast(DataRef.ENEMIES[enemy_id]["name"].to_upper(), 3.0)
	main_ref.shake(8.0)

func _win() -> void:
	main_ref.state = MainScript.State.WIN
	get_tree().paused = true
	hud.show_end(true, _stats_text())

func _stats_text() -> String:
	return "survived  %s\ntime of night  %s\nkills  %d\nlevel  %d\nbarya  %d" % [
		hud._fmt(main_ref.time), main_ref.act_name(), main_ref.kills, player.level,
		player.gold,
	]


func _setup_evo_test() -> void:
	# Force Itak to level 8 + Singsing passive for evolution test
	if player != null:
		if not player.has_weapon("itak"):
			player.add_weapon("itak")
		for i in range(7):
			player.upgrade_weapon("itak")
		player.add_passive("singsing")
		player.add_weapon("bawang")
		player.add_weapon("kulintang")
		player.add_passive("agimat")
		player.add_passive("bakya")
		player.level = 15
		player.recalc_stats()
		hud.refresh_build()