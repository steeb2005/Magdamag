extends Node2D
class_name Pickup

const FXRef = preload("res://src/fx.gd")
const TEX_KANDILA = preload("res://art/items/kandila.png")
const TEX_BARYA = preload("res://art/items/barya.png")

var main
var player
var kind := "kandila"
var t := 0.0
var sprite: Sprite2D


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = TEX_KANDILA if kind == "kandila" else TEX_BARYA
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)
	t = randf() * TAU


func _physics_process(delta: float) -> void:
	if main == null or player == null or not main.is_playing():
		return
	t += delta
	sprite.position.y = sin(t * 4.0) * 1.2
	var d: Vector2 = player.position - position
	if d.length() < player.pickup_radius:
		position += d.normalized() * 240.0 * delta
	if position.distance_to(player.position) < 12.0:
		if kind == "kandila":
			player.heal(25.0)
			FXRef.text(main.fx_layer, position, "+25", Color("#ffd27a"), 9)
		else:
			player.gold += 1
			FXRef.text(main.fx_layer, position, "+1", Color("#e8ba54"), 8)
		queue_free()
