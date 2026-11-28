extends Node2D
class_name Player

signal died

const DataRef = preload("res://src/data.gd")
const ProjectileScript = preload("res://src/projectile.gd")
const FXRef = preload("res://src/fx.gd")
const LIGHT_TEX = preload("res://art/fx/light.png")

var main
var char_id := "isko"
var char_data: Dictionary = {}

# --- stats -----------------------------------------------------------------
var base_hp := 160.0
var max_hp := 140.0
var hp := 140.0
var base_speed := 95.0
var speed := 95.0
var damage_mult := 1.0
var area_mult := 1.0
var cooldown_mult := 1.0
var crit_chance := 0.05
var crit_mult := 1.5
var pickup_radius := 60.0
var base_regen := 3.0
var regen := 3.0
var armor := 0.0
var aswang_bonus := 0.0
var heal_bonus := 1.0
var light_scale := 1.05

# --- run state -------------------------------------------------------------
var level := 1
var xp := 0
var xp_next := 6
var pending_levels := 0
var kills := 0
var gold := 0

var weapons: Array = []
var passives: Dictionary = {}

# --- movement --------------------------------------------------------------
var facing := Vector2.RIGHT
var move_input := Vector2.ZERO
var invuln := 0.0
var dash_cd := 0.0
var dash_t := 0.0
var dash_dir := Vector2.RIGHT
var hurt_flash := 0.0
var anim_t := 0.0
var walking := false
var swing_count := 0
var buff_damage := 0.0
var buff_time := 0.0
var aura_node: Node2D = null
var elapsed := 0.0

# --- nodes -----------------------------------------------------------------
var sprite: Sprite2D
var outline: Sprite2D
var light: PointLight2D
var camera: Camera2D


func _ready() -> void:
	z_index = 5

	outline = Sprite2D.new()
	outline.hframes = 4
	outline.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	outline.modulate = Color(0.04, 0.05, 0.08, 0.95)
	outline.scale = Vector2(1.08, 1.08)
	outline.z_index = -1
	add_child(outline)

	sprite = Sprite2D.new()
	sprite.hframes = 4
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)

	light = PointLight2D.new()
	light.texture = LIGHT_TEX
	light.color = Color(1.0, 0.86, 0.62)
	light.energy = 1.35
	light.texture_scale = light_scale
	light.z_index = -5
	add_child(light)

	var shadow := Sprite2D.new()
	shadow.texture = LIGHT_TEX
	shadow.modulate = Color(0.0, 0.0, 0.0, 0.34)
	shadow.scale = Vector2(0.26, 0.13)
	shadow.position = Vector2(0, 9)
	shadow.z_index = -9
	add_child(shadow)

	camera = Camera2D.new()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 9.0
	camera.limit_left = -1600
	camera.limit_top = -1600
	camera.limit_right = 1600
	camera.limit_bottom = 1600
	add_child(camera)


func setup(main_ref, id: String) -> void:
	main = main_ref
	char_id = id
	char_data = DataRef.CHARACTERS[id]
	base_hp = float(char_data["hp"])
	base_speed = float(char_data["speed"])
	max_hp = base_hp
	hp = max_hp
	sprite.texture = load(char_data["tex"])
	outline.texture = sprite.texture
	if id == "bining":
		heal_bonus = 1.25
	add_weapon(char_data["weapon"])
	recalc_stats()
	hp = max_hp


# ---------------------------------------------------------------------------
# Stats
# ---------------------------------------------------------------------------
func recalc_stats() -> void:
	var old_max := max_hp
	max_hp = base_hp + float(passives.get("agimat", 0)) * 15.0
	if max_hp > old_max:
		hp += max_hp - old_max
	hp = minf(hp, max_hp)

	speed = base_speed * (1.0 + float(passives.get("bakya", 0)) * 0.08)
	if char_id == "isko" and main != null and main.time >= 360.0:
		speed *= 1.08

	crit_chance = 0.05 + float(passives.get("singsing", 0)) * 0.07
	area_mult = 1.0 + float(passives.get("kandila", 0)) * 0.12
	var char_cd := 0.9 if char_id == "doring" else 1.0
	cooldown_mult = maxf(0.4, (1.0 - float(passives.get("pamaypay", 0)) * 0.07) * char_cd)
	pickup_radius = 60.0 + float(passives.get("bayong", 0)) * 30.0
	regen = base_regen + float(passives.get("tabo", 0)) * 0.6
	aswang_bonus = float(passives.get("kwintas", 0)) * 0.15
	armor = float(passives.get("salakot", 0)) * 1.0
	light_scale = 1.05 + float(passives.get("kandila", 0)) * 0.14
	if light != null:
		light.texture_scale = light_scale


func has_weapon(id: String) -> bool:
	for w in weapons:
		if w["id"] == id:
			return true
	return false


func get_weapon(id: String) -> Dictionary:
	for w in weapons:
		if w["id"] == id:
			return w
	return {}


func add_weapon(id: String) -> void:
	weapons.append({"id": id, "level": 1, "timer": 0.25, "evo": false})
	if id == "bawang" and aura_node == null:
		aura_node = FXRef.aura(self, 52.0 * area_mult)
	_update_aura()


func upgrade_weapon(id: String) -> void:
	var w := get_weapon(id)
	if not w.is_empty():
		w["level"] = int(w["level"]) + 1
	_update_aura()


func evolve(id: String) -> void:
	var w := get_weapon(id)
	if not w.is_empty():
		w["evo"] = true
		w["level"] = 8
	_update_aura()


func _update_aura() -> void:
	if aura_node == null:
		return
	var w := get_weapon("bawang")
	if w.is_empty():
		aura_node.visible = false
	else:
		aura_node.visible = true
		aura_node.set("radius", (50.0 + float(w["level"]) * 2.0) * area_mult)


func add_passive(id: String) -> void:
	passives[id] = int(passives.get(id, 0)) + 1
	recalc_stats()


func add_xp(v: int) -> void:
	xp += v
	while xp >= xp_next:
		xp -= xp_next
		level += 1
		xp_next = int(float(xp_next) * 1.22 + 4.0)
		pending_levels += 1


func heal(amount: float) -> void:
	hp = minf(max_hp, hp + amount * heal_bonus)


# ---------------------------------------------------------------------------
# Movement / timers
# ---------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if main == null or not main.is_playing():
		return

	elapsed += delta
	invuln = maxf(0.0, invuln - delta)
	dash_cd = maxf(0.0, dash_cd - delta)
	hurt_flash = maxf(0.0, hurt_flash - delta)
	if buff_time > 0.0:
		buff_time -= delta
		if buff_time <= 0.0:
			buff_damage = 0.0

	if regen > 0.0:
		hp = minf(max_hp, hp + regen * delta)

	move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if Input.is_action_just_pressed("dash") and dash_cd <= 0.0 and dash_t <= 0.0:
		dash_t = 0.12
		dash_cd = 2.5
		dash_dir = facing
		invuln = maxf(invuln, 0.3)
		FXRef.burst(get_parent(), position, Color("#9fd8e8"), 4)

	if dash_t > 0.0:
		dash_t -= delta
		position += dash_dir * 320.0 * delta
		walking = true
	elif move_input.length() > 0.05:
		facing = move_input.normalized()
		position += move_input * speed * delta
		walking = true
	else:
		walking = false

	position.x = clampf(position.x, -1500.0, 1500.0)
	position.y = clampf(position.y, -1500.0, 1500.0)

	_animate(delta)
	_tick_weapons(delta)


func _animate(delta: float) -> void:
	anim_t += delta * (9.0 if walking else 2.0)
	sprite.frame = int(anim_t) % 4 if walking else 0
	outline.frame = sprite.frame
	if absf(facing.x) > 0.15:
		sprite.flip_h = facing.x < 0.0
		outline.flip_h = sprite.flip_h

	if hurt_flash > 0.0:
		sprite.modulate = Color(2.2, 0.75, 0.75)
	else:
		sprite.modulate = Color(1.14, 1.12, 1.06)

	if light != null:
		light.energy = 1.33 + sin(elapsed * 7.0) * 0.04


func _tick_weapons(delta: float) -> void:
	for w in weapons:
		w["timer"] = float(w["timer"]) - delta
		if float(w["timer"]) <= 0.0:
			_fire(w)
			var base_cd := float(DataRef.WEAPONS[w["id"]]["cd"])
			if w["evo"]:
				base_cd *= 0.9
			w["timer"] = base_cd * cooldown_mult


# ---------------------------------------------------------------------------
# Weapons
# ---------------------------------------------------------------------------
func _fire(w: Dictionary) -> void:
	var id: String = w["id"]
	var lvl: int = int(w["level"])
	var evo: bool = bool(w["evo"])
	var base_dmg := float(DataRef.WEAPONS[id]["dmg"]) * (1.0 + 0.22 * float(lvl - 1))
	match id:
		"itak":
			swing_count += 1
			if evo and swing_count % 3 == 0:
				FXRef.slash(get_parent(), global_position, facing, 52.0 * area_mult, 360.0)
				_melee(Vector2.RIGHT, 52.0 * area_mult, 360.0, base_dmg, 120.0, 0.0, {})
			else:
				var dir := facing.rotated(randf_range(-0.22, 0.22))
				FXRef.slash(get_parent(), global_position, dir, 46.0 * area_mult, 110.0)
				_melee(dir, 46.0 * area_mult, 110.0, base_dmg, 100.0, 0.0, {})
		"balisong":
			var stabs := 3 + int(lvl / 3)
			var hit := {}
			for i in stabs:
				var dir := facing.rotated(randf_range(-0.20, 0.20))
				FXRef.slash(get_parent(), global_position, dir, 28.0 * area_mult, 70.0, Color("#dfe8e6"))
				_melee(dir, 28.0 * area_mult, 70.0, base_dmg, 24.0, 0.0, hit)
		"yantok":
			var hit2 := {}
			FXRef.slash(get_parent(), global_position, facing, 42.0 * area_mult, 120.0, Color("#e8d8b0"))
			_melee(facing, 42.0 * area_mult, 120.0, base_dmg, 70.0, 0.15, hit2)
			FXRef.slash(get_parent(), global_position, -facing, 42.0 * area_mult, 120.0, Color("#e8d8b0"))
			_melee(-facing, 42.0 * area_mult, 120.0, base_dmg, 70.0, 0.15, hit2)
		"sumpit":
			var p = ProjectileScript.new()
			p.mode = "linear"
			p.position = global_position
			p.vel = facing * 300.0
			p.damage = base_dmg * damage_mult * (1.0 + buff_damage)
			p.crit_chance = crit_chance
			p.crit_mult = crit_mult
			p.aswang_bonus = aswang_bonus
			p.pierce = 99 if evo else 3 + int(lvl / 3)
			p.radius = 4.0
			p.life = 0.8
			p.color = Color("#b7e07a")
			p.size = 3.0
			p.poison_dps = 3.0 + float(lvl)
			p.poison_time = 3.0
			main.add_projectile(p)
		"banga":
			var target = _nearest_enemy(260.0)
			var dest: Vector2 = target.position if target != null else global_position + facing * 140.0
			var p = ProjectileScript.new()
			p.mode = "lob"
			p.position = global_position
			p.start_pos = global_position
			p.target_pos = dest
			p.duration = maxf(0.25, global_position.distance_to(dest) / 320.0)
			p.damage = base_dmg * damage_mult * (1.0 + buff_damage)
			p.crit_chance = crit_chance
			p.crit_mult = crit_mult
			p.aswang_bonus = aswang_bonus
			p.aoe = 34.0 * area_mult
			p.color = Color("#c98a5e")
			p.size = 5.0
			p.texture_path = "res://art/icons/banga.png"
			main.add_projectile(p)
		"bawang":
			var radius := (50.0 + float(lvl) * 2.0) * area_mult
			if aura_node != null:
				aura_node.set("radius", radius)
			for e in main.enemies:
				if e.dead:
					continue
				if global_position.distance_to(e.position) <= radius + e.radius:
					var bonus := 1.5 if "aswang" in e.tags else 1.0
					_deal(e, base_dmg * bonus, 30.0, 0.0)
		"tsinelas":
			var angles: Array = [0.0]
			if evo:
				angles = [-0.35, 0.0, 0.35]
			for a in angles:
				var dir := facing.rotated(a)
				var target = _nearest_enemy(240.0)
				if target != null:
					dir = (target.position - global_position).normalized().rotated(a)
				var p = ProjectileScript.new()
				p.mode = "boomerang"
				p.position = global_position
				p.vel = dir * 260.0
				p.damage = base_dmg * damage_mult * (1.0 + buff_damage)
				p.crit_chance = crit_chance
				p.crit_mult = crit_mult
				p.aswang_bonus = aswang_bonus
				p.pierce = 99
				p.radius = 7.0
				p.life = 2.0
				p.knock = 130.0
				p.texture_path = "res://art/icons/tsinelas.png"
				p.spin = 12.0
				main.add_projectile(p)
		"kulintang":
			var radius := (80.0 + float(lvl) * 2.0) * area_mult
			FXRef.ring(get_parent(), global_position, radius, Color("#ffd27a"), 0.4)
			FXRef.burst(get_parent(), global_position, Color("#ffd27a"), 6)
			for e in main.enemies:
				if e.dead:
					continue
				if global_position.distance_to(e.position) <= radius + e.radius:
					_deal(e, base_dmg, 40.0, 0.35)
		# --- Pana (bow): spread of 2 arrows, pierce 1 ---
		"pana":
			var proj_count := 1 + int(evo)
			var spread := 0.35
			for i in proj_count:
				var dir := facing.rotated((float(i) - 0.5) * spread)
				var p = ProjectileScript.new()
				p.mode = "linear"
				p.position = global_position
				p.vel = dir * 320.0
				p.damage = base_dmg * damage_mult * (1.0 + buff_damage)
				p.crit_chance = crit_chance
				p.crit_mult = crit_mult
				p.aswang_bonus = aswang_bonus
				p.pierce = 3 if evo else 1
				p.radius = 4.0
				p.life = 1.0
				p.color = Color("#b7e07a")
				p.size = 3.0
				p.homing = evo
				p.texture_path = "res://art/icons/pana.png"
				main.add_projectile(p)

		# --- Sulo (torch): leaves a short fire trail behind you ---
		"sulo":
			var trail_dir := -facing
			var p = ProjectileScript.new()
			p.mode = "linear"
			p.position = global_position + trail_dir * 12.0
			p.vel = trail_dir * 60.0
			p.damage = base_dmg * damage_mult * (1.0 + buff_damage)
			p.crit_chance = crit_chance
			p.crit_mult = crit_mult
			p.aswang_bonus = aswang_bonus
			p.pierce = 99
			p.radius = 6.0
			p.life = 1.5
			p.color = Color("#ff8a4d")
			p.size = 4.0
			p.texture_path = "res://art/icons/sulo.png"
			main.add_projectile(p)

		# --- Yoyo (orbit/return): loops out and back, hits on both passes ---
		"yoyo":
			var angles: Array = [0.0]
			if evo:
				angles = [-0.5, 0.5]
			for a in angles:
				var dir := facing.rotated(a)
				var p = ProjectileScript.new()
				p.mode = "boomerang"
				p.position = global_position
				p.vel = dir * 300.0
				p.damage = base_dmg * damage_mult * (1.0 + buff_damage)
				p.crit_chance = crit_chance
				p.crit_mult = crit_mult
				p.aswang_bonus = aswang_bonus
				p.pierce = 99
				p.radius = 6.0
				p.life = 1.2
				p.knock = 80.0
				p.texture_path = "res://art/icons/yoyo.png"
				p.spin = 10.0
				main.add_projectile(p)

		# --- Sibat (spear): thrust pierces a line, small forward step ---
		"sibat":
			position += facing * 24.0
			var hit3 := {}
			FXRef.slash(get_parent(), global_position, facing, 34.0 * area_mult, 60.0, Color("#cfe4ec"))
			_melee(facing, 34.0 * area_mult, 60.0, base_dmg, 60.0, 0.0, hit3)

		# --- Lantaka (bamboo cannon): slow shell, big AoE ---
		"lantaka":
			var target = _nearest_enemy(400.0)
			var dest = target.position if target != null else global_position + facing * 260.0
			var p = ProjectileScript.new()
			p.mode = "lob"
			p.position = global_position
			p.start_pos = global_position
			p.target_pos = dest
			p.duration = maxf(0.6, global_position.distance_to(dest) / 200.0)
			p.damage = base_dmg * damage_mult * (1.0 + buff_damage)
			p.crit_chance = crit_chance
			p.crit_mult = crit_mult
			p.aswang_bonus = aswang_bonus
			p.aoe = 60.0 * area_mult
			p.color = Color("#7a5a36")
			p.size = 8.0
			p.texture_path = "res://art/icons/lantaka.png"
			main.add_projectile(p)

		# --- Kalabaw (carabao): summon charges across screen, trampling a line ---
		"kalabaw":
			var charge_count := 1
			if evo:
				charge_count = 2
			for c in charge_count:
				var offset := c * 0.3 - 0.15
				var dir := facing.rotated(offset)
				var p = ProjectileScript.new()
				p.mode = "linear"
				p.position = global_position
				p.vel = dir * 420.0
				p.damage = base_dmg * damage_mult * (1.0 + buff_damage)
				p.crit_chance = crit_chance
				p.crit_mult = crit_mult
				p.aswang_bonus = aswang_bonus
				p.pierce = 99
				p.radius = 10.0
				p.life = 1.0
				p.knock = 200.0
				p.color = Color("#8b6b4a")
				p.size = 10.0
				p.texture_path = "res://art/icons/kalabaw.png"
				main.add_projectile(p)


func _melee(dir: Vector2, radius: float, arc: float, dmg: float, knock: float, stun: float, hit_set: Dictionary) -> void:
	var half := deg_to_rad(arc * 0.5)
	for e in main.enemies:
		if e.dead or hit_set.has(e):
			continue
		var d: Vector2 = e.position - global_position
		if d.length() > radius + e.radius:
			continue
		if arc < 359.0 and absf(dir.angle_to(d)) > half:
			continue
		_deal(e, dmg, knock, stun)
		hit_set[e] = true


func _deal(e, base: float, knock: float, stun: float) -> void:
	var crit := randf() < crit_chance
	var dmg := base * damage_mult * (1.0 + buff_damage)
	if "aswang" in e.tags:
		dmg *= 1.0 + aswang_bonus
	if crit:
		dmg *= crit_mult
	main.hit_enemy(e, dmg, global_position, knock, crit, stun)


func _nearest_enemy(max_dist: float):
	var best = null
	var best_d := max_dist
	for e in main.enemies:
		if e.dead:
			continue
		var d: float = global_position.distance_to(e.position)
		if d < best_d:
			best_d = d
			best = e
	return best


# ---------------------------------------------------------------------------
# Damage
# ---------------------------------------------------------------------------
func take_damage(amount: float) -> void:
	if main != null and main.god:
		return
	if invuln > 0.0 or hp <= 0.0:
		return
	hp -= maxf(1.0, amount - armor)
	invuln = 0.8
	hurt_flash = 0.18
	if hp <= 0.0:
		hp = 0.0
		died.emit()


func grant_blessing() -> void:
	buff_damage = 0.05
	buff_time = 60.0
