extends CanvasLayer
class_name HUD

const DataRef = preload("res://src/data.gd")

var main
var root: Control
var menu: Control
var game: Control
var levelup: Control
var pause_menu: Control
var end_screen: Control

var hp_fill: ColorRect
var xp_fill: ColorRect
var timer_label: Label
var act_label: Label
var level_label: Label
var kill_label: Label
var gold_label: Label
var toast_label: Label
var hint_label: Label
var weapon_row: HBoxContainer
var passive_row: HBoxContainer
var boss_bar_bg: ColorRect
var boss_bar_fill: ColorRect
var boss_name: Label

var selected_char := 0
var char_cards: Array = []
var card_row: HBoxContainer
var end_title: Label
var end_stats: Label
var best_label: Label

var toast_tween: Tween


func setup(main_ref) -> void:
	main = main_ref
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_root()
	_build_menu()
	_build_game()
	_build_levelup()
	_build_pause()
	_build_end()
	show_menu(0.0, 0)


# ---------------------------------------------------------------------------
# Style helpers
# ---------------------------------------------------------------------------
func _panel_style(bg := Color("#12141f"), border := Color("#3a3f55"), bw := 1) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(2)
	s.content_margin_left = 8.0
	s.content_margin_right = 8.0
	s.content_margin_top = 6.0
	s.content_margin_bottom = 6.0
	return s


func _label(text: String, size: int, col := Color("#e8e2d0")) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("shadow_offset_x", 1)
	l.add_theme_constant_override("shadow_offset_y", 1)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


func _button(text: String, size := 10, focusable := true) -> Button:
	var b := Button.new()
	b.text = text
	b.add_theme_font_size_override("font_size", size)
	b.add_theme_color_override("font_color", Color("#e8e2d0"))
	b.add_theme_color_override("font_hover_color", Color("#ffd27a"))
	b.add_theme_color_override("font_pressed_color", Color("#ffd27a"))
	b.add_theme_stylebox_override("normal", _panel_style(Color("#161a28"), Color("#3a3f55")))
	b.add_theme_stylebox_override("hover", _panel_style(Color("#1e2335"), Color("#c8b273")))
	b.add_theme_stylebox_override("pressed", _panel_style(Color("#2a2030"), Color("#ffd27a")))
	b.add_theme_stylebox_override("focus", _panel_style(Color("#1e2335"), Color("#ffd27a"), 2))
	b.focus_mode = Control.FOCUS_ALL if focusable else Control.FOCUS_NONE
	return b


func _full(c: Control) -> void:
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.offset_left = 0
	c.offset_top = 0
	c.offset_right = 0
	c.offset_bottom = 0


func _dim(alpha: float, parent: Control) -> ColorRect:
	var d := ColorRect.new()
	d.color = Color(0.03, 0.035, 0.06, alpha)
	d.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(d)
	_full(d)
	return d


func _portrait(tex_path: String, px := 48) -> TextureRect:
	var t := TextureRect.new()
	var atlas := AtlasTexture.new()
	atlas.atlas = load(tex_path)
	atlas.region = Rect2(0, 0, 24, 24)
	t.texture = atlas
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = Vector2(px, px)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t


# ---------------------------------------------------------------------------
# Build UI
# ---------------------------------------------------------------------------
func _build_root() -> void:
	root = Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	_full(root)


func _build_menu() -> void:
	menu = Control.new()
	root.add_child(menu)
	_full(menu)

	var bg := ColorRect.new()
	bg.color = Color("#0b0d15")
	menu.add_child(bg)
	_full(bg)

	# decorative balete silhouette
	var tree := TextureRect.new()
	tree.texture = load("res://art/env/balete_0.png")
	tree.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tree.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tree.modulate = Color(0.55, 0.65, 0.7, 0.22)
	tree.position = Vector2(478, 118)
	tree.size = Vector2(150, 190)
	tree.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu.add_child(tree)

	var title := _label("NIGHT OF THE SIGBIN", 32, Color("#ffd27a"))
	title.size = Vector2(640, 42)
	title.position = Vector2(0, 30)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu.add_child(title)

	var sub := _label("The gubat is emptying out. Survive until dawn.", 10, Color("#9fd8e8"))
	sub.size = Vector2(640, 16)
	sub.position = Vector2(0, 70)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu.add_child(sub)

	for i in DataRef.CHAR_ORDER.size():
		var id: String = DataRef.CHAR_ORDER[i]
		var cd: Dictionary = DataRef.CHARACTERS[id]
		var card := Button.new()
		card.position = Vector2(52.0 + float(i) * 180.0, 104.0)
		card.size = Vector2(172, 132)
		card.focus_mode = Control.FOCUS_ALL
		card.add_theme_stylebox_override("normal", _panel_style(Color("#11141f"), Color("#3a3f55"), 1))
		card.add_theme_stylebox_override("hover", _panel_style(Color("#181d2c"), Color("#c8b273"), 2))
		card.add_theme_stylebox_override("pressed", _panel_style(Color("#181d2c"), Color("#ffd27a"), 2))
		card.add_theme_stylebox_override("focus", _panel_style(Color("#181d2c"), Color("#ffd27a"), 2))
		menu.add_child(card)

		var box := VBoxContainer.new()
		box.set_anchors_preset(Control.PRESET_FULL_RECT)
		box.offset_left = 6
		box.offset_top = 6
		box.offset_right = -6
		box.offset_bottom = -6
		box.add_theme_constant_override("separation", 2)
		box.alignment = BoxContainer.ALIGNMENT_CENTER
		box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(box)

		box.add_child(_portrait(cd["tex"], 44))
		var nm := _label(cd["name"], 10, Color("#e8e2d0"))
		nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(nm)
		var ti := _label(cd["title"], 8, Color("#9fd8e8"))
		ti.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(ti)
		var wp: Dictionary = DataRef.WEAPONS[cd["weapon"]]
		var wl := _label("Starts: " + str(wp["name"]), 8, Color("#c8b273"))
		wl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(wl)
		var pk := _label(cd["perk"], 7, Color("#8f96a8"))
		pk.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		pk.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(pk)

		card.pressed.connect(_select_char.bind(i))
		char_cards.append(card)

	var start := _button("SIMULAN", 12)
	start.position = Vector2(250, 252)
	start.size = Vector2(140, 32)
	start.pressed.connect(func(): main.start_run(DataRef.CHAR_ORDER[selected_char]))
	menu.add_child(start)

	var controls := _label("WASD / LEFT STICK  move      SPACE / A  dash      E / X  tabi-tabi po      ESC  pause", 8, Color("#7c8398"))
	controls.size = Vector2(640, 14)
	controls.position = Vector2(0, 296)
	controls.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu.add_child(controls)

	best_label = _label("", 8, Color("#c8b273"))
	best_label.size = Vector2(640, 14)
	best_label.position = Vector2(0, 314)
	best_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu.add_child(best_label)

	var ver := _label("prototype v0.1", 7, Color("#4a5064"))
	ver.size = Vector2(120, 12)
	ver.position = Vector2(512, 344)
	ver.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	menu.add_child(ver)

	_select_char(0)


func _build_game() -> void:
	game = Control.new()
	game.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(game)
	_full(game)
	game.visible = false

	var hp_bg := ColorRect.new()
	hp_bg.color = Color("#0a0c12")
	hp_bg.position = Vector2(9, 8)
	hp_bg.size = Vector2(144, 10)
	hp_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.add_child(hp_bg)

	hp_fill = ColorRect.new()
	hp_fill.color = Color("#a83232")
	hp_fill.position = Vector2(10, 9)
	hp_fill.size = Vector2(142, 8)
	hp_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.add_child(hp_fill)

	var xp_bg := ColorRect.new()
	xp_bg.color = Color("#0a0c12")
	xp_bg.position = Vector2(9, 21)
	xp_bg.size = Vector2(144, 5)
	xp_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.add_child(xp_bg)

	xp_fill = ColorRect.new()
	xp_fill.color = Color("#e8ba54")
	xp_fill.position = Vector2(10, 22)
	xp_fill.size = Vector2(142, 3)
	xp_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.add_child(xp_fill)

	level_label = _label("LV 1", 8, Color("#9fd8e8"))
	level_label.position = Vector2(10, 27)
	level_label.size = Vector2(100, 12)
	game.add_child(level_label)

	timer_label = _label("00:00", 18, Color("#e8e2d0"))
	timer_label.position = Vector2(220, 2)
	timer_label.size = Vector2(200, 24)
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game.add_child(timer_label)

	act_label = _label("DUSK", 8, Color("#9fd8e8"))
	act_label.position = Vector2(220, 24)
	act_label.size = Vector2(200, 12)
	act_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game.add_child(act_label)

	kill_label = _label("KILLS 0", 9, Color("#e8e2d0"))
	kill_label.position = Vector2(470, 8)
	kill_label.size = Vector2(160, 14)
	kill_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	game.add_child(kill_label)

	gold_label = _label("COINS 0", 8, Color("#e8ba54"))
	gold_label.position = Vector2(470, 22)
	gold_label.size = Vector2(160, 12)
	gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	game.add_child(gold_label)

	boss_name = _label("", 8, Color("#e8ba54"))
	boss_name.position = Vector2(220, 40)
	boss_name.size = Vector2(200, 10)
	boss_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_name.visible = false
	game.add_child(boss_name)

	boss_bar_bg = ColorRect.new()
	boss_bar_bg.color = Color("#0a0c12")
	boss_bar_bg.position = Vector2(219, 50)
	boss_bar_bg.size = Vector2(202, 6)
	boss_bar_bg.visible = false
	boss_bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.add_child(boss_bar_bg)

	boss_bar_fill = ColorRect.new()
	boss_bar_fill.color = Color("#b03434")
	boss_bar_fill.position = Vector2(220, 51)
	boss_bar_fill.size = Vector2(200, 4)
	boss_bar_fill.visible = false
	boss_bar_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.add_child(boss_bar_fill)

	toast_label = _label("", 14, Color("#ffd27a"))
	toast_label.position = Vector2(0, 84)
	toast_label.size = Vector2(640, 20)
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label.modulate.a = 0.0
	game.add_child(toast_label)

	hint_label = _label("", 9, Color("#e8e2d0"))
	hint_label.position = Vector2(0, 300)
	hint_label.size = Vector2(640, 14)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game.add_child(hint_label)

	weapon_row = HBoxContainer.new()
	weapon_row.position = Vector2(10, 334)
	weapon_row.size = Vector2(300, 20)
	weapon_row.add_theme_constant_override("separation", 3)
	weapon_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.add_child(weapon_row)

	passive_row = HBoxContainer.new()
	passive_row.position = Vector2(330, 334)
	passive_row.size = Vector2(300, 20)
	passive_row.alignment = BoxContainer.ALIGNMENT_END
	passive_row.add_theme_constant_override("separation", 3)
	passive_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game.add_child(passive_row)


func _build_levelup() -> void:
	levelup = Control.new()
	root.add_child(levelup)
	_full(levelup)
	levelup.visible = false

	_dim(0.78, levelup)

	var t := _label("PUMILI", 22, Color("#ffd27a"))
	t.position = Vector2(0, 34)
	t.size = Vector2(640, 28)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	levelup.add_child(t)

	var s := _label("level up — choose one", 9, Color("#9fd8e8"))
	s.position = Vector2(0, 62)
	s.size = Vector2(640, 14)
	s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	levelup.add_child(s)

	card_row = HBoxContainer.new()
	card_row.position = Vector2(55, 88)
	card_row.size = Vector2(530, 176)
	card_row.alignment = BoxContainer.ALIGNMENT_CENTER
	card_row.add_theme_constant_override("separation", 10)
	levelup.add_child(card_row)

	var hint := _label("press 1 / 2 / 3", 8, Color("#7c8398"))
	hint.position = Vector2(0, 276)
	hint.size = Vector2(640, 12)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	levelup.add_child(hint)


func _build_pause() -> void:
	pause_menu = Control.new()
	root.add_child(pause_menu)
	_full(pause_menu)
	pause_menu.visible = false

	_dim(0.65, pause_menu)

	var t := _label("PAUSED", 26, Color("#ffd27a"))
	t.position = Vector2(0, 108)
	t.size = Vector2(640, 32)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_menu.add_child(t)

	var resume := _button("RESUME", 11)
	resume.position = Vector2(250, 170)
	resume.size = Vector2(140, 30)
	resume.pressed.connect(func(): main.request_pause())
	pause_menu.add_child(resume)

	var quit := _button("QUIT TO MENU", 10)
	quit.position = Vector2(250, 208)
	quit.size = Vector2(140, 30)
	quit.pressed.connect(func(): main.quit_to_menu())
	pause_menu.add_child(quit)


func _build_end() -> void:
	end_screen = Control.new()
	root.add_child(end_screen)
	_full(end_screen)
	end_screen.visible = false

	_dim(0.82, end_screen)

	end_title = _label("NAMATAY", 28, Color("#b03434"))
	end_title.position = Vector2(0, 72)
	end_title.size = Vector2(640, 34)
	end_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_screen.add_child(end_title)

	end_stats = _label("", 10, Color("#e8e2d0"))
	end_stats.position = Vector2(0, 116)
	end_stats.size = Vector2(640, 90)
	end_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_screen.add_child(end_stats)

	var again := _button("ULITIN", 11)
	again.position = Vector2(240, 224)
	again.size = Vector2(160, 30)
	again.pressed.connect(func(): main.restart_run())
	end_screen.add_child(again)

	var menu_btn := _button("MENU", 10)
	menu_btn.position = Vector2(240, 262)
	menu_btn.size = Vector2(160, 30)
	menu_btn.pressed.connect(func(): main.quit_to_menu())
	end_screen.add_child(menu_btn)


# ---------------------------------------------------------------------------
# Menu logic
# ---------------------------------------------------------------------------
func _select_char(i: int) -> void:
	selected_char = i
	for n in char_cards.size():
		var selected := n == i
		char_cards[n].add_theme_stylebox_override(
			"normal",
			_panel_style(Color("#181d2c") if selected else Color("#11141f"),
				Color("#ffd27a") if selected else Color("#3a3f55"), 2 if selected else 1)
		)


func show_menu(best_time: float, wins: int) -> void:
	menu.visible = true
	game.visible = false
	levelup.visible = false
	pause_menu.visible = false
	end_screen.visible = false
	if best_time > 0.0:
		best_label.text = "best: %s     wins: %d" % [_fmt(best_time), wins]
	else:
		best_label.text = "wins: %d" % wins
	# Focus first character card
	call_deferred("_focus_first_char_card")


func _focus_first_char_card() -> void:
	if not char_cards.is_empty() and char_cards[0] is Button:
		char_cards[0].grab_focus()


func begin_run(_char_id: String) -> void:
	menu.visible = false
	game.visible = true
	levelup.visible = false
	pause_menu.visible = false
	end_screen.visible = false
	refresh_build()
	toast("DUSK", 2.0)


# ---------------------------------------------------------------------------
# Runtime
# ---------------------------------------------------------------------------
func update_game() -> void:
	if main.player == null or not is_instance_valid(main.player):
		return
	var p = main.player
	hp_fill.size.x = 142.0 * clampf(p.hp / p.max_hp, 0.0, 1.0)
	xp_fill.size.x = 142.0 * clampf(float(p.xp) / float(maxi(p.xp_next, 1)), 0.0, 1.0)
	timer_label.text = _fmt(main.time)
	act_label.text = main.act_name()
	level_label.text = "LV %d" % p.level
	kill_label.text = "KILLS %d" % main.kills
	gold_label.text = "COINS %d" % p.gold

	if main.boss != null and is_instance_valid(main.boss) and not main.boss.dead:
		boss_name.visible = true
		boss_bar_bg.visible = true
		boss_bar_fill.visible = true
		boss_name.text = main.boss.display_name.to_upper()
		boss_bar_fill.size.x = 200.0 * clampf(main.boss.hp / main.boss.max_hp, 0.0, 1.0)
	else:
		boss_name.visible = false
		boss_bar_bg.visible = false
		boss_bar_fill.visible = false

	var near_mound: bool = main.mound_near_player()
	hint_label.text = "[E]  INTERACT" if near_mound else ""


func refresh_build() -> void:
	if main.player == null:
		return
	for c in weapon_row.get_children():
		c.queue_free()
	for c in passive_row.get_children():
		c.queue_free()
	var p = main.player
	for w in p.weapons:
		var lvl_text := "E" if w["evo"] else str(w["level"])
		weapon_row.add_child(_icon_cell(DataRef.WEAPONS[w["id"]]["icon"], lvl_text))
	for id in p.passives:
		passive_row.add_child(_icon_cell(DataRef.PASSIVES[id]["icon"], str(p.passives[id])))


func _icon_cell(tex_path: String, lvl_text: String) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(20, 20)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var t := TextureRect.new()
	t.texture = load(tex_path)
	t.position = Vector2(0, 1)
	t.size = Vector2(18, 18)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.add_child(t)
	var l := _label(lvl_text, 7, Color("#ffd27a"))
	l.position = Vector2(13, 10)
	c.add_child(l)
	return c


func toast(msg: String, dur := 2.0) -> void:
	toast_label.text = msg
	toast_label.modulate.a = 1.0
	if toast_tween != null and toast_tween.is_valid():
		toast_tween.kill()
	toast_tween = create_tween()
	toast_tween.tween_interval(dur)
	toast_tween.tween_property(toast_label, "modulate:a", 0.0, 0.7)


func show_levelup(cards: Array) -> void:
	levelup.visible = true
	for c in card_row.get_children():
		c.queue_free()
	for i in cards.size():
		var card: Dictionary = cards[i]
		var b := Button.new()
		b.custom_minimum_size = Vector2(168, 168)
		b.focus_mode = Control.FOCUS_ALL
		b.add_theme_stylebox_override("normal", _panel_style(Color("#12151f"), Color("#3a3f55"), 1))
		b.add_theme_stylebox_override("hover", _panel_style(Color("#1a1f2e"), Color("#ffd27a"), 2))
		b.add_theme_stylebox_override("pressed", _panel_style(Color("#241d2b"), Color("#ffd27a"), 2))
		b.add_theme_stylebox_override("focus", _panel_style(Color("#1a1f2e"), Color("#ffd27a"), 2))
		card_row.add_child(b)

		var box := VBoxContainer.new()
		box.set_anchors_preset(Control.PRESET_FULL_RECT)
		box.offset_left = 8
		box.offset_top = 8
		box.offset_right = -8
		box.offset_bottom = -8
		box.add_theme_constant_override("separation", 4)
		box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(box)

		var icon := TextureRect.new()
		icon.texture = load(card["icon"])
		icon.custom_minimum_size = Vector2(40, 40)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		box.add_child(icon)

		var nm := _label(card["title"], 10, Color("#ffd27a"))
		nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(nm)

		var tag := _label(card["tag"], 8, Color("#9fd8e8"))
		tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(tag)

		var desc := _label(card["desc"], 8, Color("#b9bfcc"))
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		desc.size_flags_vertical = Control.SIZE_EXPAND_FILL
		box.add_child(desc)

		var key := _label(str(i + 1), 9, Color("#6d7488"))
		key.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(key)

		b.pressed.connect(_on_card.bind(i))

		# Focus first card after a frame
		if i == 0:
			call_deferred("_focus_first_card")


func _focus_first_card() -> void:
	var children := card_row.get_children()
	if not children.is_empty() and children[0] is Button:
		children[0].grab_focus()


func hide_levelup() -> void:
	levelup.visible = false


func show_pause(v: bool) -> void:
	pause_menu.visible = v
	if v:
		call_deferred("_focus_resume_button")


func _focus_resume_button() -> void:
	var children := pause_menu.get_children()
	for c in children:
		if c is Button and c.text == "RESUME":
			c.grab_focus()
			break


func show_end(win: bool, stats: String) -> void:
	end_screen.visible = true
	levelup.visible = false
	pause_menu.visible = false
	if win:
		end_title.text = "DAWN"
		end_title.add_theme_color_override("font_color", Color("#ffd27a"))
	else:
		end_title.text = "DEFEATED"
		end_title.add_theme_color_override("font_color", Color("#b03434"))
	end_stats.text = stats
	call_deferred("_focus_retry_button")


func _focus_retry_button() -> void:
	var children := end_screen.get_children()
	for c in children:
		if c is Button and c.text == "ULITIN":
			c.grab_focus()
			break


func _on_card(i: int) -> void:
	main.card_picked(i)


func _focus_next_card() -> void:
	var children := card_row.get_children()
	if children.is_empty():
		return
	var current_focus = get_viewport().gui_get_focus_owner()
	var current_idx := -1
	for idx in children.size():
		if children[idx] == current_focus:
			current_idx = idx
			break
	var next_idx := (current_idx + 1) % children.size()
	if children[next_idx] is Button:
		children[next_idx].grab_focus()


func _focus_prev_card() -> void:
	var children := card_row.get_children()
	if children.is_empty():
		return
	var current_focus = get_viewport().gui_get_focus_owner()
	var current_idx := -1
	for idx in children.size():
		if children[idx] == current_focus:
			current_idx = idx
			break
	var prev_idx := (current_idx - 1 + children.size()) % children.size()
	if children[prev_idx] is Button:
		children[prev_idx].grab_focus()


func _accept_focused_card() -> void:
	var current_focus = get_viewport().gui_get_focus_owner()
	var children := card_row.get_children()
	for idx in children.size():
		if children[idx] == current_focus:
			_on_card(idx)
			break


func _fmt(seconds: float) -> String:
	var s := int(maxf(0.0, seconds))
	return "%02d:%02d" % [s / 60, s % 60]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if main.is_playing() or main.is_paused():
			main.request_pause()
			get_viewport().set_input_as_handled()
		return

	# Gamepad/keyboard navigation for levelup screen
	if levelup.visible:
		if event.is_action_pressed("ui_left") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_LEFT):
			_focus_prev_card()
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_right") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_RIGHT):
			_focus_next_card()
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER)):
			_accept_focused_card()
			get_viewport().set_input_as_handled()
			return
		# Keep keyboard 1/2/3 for quick selection
		if event is InputEventKey and event.pressed and not event.echo:
			match event.keycode:
				KEY_1: _on_card(0); get_viewport().set_input_as_handled()
				KEY_2: _on_card(1); get_viewport().set_input_as_handled()
				KEY_3: _on_card(2); get_viewport().set_input_as_handled()
		return

	# Gamepad/keyboard navigation for menu screen
	if menu.visible:
		if event.is_action_pressed("ui_left") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_LEFT) or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_A):
			_select_char((selected_char + 2) % 3)
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_right") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_RIGHT) or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_D):
			_select_char((selected_char + 1) % 3)
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER)):
			main.start_run(DataRef.CHAR_ORDER[selected_char])
			get_viewport().set_input_as_handled()
			return
