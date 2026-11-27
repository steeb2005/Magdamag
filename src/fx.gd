extends RefCounted
class_name FX

# ---------------------------------------------------------------------------
# Floating damage numbers
# ---------------------------------------------------------------------------
static func number(parent: Node, pos: Vector2, amount: int, crit: bool) -> void:
	var l := Label.new()
	l.text = str(amount)
	l.add_theme_font_size_override("font_size", 10 if crit else 8)
	l.add_theme_color_override("font_color", Color("#ffd27a") if crit else Color("#efe9d8"))
	l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("shadow_offset_x", 1)
	l.add_theme_constant_override("shadow_offset_y", 1)
	l.z_index = 120
	parent.add_child(l)
	l.position = pos + Vector2(randf_range(-4.0, 4.0), -6.0)
	var tw := l.create_tween()
	tw.set_parallel(true)
	tw.tween_property(l, "position:y", l.position.y - 16.0, 0.5)
	tw.tween_property(l, "modulate:a", 0.0, 0.5)
	tw.set_parallel(false)
	tw.tween_callback(l.queue_free)


static func text(parent: Node, pos: Vector2, msg: String, col := Color("#ffd27a"), size := 10) -> void:
	var l := Label.new()
	l.text = msg
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	l.add_theme_constant_override("shadow_offset_x", 1)
	l.add_theme_constant_override("shadow_offset_y", 1)
	l.z_index = 130
	parent.add_child(l)
	l.position = pos + Vector2(-20.0, -4.0)
	var tw := l.create_tween()
	tw.set_parallel(true)
	tw.tween_property(l, "position:y", l.position.y - 14.0, 0.9)
	tw.tween_property(l, "modulate:a", 0.0, 0.9)
	tw.set_parallel(false)
	tw.tween_callback(l.queue_free)


# ---------------------------------------------------------------------------
# Melee slash arc
# ---------------------------------------------------------------------------
static func slash(parent: Node, pos: Vector2, dir: Vector2, radius: float, arc: float, col := Color(1.0, 0.95, 0.8, 0.95)) -> void:
	var s := Slash.new()
	s.dir = dir
	s.radius = radius
	s.arc = arc
	s.col = col
	s.position = pos
	parent.add_child(s)


class Slash extends Node2D:
	var dir := Vector2.RIGHT
	var radius := 40.0
	var arc := 110.0
	var col := Color(1.0, 0.95, 0.8, 0.95)
	var life := 0.16
	var t := 0.0

	func _process(delta: float) -> void:
		t += delta
		if t >= life:
			queue_free()
			return
		queue_redraw()

	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var a: float = 1.0 - k
		var start := dir.angle() - deg_to_rad(arc * 0.5)
		var end := dir.angle() + deg_to_rad(arc * 0.5)
		draw_arc(Vector2.ZERO, radius * (0.75 + 0.25 * k), start, end, 20,
			Color(col.r, col.g, col.b, a * 0.9), 2.0)
		draw_arc(Vector2.ZERO, radius * (0.5 + 0.2 * k), start, end, 16,
			Color(col.r, col.g, col.b, a * 0.45), 1.0)


# ---------------------------------------------------------------------------
# Expanding ring (Kulintang, stomps)
# ---------------------------------------------------------------------------
static func ring(parent: Node, pos: Vector2, radius: float, col := Color("#ffd27a"), life := 0.35) -> void:
	var r := Ring.new()
	r.radius = radius
	r.col = col
	r.life = life
	r.position = pos
	parent.add_child(r)


class Ring extends Node2D:
	var radius := 80.0
	var col := Color("#ffd27a")
	var life := 0.35
	var t := 0.0

	func _process(delta: float) -> void:
		t += delta
		if t >= life:
			queue_free()
			return
		queue_redraw()

	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var a: float = 1.0 - k
		draw_arc(Vector2.ZERO, radius * k, 0.0, TAU, 40, Color(col.r, col.g, col.b, a), 2.0)
		draw_arc(Vector2.ZERO, radius * k * 0.85, 0.0, TAU, 32, Color(col.r, col.g, col.b, a * 0.4), 1.0)


# ---------------------------------------------------------------------------
# Death burst
# ---------------------------------------------------------------------------
static func burst(parent: Node, pos: Vector2, col := Color("#c8b273"), count := 6) -> void:
	var b := Burst.new()
	b.position = pos
	b.setup_burst(col, count)
	parent.add_child(b)


class Burst extends Node2D:
	var col := Color("#c8b273")
	var life := 0.4
	var t := 0.0
	var pts: Array[Vector2] = []
	var vels: Array[Vector2] = []

	func setup_burst(c: Color, n: int) -> void:
		col = c
		for i in n:
			var a := randf() * TAU
			var s := randf_range(24.0, 80.0)
			pts.append(Vector2.ZERO)
			vels.append(Vector2(cos(a), sin(a)) * s)

	func _process(delta: float) -> void:
		t += delta
		for i in pts.size():
			pts[i] += vels[i] * delta
			vels[i] *= 0.9
		if t >= life:
			queue_free()
			return
		queue_redraw()

	func _draw() -> void:
		var a: float = 1.0 - clampf(t / life, 0.0, 1.0)
		for p in pts:
			draw_rect(Rect2(p - Vector2(1, 1), Vector2(2, 2)), Color(col.r, col.g, col.b, a))


static func explosion(parent: Node, pos: Vector2, radius: float) -> void:
	ring(parent, pos, radius, Color("#ff9a4d"), 0.3)
	burst(parent, pos, Color("#ffb347"), 8)


# ---------------------------------------------------------------------------
# Persistent garlic aura (parented to the player)
# ---------------------------------------------------------------------------
static func aura(parent: Node, radius: float) -> Node2D:
	var a := Aura.new()
	a.radius = radius
	parent.add_child(a)
	return a


class Aura extends Node2D:
	var radius := 52.0
	var col := Color(0.86, 0.92, 0.62, 0.10)
	var t := 0.0

	func _process(delta: float) -> void:
		t += delta
		queue_redraw()

	func _draw() -> void:
		var pulse: float = 0.75 + 0.25 * sin(t * 4.0)
		draw_circle(Vector2.ZERO, radius, Color(col.r, col.g, col.b, col.a * pulse))
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 40, Color(col.r, col.g, col.b, 0.30), 1.0)
