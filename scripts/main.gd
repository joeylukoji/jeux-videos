extends Node3D

const PLAYER_SCENE := preload("res://scenes/player.tscn")
const WORDS_PATH := "res://data/words.json"
const PROXIMITY_DISTANCE := 3.0

var player: CharacterBody3D
var lesson_steps: Array[Dictionary] = []
var world_items: Array[WordItem] = []
var current_step := 0
var nearby_item: WordItem
var quiz_open := false
var selected_voice := ""

var prompt_label: Label
var progress_label: Label
var hint_label: Label
var quiz_panel: PanelContainer
var quiz_question: Label
var quiz_feedback: Label
var answer_grid: GridContainer


func _ready() -> void:
	_load_lesson_data()
	_build_environment()
	_spawn_player()
	_spawn_learning_objects()
	_build_hud()
	_select_english_voice()
	_update_hud()


func _process(_delta: float) -> void:
	if not quiz_open:
		_find_nearest_word()
		if Input.is_action_just_pressed("interact"):
			_interact_with_nearby_item()
	if current_step >= lesson_steps.size() and Input.is_action_just_pressed("restart"):
		_restart_lesson()


func _load_lesson_data() -> void:
	var file := FileAccess.open(WORDS_PATH, FileAccess.READ)
	if file == null:
		push_error("Fichier de vocabulaire manquant : " + WORDS_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		var values: Variant = parsed.get("steps", [])
		if values is Array:
			for value in values:
				if value is Dictionary:
					lesson_steps.append(value)


func _build_environment() -> void:
	var world_environment := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.52, 0.79, 0.96)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.82, 0.88, 0.96)
	environment.ambient_light_energy = 0.85
	world_environment.environment = environment
	add_child(world_environment)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-52, -28, 0)
	sun.light_energy = 1.25
	sun.shadow_enabled = true
	add_child(sun)

	var ground := MeshInstance3D.new()
	var ground_mesh := PlaneMesh.new()
	ground_mesh.size = Vector2(48, 48)
	ground.mesh = ground_mesh
	ground.material_override = _material(Color(0.35, 0.66, 0.34))
	ground.position.y = -0.03
	add_child(ground)

	var floor_body := StaticBody3D.new()
	floor_body.position.y = -0.28
	var floor_collision := CollisionShape3D.new()
	var floor_shape := BoxShape3D.new()
	floor_shape.size = Vector3(48, 0.5, 48)
	floor_collision.shape = floor_shape
	floor_body.add_child(floor_collision)
	add_child(floor_body)

	var water := MeshInstance3D.new()
	var water_mesh := PlaneMesh.new()
	water_mesh.size = Vector2(62, 62)
	water.mesh = water_mesh
	water.position.y = -0.34
	water.material_override = _material(Color(0.21, 0.65, 0.83))
	add_child(water)

	_add_path_segment(Vector3(-7, 0.015, 4), Vector3(-7, 0.015, -5), 2.8)
	_add_path_segment(Vector3(7, 0.015, 4), Vector3(7, 0.015, -5), 2.8)
	_add_path_segment(Vector3(0, 0.018, 7), Vector3(0, 0.018, 3), 2.8)

	var animals_sign := ProceduralAssets.make_sign("ANIMALS", "ANIMAUX")
	animals_sign.position = Vector3(-8, 0, -11)
	add_child(animals_sign)
	var food_sign := ProceduralAssets.make_sign("FOOD", "NOURRITURE")
	food_sign.position = Vector3(8, 0, -11)
	add_child(food_sign)

	var tree_positions := [
		Vector3(-17, 0, -13), Vector3(-17, 0, -4), Vector3(-17, 0, 8),
		Vector3(-13, 0, 15), Vector3(-3, 0, -16), Vector3(2, 0, -17),
		Vector3(13, 0, 15), Vector3(17, 0, 8), Vector3(17, 0, -4),
		Vector3(17, 0, -13)
	]
	for index in range(tree_positions.size()):
		var tree: Node3D
		var tree_path := "res://assets/models/environment/tree-oak.glb" if index % 2 == 0 else "res://assets/models/environment/tree-palm.glb"
		if ResourceLoader.exists(tree_path):
			var tree_scene := load(tree_path) as PackedScene
			tree = tree_scene.instantiate() if tree_scene != null else ProceduralAssets.make_tree(index % 2 == 0)
		else:
			tree = ProceduralAssets.make_tree(index % 2 == 0)
		tree.position = tree_positions[index]
		tree.scale = Vector3.ONE * randf_range(0.85, 1.2)
		add_child(tree)


func _spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	player.position = Vector3(0, 0, 10)
	add_child(player)


func _spawn_learning_objects() -> void:
	for step in lesson_steps:
		var item := WordItem.new()
		item.name = str(step.get("id", "word"))
		var coordinates: Array = step.get("position", [0, 0, 0])
		item.position = Vector3(float(coordinates[0]), float(coordinates[1]), float(coordinates[2]))
		item.configure(step, _make_word_model(str(step.get("id", "")), str(step.get("category", ""))))
		add_child(item)
		world_items.append(item)


func _make_word_model(word_id: String, category: String) -> Node3D:
	var folder := "animals" if category == "animal" else "food"
	var model_path := "res://assets/models/%s/%s.glb" % [folder, word_id]
	if ResourceLoader.exists(model_path):
		var packed := load(model_path) as PackedScene
		if packed != null:
			var instance := packed.instantiate()
			instance.scale = Vector3.ONE * 1.5
			return instance
	if category == "animal":
		return ProceduralAssets.make_animal(word_id)
	return ProceduralAssets.make_food(word_id)


func _find_nearest_word() -> void:
	nearby_item = null
	var nearest := PROXIMITY_DISTANCE
	for item in world_items:
		if not is_instance_valid(item) or item.collected:
			continue
		var distance := player.global_position.distance_to(item.global_position)
		if distance < nearest:
			nearest = distance
			nearby_item = item
	var target_french := str(lesson_steps[current_step].get("french", "")) if current_step < lesson_steps.size() else ""
	if nearby_item != null:
		prompt_label.text = "Objet proche : %s — appuie sur E" % str(nearby_item.word_data.get("french", ""))
	elif not target_french.is_empty():
		prompt_label.text = "Objectif : retrouve « %s »" % target_french
	else:
		prompt_label.text = "Mission terminée ! Appuie sur R pour rejouer."


func _interact_with_nearby_item() -> void:
	if quiz_open or nearby_item == null or current_step >= lesson_steps.size():
		return
	var target: Dictionary = lesson_steps[current_step]
	var found_id := str(nearby_item.word_data.get("id", ""))
	if found_id != str(target.get("id", "")):
		hint_label.text = "Pas encore ! Cherche : " + str(target.get("french", ""))
		return
	_open_quiz(target, nearby_item)


func _open_quiz(target: Dictionary, item: WordItem) -> void:
	quiz_open = true
	nearby_item = item
	quiz_panel.visible = true
	quiz_feedback.text = "Choisis la bonne réponse."
	quiz_question.text = "Quel mot anglais signifie « %s » ?" % str(target.get("french", ""))
	_rebuild_answer_buttons(target)


func _rebuild_answer_buttons(target: Dictionary) -> void:
	for child in answer_grid.get_children():
		child.queue_free()
	var options: Array[String] = [str(target.get("english", ""))]
	for step in lesson_steps:
		var option := str(step.get("english", ""))
		if option != str(target.get("english", "")) and not options.has(option):
			options.append(option)
		if options.size() >= 3:
			break
	options.shuffle()
	for option in options:
		var button := Button.new()
		button.text = option.capitalize()
		button.custom_minimum_size = Vector2(150, 66)
		button.add_theme_font_size_override("font_size", 26)
		button.pressed.connect(_on_answer_selected.bind(option))
		answer_grid.add_child(button)


func _on_answer_selected(answer: String) -> void:
	if current_step >= lesson_steps.size():
		return
	var target: Dictionary = lesson_steps[current_step]
	var english := str(target.get("english", ""))
	if answer != english:
		quiz_feedback.text = "Presque ! Tu peux écouter et réessayer."
		return

	var word_id := str(target.get("id", ""))
	var already_learned := GameState.has_learned(word_id)
	GameState.register_word(word_id)
	_speak_english(english)
	if nearby_item != null:
		nearby_item.collect()

	quiz_panel.visible = false
	quiz_open = false
	current_step += 1

	if already_learned:
		hint_label.text = "Bien joué ! Tu révises : %s = %s." % [english, str(target.get("french", ""))]
	else:
		hint_label.text = "Excellent ! %s signifie « %s »." % [english, str(target.get("french", ""))]

	if current_step >= lesson_steps.size():
		prompt_label.text = "Mission terminée ! Appuie sur R pour rejouer."
		hint_label.text = "Bravo, explorateur ! Tu as terminé les 8 mots. Appuie sur R pour recommencer."
	else:
		prompt_label.text = "Prochain mot : " + str(lesson_steps[current_step].get("french", ""))
	_update_hud()


func _select_english_voice() -> void:
	var voices := DisplayServer.tts_get_voices_for_language("en")
	if not voices.is_empty():
		selected_voice = voices[0]


func _speak_english(word: String, show_feedback: bool = false) -> void:
	if selected_voice.is_empty():
		if show_feedback and quiz_feedback != null:
			quiz_feedback.text = "Voix anglaise non disponible. Le mot reste affiché."
		return
	DisplayServer.tts_speak(word, selected_voice, 80, 1.08, 0.88, 0, true)


func _on_listen_pressed() -> void:
	if current_step < lesson_steps.size():
		_speak_english(str(lesson_steps[current_step].get("english", "")), true)


func _update_hud() -> void:
	if progress_label == null:
		return
	progress_label.text = "Mots appris : %d / %d     ⭐ %d" % [
		GameState.learned_words.size(), lesson_steps.size(), GameState.stars
	]


func _restart_lesson() -> void:
	current_step = 0
	for item in world_items:
		item.collected = false
		item.visible = true
	hint_label.text = "Nouvelle partie ! Retrouve le chien."
	_update_hud()


func _build_hud() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 5
	add_child(canvas)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(root)

	var hud_panel := PanelContainer.new()
	hud_panel.position = Vector2(22, 20)
	hud_panel.size = Vector2(470, 156)
	hud_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.055, 0.13, 0.20, 0.88)))
	root.add_child(hud_panel)
	var hud_box := VBoxContainer.new()
	hud_box.add_theme_constant_override("separation", 7)
	hud_panel.add_child(hud_box)

	var title := Label.new()
	title.text = "ENGLISH QUEST 3D"
	title.add_theme_font_size_override("font_size", 27)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.30))
	hud_box.add_child(title)

	progress_label = Label.new()
	progress_label.add_theme_font_size_override("font_size", 18)
	progress_label.add_theme_color_override("font_color", Color.WHITE)
	hud_box.add_child(progress_label)

	prompt_label = Label.new()
	prompt_label.text = "Explore l'île et approche-toi des objets !"
	prompt_label.add_theme_font_size_override("font_size", 19)
	prompt_label.add_theme_color_override("font_color", Color(0.86, 0.94, 1.0))
	prompt_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hud_box.add_child(prompt_label)

	hint_label = Label.new()
	hint_label.position = Vector2(22, 190)
	hint_label.size = Vector2(540, 74)
	hint_label.add_theme_font_size_override("font_size", 20)
	hint_label.add_theme_color_override("font_color", Color(0.07, 0.15, 0.20))
	hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_label.text = "Bienvenue ! Retrouve d'abord le chien."
	root.add_child(hint_label)

	var controls := Label.new()
	controls.text = "WASD / ZQSD : bouger     E : explorer     R : rejouer"
	controls.position = Vector2(22, 672)
	controls.size = Vector2(800, 28)
	controls.add_theme_font_size_override("font_size", 17)
	controls.add_theme_color_override("font_color", Color(0.07, 0.15, 0.20))
	root.add_child(controls)

	quiz_panel = PanelContainer.new()
	quiz_panel.visible = false
	quiz_panel.anchor_left = 0.5
	quiz_panel.anchor_top = 0.5
	quiz_panel.anchor_right = 0.5
	quiz_panel.anchor_bottom = 0.5
	quiz_panel.offset_left = -280
	quiz_panel.offset_top = -190
	quiz_panel.offset_right = 280
	quiz_panel.offset_bottom = 190
	quiz_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.055, 0.13, 0.20, 0.96)))
	root.add_child(quiz_panel)

	var quiz_box := VBoxContainer.new()
	quiz_box.add_theme_constant_override("separation", 16)
	quiz_panel.add_child(quiz_box)

	quiz_question = Label.new()
	quiz_question.text = "Quel mot anglais signifie ce mot ?"
	quiz_question.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	quiz_question.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	quiz_question.add_theme_font_size_override("font_size", 27)
	quiz_question.add_theme_color_override("font_color", Color.WHITE)
	quiz_box.add_child(quiz_question)

	var listen_button := Button.new()
	listen_button.text = "Écouter le mot (TTS)"
	listen_button.custom_minimum_size = Vector2(200, 52)
	listen_button.add_theme_font_size_override("font_size", 20)
	listen_button.pressed.connect(_on_listen_pressed)
	quiz_box.add_child(listen_button)

	answer_grid = GridContainer.new()
	answer_grid.columns = 3
	answer_grid.add_theme_constant_override("h_separation", 12)
	quiz_box.add_child(answer_grid)

	quiz_feedback = Label.new()
	quiz_feedback.text = ""
	quiz_feedback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	quiz_feedback.add_theme_font_size_override("font_size", 19)
	quiz_feedback.add_theme_color_override("font_color", Color(1.0, 0.86, 0.30))
	quiz_box.add_child(quiz_feedback)


func _add_path_segment(start: Vector3, finish: Vector3, width: float) -> void:
	var path := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(width, 0.05, start.distance_to(finish))
	path.mesh = mesh
	path.position = (start + finish) * 0.5
	path.material_override = _material(Color(0.75, 0.63, 0.43))
	add_child(path)


func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	return material


func _panel_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(1.0, 0.84, 0.35, 0.9)
	style.set_border_width_all(2)
	style.set_corner_radius_all(18)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	return style
