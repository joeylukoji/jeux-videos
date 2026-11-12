extends Node3D
class_name WordItem
## A 3D vocabulary target which floats gently until collected.

var word_data: Dictionary = {}
var model_root: Node3D
var collected := false
var elapsed := 0.0


func configure(data: Dictionary, model: Node3D) -> void:
	word_data = data.duplicate(true)
	model_root = model
	model_root.name = "Model"
	add_child(model_root)

	var marker := Label3D.new()
	marker.text = "?"
	marker.font_size = 64
	marker.position = Vector3(0, 1.8, 0)
	marker.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	marker.modulate = Color(1.0, 0.93, 0.48)
	marker.outline_size = 10
	marker.outline_modulate = Color(0.18, 0.25, 0.34)
	add_child(marker)


func _process(delta: float) -> void:
	if collected or model_root == null:
		return
	elapsed += delta
	model_root.position.y = 0.13 + sin(elapsed * 2.4) * 0.10
	model_root.rotate_y(delta * 0.35)


func collect() -> void:
	collected = true
	visible = false
