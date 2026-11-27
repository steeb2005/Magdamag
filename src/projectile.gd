extends Node2D
class_name Projectile

const FXRef = preload("res://src/fx.gd")

var main
var mode := "linear"
var vel := Vector2.ZERO
var damage := 10.0
var pierce := 1
var radius := 4.0
var life := 3.0
var hostile := false
var poison_dps := 0.0
var poison_time := 0.0
var knock := 0.0
var crit_chance := 0.0
var crit_mult := 1.5
var aswang_bonus := 0.0

var hit: Dictionary = {}
var texture_path := ""
var sprite: Sprite2D = null
var color := Color("#ffd27a")
var size := 4.0
var spin := 0.0

var t := 0.0
var duration := 0.5
var start_pos := Vector2.ZERO
var target_pos := Vector2.ZERO
var aoe := 0.0


func _ready() -> void:
	if texture_path != "":
		sprite = Sprite2D.new()
		sprite.texture = load(texture_path)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(sprite)


func _physics_process(delta: float) -> void:
	if main == null or not main.is_playing():
		return

	t += delta
	life -= delta

	if hostile:
		position += vel * delta
		if position.distance_to(main.player.position) < radius + 10.0:
			main.player.take_damage(damage)
			queue_free()
			return
		if life <= 0.0:
			queue_free()
		return

	match mode:
		"lob":
			var k: float = clampf(t / duration, 0.0, 1.0)
			position = start_pos.lerp(target_pos, k)
			if sprite != null:
				sprite.position.y = -sin(k * PI) * 28.0
				sprite.rotation += 6.0 * delta
			if k >= 1.0:
				_explode()
				return
		"boomerang":
			if t < 0.28:
				position += vel * delta
			else:
				var to_p: Vector2 = main.player.position - position
				if to_p.length() < 14.0 or life <= 0.0:
					queue_free()
					return
				position += to_p.normalized() * 330.0 * delta
			if sprite != null:
				sprite.rotation += spin * delta
			_check_hits()
			if life <= 0.0:
				queue_free()
		_:
			position += vel * delta
			_check_hits()
			if life <= 0.0:
				queue_free()


func _check_hits() -> void:
	for e in main.enemies:
		if e.dead or hit.has(e):
			continue
		if position.distance_to(e.position) > radius + e.radius:
			continue
		hit[e] = true
		var dmg := damage
		if "aswang" in e.tags:
			dmg *= 1.0 + aswang_bonus
		var crit := randf() < crit_chance
		if crit:
			dmg *= crit_mult
		main.hit_enemy(e, dmg, position, knock, crit, 0.0)
		if poison_dps > 0.0:
			e.poison_dps = maxf(e.poison_dps, poison_dps)
			e.poison_t = maxf(e.poison_t, poison_time)
		pierce -= 1
		if pierce <= 0:
			queue_free()
			return


func _explode() -> void:
	FXRef.explosion(main.fx_layer, position, aoe)
	for e in main.enemies:
		if e.dead:
			continue
		if position.distance_to(e.position) <= aoe + e.radius:
			var dmg := damage
			if "aswang" in e.tags:
				dmg *= 1.0 + aswang_bonus
			var crit := randf() < crit_chance
			if crit:
				dmg *= crit_mult
			main.hit_enemy(e, dmg, position, knock, crit, 0.0)
	queue_free()


func _draw() -> void:
	if sprite != null:
		return
	draw_circle(Vector2.ZERO, size, color)
	draw_circle(Vector2.ZERO, maxf(1.0, size - 1.5), Color(1, 1, 1, 0.55))
