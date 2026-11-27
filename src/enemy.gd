extends Node2D
class_name Enemy

const DataRef = preload("res://src/data.gd")
const ProjectileScript = preload("res://src/projectile.gd")
const FXRef = preload("res://src/fx.gd")

var main
var id := "tiktik"
var data: Dictionary = {}
var display_name := ""
var hp := 10.0
var max_hp := 10.0
var speed := 60.0
var damage := 5.0
var radius := 7.0
var xp_value := 1
var tags: Array = []
var behavior := "chase"
var is_boss := false
var elite := false
var dead := false

var sprite: Sprite2D
var anim_t := 0.0
var flash := 0.0
var knock := Vector2.ZERO
var stun := 0.0
var attack_cd := 0.0
var poison_dps := 0.0
var poison_t := 0.0
var state_t := 0.0
var lunge_t := 0.0
var lunge_dir := Vector2.ZERO
var throw_cd := 2.0
var stomp_cd := 5.0
var shoot_cd := 2.0
var charge_cd := 6.0
var charge_t := 0.0
var charge_dir := Vector2.ZERO
var wobble := 0.0


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.hframes = 2
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)


func setup(main_ref, enemy_id: String, make_elite: bool) -> void:
	main = main_ref
	id = enemy_id
	data = DataRef.ENEMIES[id]
	display_name = data["name"]
	tags = data["tags"]
	behavior = data["behavior"]
	is_boss = bool(data.get("boss", false))
	elite = make_elite and not is_boss

	hp = float(data["hp"]) * main.enemy_hp_mult()
	speed = float(data["speed"])
	damage = float(data["dmg"]) * main.enemy_dmg_mult()
	radius = float(data["radius"])
	xp_value = int(data["xp"])

	if elite:
		hp *= 2.2
		damage *= 1.3
		xp_value *= 4
		radius *= 1.15

	max_hp = hp
	sprite.texture = load(data["tex"])
	sprite.scale = Vector2.ONE * (1.3 if elite else 1.0)
	anim_t = randf() * 2.0
	state_t = randf() * 3.0
	throw_cd = randf_range(1.2, 2.2)
	stomp_cd = randf_range(4.0, 6.0)
	shoot_cd = randf_range(1.0, 2.0)
	charge_cd = randf_range(5.0, 7.0)


# ---------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if main == null or not main.is_playing() or dead:
		return

	state_t += delta
	flash = maxf(0.0, flash - delta)
	attack_cd = maxf(0.0, attack_cd - delta)
	anim_t += delta

	if poison_t > 0.0:
		poison_t -= delta
		hp -= poison_dps * delta
		if hp <= 0.0:
			die()
			return

	if stun > 0.0:
		stun -= delta
	else:
		_think(delta)

	if knock.length() > 1.0:
		position += knock * delta
		knock = knock.move_toward(Vector2.ZERO, 760.0 * delta)

	_animate()
	_touch_player()


func _think(delta: float) -> void:
	var to_player: Vector2 = main.player.position - position
	var dist := to_player.length()
	var dir := to_player / maxf(dist, 0.001)

	match behavior:
		"chase":
			wobble += delta * 6.0
			var side := Vector2(-dir.y, dir.x) * sin(wobble) * 0.18
			_move(dir + side, speed, delta)
		"tank":
			_move(dir, speed, delta)
		"lunge":
			if lunge_t > 0.0:
				lunge_t -= delta
				_move(lunge_dir, speed * 3.4, delta)
			elif dist < 110.0 and attack_cd <= 0.0:
				lunge_t = 0.24
				lunge_dir = dir
				attack_cd = 1.8
			else:
				_move(dir, speed, delta)
		"phase":
			sprite.modulate.a = 0.3 + 0.7 * (0.5 + 0.5 * sin(state_t * 1.6))
			if state_t > 3.2:
				state_t = 0.0
				FXRef.burst(main.fx_layer, position, Color("#cfe4ec"), 6)
				var ang := randf() * TAU
				position = main.player.position + Vector2(cos(ang), sin(ang)) * randf_range(70.0, 110.0)
				FXRef.burst(main.fx_layer, position, Color("#cfe4ec"), 6)
			_move(dir, speed, delta)
		"boss_kapre":
			_move(dir, speed, delta)
			throw_cd -= delta
			stomp_cd -= delta
			if throw_cd <= 0.0:
				throw_cd = 2.6
				var aim: Vector2 = (main.player.position - position).normalized()
				main.spawn_hostile_projectile(position + Vector2(0, -12), aim * 150.0, damage * 0.7, Color("#7a5a36"), 6.0)
			if stomp_cd <= 0.0 and dist < 130.0:
				stomp_cd = 6.5
				FXRef.ring(main.fx_layer, position, 120.0, Color("#ffb347"), 0.35)
				main.shake(6.0)
				if dist < 120.0:
					main.player.take_damage(damage)
		"boss_bakunawa":
			shoot_cd -= delta
			charge_cd -= delta
			if charge_t > 0.0:
				charge_t -= delta
				_move(charge_dir, 360.0, delta)
			elif charge_cd <= 0.0:
				charge_cd = 8.0
				charge_t = 0.5
				charge_dir = dir
				FXRef.ring(main.fx_layer, position, 70.0, Color("#9fd8e8"), 0.5)
			else:
				var desired := 210.0
				var perp := Vector2(-dir.y, dir.x)
				var adjust := (dist - desired) * 0.006
				_move(perp + dir * adjust, speed, delta)
			if shoot_cd <= 0.0:
				shoot_cd = 2.3
				for i in 5:
					var a := -0.5 + float(i) * 0.25
					main.spawn_hostile_projectile(position, dir.rotated(a) * 150.0, damage * 0.55, Color("#ff8a4d"), 5.0)
		_:
			_move(dir, speed, delta)


func _move(dir: Vector2, spd: float, delta: float) -> void:
	var push := Vector2.ZERO
	if not is_boss:
		var neigh: Array = main.get_neighbors(position)
		for o in neigh:
			if o == self or o.dead:
				continue
			var d: Vector2 = position - o.position
			var l := d.length()
			if l > 0.01 and l < 13.0:
				push += d / l * (13.0 - l)
	position += (dir * spd + push * 6.0) * delta
	position.x = clampf(position.x, -1520.0, 1520.0)
	position.y = clampf(position.y, -1520.0, 1520.0)


func _animate() -> void:
	sprite.frame = int(anim_t * 6.0) % 2
	sprite.flip_h = main.player.position.x < position.x
	var mod := Color.WHITE
	if poison_t > 0.0:
		mod = Color(0.7, 1.25, 0.7)
	if flash > 0.0:
		mod = Color(2.4, 2.4, 2.4)
	if id == "white_lady":
		mod.a = 0.3 + 0.7 * (0.5 + 0.5 * sin(state_t * 1.6))
	sprite.modulate = mod


func _touch_player() -> void:
	if attack_cd > 0.0:
		return
	var d: float = position.distance_to(main.player.position)
	if d < radius + 12.0:
		attack_cd = 0.9
		main.player.take_damage(damage)


# ---------------------------------------------------------------------------
func take_damage(amount: float, from: Vector2, force: float, crit: bool, stun_amt: float) -> void:
	if dead:
		return
	hp -= amount
	flash = 0.08
	if stun_amt > 0.0:
		stun = maxf(stun, stun_amt)
	if force > 0.0:
		var dir: Vector2 = position - from
		if dir.length() < 0.01:
			dir = Vector2.RIGHT
		var resist := 0.4 if behavior == "tank" or is_boss else 1.0
		knock += dir.normalized() * force * resist
	FXRef.number(main.fx_layer, position + Vector2(0, -radius - 6.0), int(round(amount)), crit)
	if hp <= 0.0:
		die()


func die() -> void:
	if dead:
		return
	dead = true
	FXRef.burst(main.fx_layer, position, Color("#8b1e1e") if "aswang" in tags else Color("#c8b273"), 8 if not is_boss else 24)
	if is_boss:
		main.shake(10.0)
	main.on_enemy_died(self)
	queue_free()
