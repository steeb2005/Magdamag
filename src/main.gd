extends Node2D

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

enum State { MENU, PLAY, LEVELUP, PAUSED, OVER, WIN }

var state: int = State.MENU
var time := 0.0
var kills := 0
var last_char := "isko"

var world: Node2D = null
var entities: Node2D = null
var fx_layer: Node2D = null
var canvas_mod: CanvasModulate = null
var player = null
var hud = null
var boss = null
var dawn := false

var enemies: Array = []
var grid: Dictionary = {}
var mounds: Array = []

var spawn_timer := 0.0
var elite_timer := 40.0
var dawn_tick := 0.0
var shake_amt := 0.0
var act_index := 0
var boss_spawned := [false, false]
var current_cards: Array = []

var rng := RandomNumberGenerator.new()
var best_time := 0.0
var wins := 0
var autotest := false
var god := false
var verbose := false
var debug_timer := 0.0
var shot_mode := ""
var force_evo_test := false


func _ready() -> void:
	_setup_input()
	rng.randomize()
	_load_save()
	hud = HUDScene.new()
	add_child(hud)
	hud.setup(self)
	hud.show_menu(best_time, wins)

	var args := OS.get_cmdline_user_args()
	var flags: Array = []
	for a in args:
		flags.append(String(a).trim_prefix("--"))
	autotest = flags.has("autotest")
	god = flags.has("god")
	verbose = flags.has("verbose")
	force_evo_test = flags.has("force-evo-test")
	for m in ["menu", "game", "level", "boss", "win", "evo"]:
		if flags.has("shot-" + m):
			shot_mode = m
	if shot_mode != "":
		_setup_shot()
		return
	if force_evo_test:
		start_run("isko")
		_setup_evo_test()
	elif autotest or flags.has("autostart"):
		start_run("isko")


func _setup_shot() -> void:
	# Dev-only screenshot harness — lives in dev/shot_harness.gd to keep shipping code clean
	var harness = preload("res://dev/shot_harness.gd").new()
	add_child(harness)
	await harness.setup(self, shot_mode)


# ---------------------------------------------------------------------------
# Input map (built at runtime so the project file stays simple)
# ---------------------------------------------------------------------------
func _setup_input() -> void:
	var keys := {
		"move_left": [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"move_up": [KEY_W, KEY_UP],
		"move_down": [KEY_S, KEY_DOWN],
		"dash": [KEY_SPACE],
		"interact": [KEY_E],
		"pause": [KEY_ESCAPE],
	}
	for action in keys:
		if not InputMap.has_action(action):
			InputMap.add_action(action, 0.2)
		for k in keys[action]:
			var ev := InputEventKey.new()
			ev.physical_keycode = k
			InputMap.action_add_event(action, ev)

	_axis("move_left", JOY_AXIS_LEFT_X, -1.0)
	_axis("move_right", JOY_AXIS_LEFT_X, 1.0)
	_axis("move_up", JOY_AXIS_LEFT_Y, -1.0)
	_axis("move_down", JOY_AXIS_LEFT_Y, 1.0)
	_joy("dash", JOY_BUTTON_A)
	_joy("interact", JOY_BUTTON_X)
	_joy("pause", JOY_BUTTON_START)


func _axis(action: String, axis: int, value: float) -> void:
	var ev := InputEventJoypadMotion.new()
	ev.axis = axis
	ev.axis_value = value
	InputMap.action_add_event(action, ev)


func _joy(action: String, button: int) -> void:
	var ev := InputEventJoypadButton.new()
	ev.button_index = button
	InputMap.action_add_event(action, ev)


# ---------------------------------------------------------------------------
# State queries
# ---------------------------------------------------------------------------
func is_playing() -> bool:
	return state == State.PLAY


func is_paused() -> bool:
	return state == State.PAUSED


func request_pause() -> void:
	if state == State.PLAY:
		state = State.PAUSED
		get_tree().paused = true
		hud.show_pause(true)
	elif state == State.PAUSED:
		state = State.PLAY
		get_tree().paused = false
		hud.show_pause(false)


func act_name() -> String:
	if time < 180.0:
		return "DUSK"
	if time < 360.0:
		return "NIGHT"
	if time < 600.0:
		return "MIDNIGHT"
	if time < 840.0:
		return "PRE-DAWN"
	return "DAWN"


func enemy_hp_mult() -> float:
	return 1.0 + time / 60.0 * 0.08


func enemy_dmg_mult() -> float:
	return 1.0 + time / 60.0 * 0.035


# ---------------------------------------------------------------------------
# Run lifecycle
# ---------------------------------------------------------------------------
func start_run(char_id: String) -> void:
	get_tree().paused = false
	_clear_world()
	print("RUN START ", char_id)
	last_char = char_id
	state = State.PLAY
	time = 0.0
	kills = 0
	boss = null
	dawn = false
	dawn_tick = 0.0
	act_index = 0
	spawn_timer = 0.7
	elite_timer = 40.0
	shake_amt = 0.0
	boss_spawned = [false, false]
	enemies.clear()
	grid.clear()
	mounds.clear()
	current_cards.clear()
	rng.randomize()

	_build_world()

	player = PlayerScript.new()
	player.position = Vector2.ZERO
	entities.add_child(player)
	player.setup(self, char_id)
	player.died.connect(_on_player_died)

	hud.begin_run(char_id)
	hud.toast("DUSK", 2.0)


func _setup_evo_test() -> void:
	# Force Itak to level 8 + Singsing passive for evolution test
	if player != null:
		# Ensure Itak exists
		if not player.has_weapon("itak"):
			player.add_weapon("itak")
		# Upgrade Itak to level 8
		for i in range(7):
			player.upgrade_weapon("itak")
		# Add Singsing passive (required for Itak evolution)
		player.add_passive("singsing")
		# Add some other weapons/passives for variety
		player.add_weapon("bawang")
		player.add_weapon("kulintang")
		player.add_passive("agimat")
		player.add_passive("bakya")
		player.level = 15
		player.recalc_stats()
		hud.refresh_build()
		# Trigger level-up to show evolution card
		player.pending_levels = 1
		_open_levelup()


func restart_run() -> void:
	start_run(last_char)


func quit_to_menu() -> void:
	get_tree().paused = false
	_clear_world()
	state = State.MENU
	hud.show_menu(best_time, wins)


func _clear_world() -> void:
	if world != null and is_instance_valid(world):
		world.queue_free()
	world = null
	entities = null
	fx_layer = null
	canvas_mod = null
	player = null
	boss = null
	enemies.clear()
	grid.clear()
	mounds.clear()


func _on_player_died() -> void:
	if state != State.PLAY:
		return
	state = State.OVER
	get_tree().paused = true
	best_time = maxf(best_time, time)
	_save_progress()
	print("AUTOTEST DEATH t=%d kills=%d lv=%d" % [int(time), kills, player.level])
	hud.show_end(false, _stats_text())


func _win() -> void:
	if state != State.PLAY:
		return
	state = State.WIN
	get_tree().paused = true
	wins += 1
	best_time = maxf(best_time, time)
	_save_progress()
	print("AUTOTEST WIN t=%d kills=%d lv=%d" % [int(time), kills, player.level])
	hud.show_end(true, _stats_text())


func _stats_text() -> String:
	var lines: Array = []
	lines.append("survived  %s" % hud._fmt(time))
	lines.append("time of night  %s" % act_name())
	lines.append("kills  %d" % kills)
	lines.append("level  %d" % (player.level if player != null else 1))
	lines.append("coins  %d" % (player.gold if player != null else 0))
	lines.append("")
	lines.append("BUILD")
	if player != null:
		for w in player.weapons:
			var tag := "EVO" if bool(w["evo"]) else "L%d" % int(w["level"])
			lines.append("  %s [%s]" % [DataRef.WEAPONS[w["id"]]["name"], tag])
		for id in player.passives:
			lines.append("  %s L%d" % [DataRef.PASSIVES[id]["name"], int(player.passives[id])])
	return "\n".join(lines)


# ---------------------------------------------------------------------------
# World construction
# ---------------------------------------------------------------------------
func _build_world() -> void:
	world = Node2D.new()
	add_child(world)

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

	var drng := RandomNumberGenerator.new()
	drng.seed = 20261126

	for i in 8:
		_decor(BALETE_TEXES[drng.randi_range(0, BALETE_TEXES.size() - 1)], _scatter_point(drng, 300.0), 1.0)

	for i in 200:
		var tc := _scatter_point(drng, 170.0)
		for j in drng.randi_range(1, 3):
			var tp := tc + Vector2(drng.randf_range(-62, 62), drng.randf_range(-44, 44))
			_decor(TREE_TEXES[drng.randi_range(0, TREE_TEXES.size() - 1)], tp, drng.randf_range(0.8, 1.15))

	for i in 210:
		var fc := _scatter_point(drng, 60.0)
		for j in drng.randi_range(2, 4):
			var fp := fc + Vector2(drng.randf_range(-42, 42), drng.randf_range(-30, 30))
			_decor(FERN_TEX, fp, drng.randf_range(0.85, 1.4))

	for i in 90:
		var rc := _scatter_point(drng, 60.0)
		for j in drng.randi_range(1, 3):
			_decor(ROCK_TEX, rc + Vector2(drng.randf_range(-36, 36), drng.randf_range(-28, 28)), drng.randf_range(0.8, 1.25))

	for i in 95:
		var bc := _scatter_point(drng, 80.0)
		for j in drng.randi_range(1, 3):
			_decor(BUSH_TEX, bc + Vector2(drng.randf_range(-36, 36), drng.randf_range(-28, 28)), drng.randf_range(0.9, 1.35))

	# nuno mounds (tabi-tabi po)
	for i in 9:
		var pos := _scatter_point(drng, 140.0)
		var holder := _decor(NUNO_TEX, pos, 1.0)
		mounds.append({"pos": pos, "used": false, "node": holder})


func _scatter_point(drng: RandomNumberGenerator, min_center: float) -> Vector2:
	for attempt in 40:
		var p := Vector2(drng.randf_range(-1500.0, 1500.0), drng.randf_range(-1500.0, 1500.0))
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


# ---------------------------------------------------------------------------
# Spawning
# ---------------------------------------------------------------------------
func spawn_enemy(enemy_id: String, pos: Vector2, elite := false):
	var e = EnemyScript.new()
	e.position = pos
	entities.add_child(e)
	e.setup(self, enemy_id, elite)
	enemies.append(e)
	return e


func _spawn_at_ring(enemy_id: String, elite := false) -> void:
	if player == null:
		return
	var ang := rng.randf() * TAU
	var dist := rng.randf_range(370.0, 440.0)
	var pos: Vector2 = player.position + Vector2(cos(ang), sin(ang)) * dist
	pos.x = clampf(pos.x, -1480.0, 1480.0)
	pos.y = clampf(pos.y, -1480.0, 1480.0)
	spawn_enemy(enemy_id, pos, elite)


func _spawn_boss(enemy_id: String) -> void:
	var ang := rng.randf() * TAU
	var pos: Vector2 = player.position + Vector2(cos(ang), sin(ang)) * 300.0
	boss = spawn_enemy(enemy_id, pos, false)
	hud.toast(DataRef.ENEMIES[enemy_id]["name"].to_upper(), 3.0)
	shake(8.0)


func _pick_type() -> String:
	var r := rng.randf() * 100.0
	if time < 90.0:
		return "tiktik" if r < 60.0 else "dwende"
	if time < 180.0:
		if r < 40.0:
			return "tiktik"
		if r < 75.0:
			return "dwende"
		return "balbal"
	if time < 300.0:
		if r < 32.0:
			return "tiktik"
		if r < 62.0:
			return "dwende"
		if r < 82.0:
			return "balbal"
		return "tiyanak"
	if time < 420.0:
		if r < 26.0:
			return "tiktik"
		if r < 50.0:
			return "dwende"
		if r < 70.0:
			return "balbal"
		if r < 85.0:
			return "tiyanak"
		return "white_lady"
	if r < 20.0:
		return "tiktik"
	if r < 38.0:
		return "dwende"
	if r < 56.0:
		return "balbal"
	if r < 72.0:
		return "tiyanak"
	if r < 84.0:
		return "white_lady"
	return "aswang"


func add_projectile(p) -> void:
	p.main = self
	fx_layer.add_child(p)


func spawn_hostile_projectile(pos: Vector2, vel: Vector2, dmg: float, col: Color, size: float) -> void:
	var p = ProjectileScript.new()
	p.hostile = true
	p.position = pos
	p.vel = vel
	p.damage = dmg
	p.radius = size
	p.size = size
	p.color = col
	p.life = 4.0
	add_projectile(p)


# ---------------------------------------------------------------------------
# Combat plumbing
# ---------------------------------------------------------------------------
func hit_enemy(e, dmg: float, from: Vector2, knock: float, crit: bool, stun := 0.0) -> void:
	if e == null or e.dead:
		return
	e.take_damage(dmg, from, knock, crit, stun)


func shake(amount: float) -> void:
	shake_amt = maxf(shake_amt, amount)


func on_enemy_died(e) -> void:
	enemies.erase(e)
	kills += 1
	if player != null:
		player.kills = kills
	_drop_xp(e)
	if rng.randf() < 0.22:
		_drop_pickup("barya", e.position)
	if rng.randf() < 0.025:
		_drop_pickup("kandila", e.position)
	if e == boss:
		boss = null
		hud.toast("PINATAY: " + e.display_name.to_upper(), 2.5)
		for i in 6:
			_drop_pickup("kandila", e.position + Vector2(rng.randf_range(-40, 40), rng.randf_range(-40, 40)))


func _drop_xp(e) -> void:
	var total := int(e.xp_value)
	var n := 1 if total <= 3 else 3
	var per := maxi(1, int(round(float(total) / float(n))))
	for i in n:
		var o = OrbScript.new()
		o.main = self
		o.player = player
		o.value = per
		o.position = e.position + Vector2(rng.randf_range(-8.0, 8.0), rng.randf_range(-8.0, 8.0))
		entities.add_child(o)


func _drop_pickup(kind: String, pos: Vector2) -> void:
	var pk = PickupScript.new()
	pk.main = self
	pk.player = player
	pk.kind = kind
	pk.position = pos
	entities.add_child(pk)


func get_neighbors(pos: Vector2) -> Array:
	var cell := Vector2i(floori(pos.x / 40.0), floori(pos.y / 40.0))
	var out: Array = []
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var key := Vector2i(cell.x + dx, cell.y + dy)
			if grid.has(key):
				out.append_array(grid[key])
	return out


func _rebuild_grid() -> void:
	grid.clear()
	for e in enemies:
		if e.dead:
			continue
		var key := Vector2i(floori(e.position.x / 40.0), floori(e.position.y / 40.0))
		if not grid.has(key):
			grid[key] = []
		grid[key].append(e)


# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	if state == State.PLAY:
		_rebuild_grid()


func _process(delta: float) -> void:
	if state != State.PLAY:
		return

	time += delta
	if autotest and verbose and int(time * 60.0) % 60 == 0:
		print("TICK time=%.1f enemies=%d" % [time, enemies.size()])
	_tick_acts()
	_tick_dawn(delta)
	_tick_shake(delta)

	if player == null:
		return

	if autotest:
		debug_timer += delta
		if debug_timer >= 15.0:
			debug_timer = 0.0
			var wnames := ""
			for w in player.weapons:
				wnames += "%s:%d%s " % [w["id"], int(w["level"]), "E" if bool(w["evo"]) else ""]
			print("[t=%d] hp=%.0f lv=%d kills=%d enemies=%d | %s" % [
				int(time), player.hp, player.level, kills, enemies.size(), wnames])

	if player.pending_levels > 0:
		_open_levelup()
		return

	spawn_timer -= delta
	if spawn_timer <= 0.0:
		# Fast early spawns for XP, slow late-game scaling
		spawn_timer = clampf(0.65 - time * 0.0002, 0.4, 0.65)
		var count := mini(2 + int(time / 80.0), 5)
		if enemies.size() < 150:
			for i in count:
				_spawn_at_ring(_pick_type())

	elite_timer -= delta
	if elite_timer <= 0.0:
		elite_timer = 40.0
		if time > 240.0:
			_spawn_at_ring("aswang", true)
		else:
			_spawn_at_ring("balbal", true)

	if not boss_spawned[0] and time >= 360.0:
		boss_spawned[0] = true
		_spawn_boss("kapre")
	if not boss_spawned[1] and time >= 900.0:
		boss_spawned[1] = true
		_spawn_boss("bakunawa")

	if time >= 1080.0:
		_win()
		return

	hud.update_game()


func _tick_acts() -> void:
	var new_index := 0
	if time >= 840.0:
		new_index = 4
	elif time >= 600.0:
		new_index = 3
	elif time >= 360.0:
		new_index = 2
	elif time >= 180.0:
		new_index = 1
	if new_index != act_index:
		act_index = new_index
		var names := ["DUSK", "NIGHT", "MIDNIGHT", "PRE-DAWN", "DAWN"]
		hud.toast(names[act_index], 2.2)
		if player != null:
			player.recalc_stats()


func _tick_dawn(delta: float) -> void:
	if not dawn and time >= 1020.0:
		dawn = true
		if player != null:
			player.damage_mult += 0.25
		hud.toast("DAWN", 3.0)
		shake(6.0)

	var target := Color(0.52, 0.48, 0.56)
	if time >= 840.0:
		target = Color(0.32, 0.32, 0.46)
	elif time >= 600.0:
		target = Color(0.34, 0.35, 0.49)
	elif time >= 360.0:
		target = Color(0.38, 0.40, 0.52)
	if dawn:
		target = Color(0.95, 0.74, 0.60)
	if canvas_mod != null:
		canvas_mod.color = canvas_mod.color.lerp(target, clampf(delta * 0.8, 0.0, 1.0))

	if dawn:
		dawn_tick -= delta
		if dawn_tick <= 0.0:
			dawn_tick = 1.0
			for e in enemies:
				if e.dead:
					continue
				if "aswang" in e.tags:
					e.hp -= e.max_hp * 0.02
					if e.hp <= 0.0:
						e.die()


func _tick_shake(delta: float) -> void:
	shake_amt = maxf(0.0, shake_amt - delta * 9.0)
	if player != null and player.camera != null:
		if shake_amt > 0.1:
			player.camera.offset = Vector2(rng.randf_range(-shake_amt, shake_amt), rng.randf_range(-shake_amt, shake_amt))
		else:
			player.camera.offset = Vector2.ZERO


# ---------------------------------------------------------------------------
# Level up
# ---------------------------------------------------------------------------
func _open_levelup() -> void:
	state = State.LEVELUP
	get_tree().paused = true
	if autotest:
		while player.pending_levels > 0:
			current_cards = _build_cards()
			_apply_card(current_cards[0])
			player.pending_levels -= 1
		hud.refresh_build()
		state = State.PLAY
		get_tree().paused = false
		return
	current_cards = _build_cards()
	hud.show_levelup(current_cards)


func _apply_card(card: Dictionary) -> void:
	match card["kind"]:
		"weapon_new":
			player.add_weapon(card["id"])
		"weapon_up":
			player.upgrade_weapon(card["id"])
		"passive_new", "passive_up":
			player.add_passive(card["id"])
		"evolve":
			player.evolve(card["id"])
			hud.toast(card["title"].to_upper() + "!", 2.5)
		"heal":
			player.heal(30.0)


func card_picked(index: int) -> void:
	if state != State.LEVELUP:
		return
	if index < 0 or index >= current_cards.size():
		return
	_apply_card(current_cards[index])

	player.pending_levels = maxi(0, player.pending_levels - 1)
	hud.hide_levelup()
	hud.refresh_build()

	if player.pending_levels > 0:
		current_cards = _build_cards()
		hud.show_levelup(current_cards)
	else:
		state = State.PLAY
		get_tree().paused = false


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


# ---------------------------------------------------------------------------
# Mounds / interact
# ---------------------------------------------------------------------------
func mound_near_player() -> bool:
	if player == null:
		return false
	for m in mounds:
		if not m["used"] and player.position.distance_to(m["pos"]) < 30.0:
			return true
	return false


func _unhandled_input(event: InputEvent) -> void:
	if state == State.PLAY and event.is_action_pressed("interact"):
		_try_interact()


func _try_interact() -> void:
	if player == null:
		return
	for m in mounds:
		if m["used"]:
			continue
		if player.position.distance_to(m["pos"]) < 30.0:
			m["used"] = true
			player.grant_blessing()
			FXRef.text(fx_layer, m["pos"] + Vector2(0, -18), "RESPECT", Color("#9fd8e8"), 9)
			FXRef.burst(fx_layer, m["pos"], Color("#9fd8e8"), 8)
			hud.toast("+5% DAMAGE  (60s)", 2.0)
			var node = m["node"]
			if node != null and is_instance_valid(node):
				node.queue_free()
			return


# ---------------------------------------------------------------------------
# Save
# ---------------------------------------------------------------------------
func _load_save() -> void:
	if not FileAccess.file_exists("user://save.json"):
		return
	var f := FileAccess.open("user://save.json", FileAccess.READ)
	if f == null:
		return
	var parsed = JSON.parse_string(f.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		best_time = float(parsed.get("best", 0.0))
		wins = int(parsed.get("wins", 0))


func _save_progress() -> void:
	var f := FileAccess.open("user://save.json", FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify({"best": best_time, "wins": wins}))
