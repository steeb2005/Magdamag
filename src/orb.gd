extends Node2D
class_name Orb

const TEX = preload("res://art/items/alab.png")
const DESPAWN_TIME = 25.0

var main
var player
var value := 1
var t := 0.0
var spawn_time := 0.0
var sprite: Sprite2D


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = TEX
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)
	t = randf() * TAU
	spawn_time = 0.0


func _physics_process(delta: float) -> void:
	if main == null or player == null or not main.is_playing():
		return
	spawn_time += delta
	if spawn_time >= DESPAWN_TIME:
		queue_free()
		return
	t += delta
	sprite.position.y = sin(t * 6.0) * 1.5
	var d: Vector2 = player.position - position
	var dist := d.length()
	if dist < player.pickup_radius:
		var spd: float = 90.0 + (player.pickup_radius - dist) * 7.0
		position += d.normalized() * minf(spd, 430.0) * delta
		if position.distance_to(player.position) < 10.0:
			player.add_xp(value)
			queue_free()
