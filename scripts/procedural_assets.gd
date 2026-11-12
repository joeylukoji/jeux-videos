extends RefCounted
class_name ProceduralAssets
## Original low-poly fallback meshes. Generated locally; no downloads required.


static func make_animal(kind: String) -> Node3D:
	var root := Node3D.new()
	var palette := _animal_palette(kind)
	var body: Material = _mat(palette["body"])
	var detail: Material = _mat(palette["detail"])
	var dark: Material = _mat(palette["dark"])

	_sphere(root, Vector3(0, 0.67, 0), Vector3(0.58, 0.42, 0.78), body)
	_sphere(root, Vector3(0, 1.07, -0.48), Vector3(0.36, 0.34, 0.36), detail)
	for x in [-0.29, 0.29]:
		for z in [-0.48, 0.43]:
			_cylinder(root, Vector3(x, 0.25, z), 0.09, 0.43, dark)

	var eye_mat := _mat(Color(0.05, 0.05, 0.05))
	_sphere(root, Vector3(-0.13, 1.11, -0.79), Vector3(0.045, 0.055, 0.035), eye_mat)
	_sphere(root, Vector3(0.13, 1.11, -0.79), Vector3(0.045, 0.055, 0.035), eye_mat)

	match kind:
		"dog":
			_sphere(root, Vector3(-0.28, 1.22, -0.52), Vector3(0.13, 0.26, 0.09), body)
			_sphere(root, Vector3(0.28, 1.22, -0.52), Vector3(0.13, 0.26, 0.09), body)
			_cylinder(root, Vector3(0, 0.82, 0.76), 0.055, 0.48, body, Vector3(65, 0, 0))
		"cat":
			_cone(root, Vector3(-0.20, 1.40, -0.47), 0.16, 0.30, detail)
			_cone(root, Vector3(0.20, 1.40, -0.47), 0.16, 0.30, detail)
			_cylinder(root, Vector3(0, 0.84, 0.78), 0.045, 0.70, body, Vector3(70, 0, 0))
		"cow":
			_sphere(root, Vector3(-0.28, 0.77, -0.18), Vector3(0.17, 0.19, 0.12), dark)
			_sphere(root, Vector3(0.30, 0.78, 0.22), Vector3(0.16, 0.15, 0.14), dark)
			_cone(root, Vector3(-0.25, 1.39, -0.45), 0.10, 0.20, detail)
			_cone(root, Vector3(0.25, 1.39, -0.45), 0.10, 0.20, detail)
			_sphere(root, Vector3(0, 0.88, -0.76), Vector3(0.20, 0.13, 0.12), _mat(Color(0.95, 0.66, 0.65)))
		"elephant":
			_sphere(root, Vector3(-0.40, 1.02, -0.48), Vector3(0.24, 0.33, 0.10), body)
			_sphere(root, Vector3(0.40, 1.02, -0.48), Vector3(0.24, 0.33, 0.10), body)
			_cylinder(root, Vector3(0, 0.84, -0.91), 0.10, 0.58, body, Vector3(-90, 0, 0))
	return root


static func make_food(kind: String) -> Node3D:
	var root := Node3D.new()
	match kind:
		"apple":
			_sphere(root, Vector3(0, 0.48, 0), Vector3(0.70, 0.76, 0.66), _mat(Color(0.88, 0.12, 0.12)))
			_cylinder(root, Vector3(0, 0.91, 0), 0.035, 0.18, _mat(Color(0.30, 0.17, 0.08)))
			_sphere(root, Vector3(0.16, 0.94, 0), Vector3(0.23, 0.07, 0.12), _mat(Color(0.20, 0.62, 0.25)))
		"banana":
			_sphere(root, Vector3(0, 0.36, 0), Vector3(0.90, 0.25, 0.33), _mat(Color(0.98, 0.79, 0.12)))
			_sphere(root, Vector3(-0.40, 0.42, 0), Vector3(0.18, 0.18, 0.18), _mat(Color(0.38, 0.24, 0.08)))
			_sphere(root, Vector3(0.40, 0.42, 0), Vector3(0.16, 0.17, 0.16), _mat(Color(0.38, 0.24, 0.08)))
		"carrot":
			_cone(root, Vector3(0, 0.48, 0), 0.33, 1.0, _mat(Color(0.96, 0.39, 0.08)), Vector3(180, 0, 0))
			_sphere(root, Vector3(0, 0.98, 0), Vector3(0.12, 0.24, 0.08), _mat(Color(0.20, 0.61, 0.23)))
		"orange":
			_sphere(root, Vector3(0, 0.48, 0), Vector3(0.72, 0.72, 0.72), _mat(Color(1.0, 0.45, 0.06)))
			_sphere(root, Vector3(0.02, 0.88, 0), Vector3(0.08, 0.06, 0.08), _mat(Color(0.25, 0.54, 0.20)))
		_:
			_box(root, Vector3(0, 0.46, 0), Vector3(0.92, 0.60, 0.60), _mat(Color(0.78, 0.47, 0.19)))
	return root


static func make_tree(pine: bool = false) -> Node3D:
	var root := Node3D.new()
	_cylinder(root, Vector3(0, 1.0, 0), 0.20, 2.0, _mat(Color(0.38, 0.22, 0.10)))
	if pine:
		_cone(root, Vector3(0, 2.0, 0), 1.05, 2.2, _mat(Color(0.10, 0.39, 0.25)))
		_cone(root, Vector3(0, 2.75, 0), 0.78, 1.7, _mat(Color(0.13, 0.48, 0.28)))
	else:
		_sphere(root, Vector3(0, 2.25, 0), Vector3(1.35, 1.2, 1.2), _mat(Color(0.16, 0.48, 0.23)))
		_sphere(root, Vector3(-0.62, 2.1, 0.15), Vector3(0.75, 0.75, 0.75), _mat(Color(0.22, 0.56, 0.27)))
	return root


static func make_sign(title: String, subtitle: String) -> Node3D:
	var root := Node3D.new()
	_cylinder(root, Vector3(0, 0.95, 0), 0.10, 1.9, _mat(Color(0.38, 0.22, 0.10)))
	_box(root, Vector3(0, 1.65, 0), Vector3(2.5, 0.9, 0.16), _mat(Color(0.96, 0.76, 0.40)))
	var label := Label3D.new()
	label.text = title + "\n" + subtitle
	label.font_size = 34
	label.position = Vector3(0, 1.67, -0.10)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.modulate = Color(0.18, 0.22, 0.26)
	root.add_child(label)
	return root


static func _animal_palette(kind: String) -> Dictionary:
	match kind:
		"dog":
			return {"body": Color(0.62, 0.34, 0.16), "detail": Color(0.82, 0.60, 0.35), "dark": Color(0.34, 0.19, 0.10)}
		"cat":
			return {"body": Color(0.80, 0.75, 0.66), "detail": Color(0.92, 0.86, 0.74), "dark": Color(0.40, 0.36, 0.32)}
		"cow":
			return {"body": Color(0.90, 0.88, 0.80), "detail": Color(0.96, 0.90, 0.84), "dark": Color(0.16, 0.16, 0.18)}
		"elephant":
			return {"body": Color(0.48, 0.54, 0.60), "detail": Color(0.64, 0.69, 0.72), "dark": Color(0.35, 0.40, 0.45)}
		_:
			return {"body": Color(0.55, 0.43, 0.28), "detail": Color(0.82, 0.68, 0.42), "dark": Color(0.25, 0.20, 0.15)}


static func _mat(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.92
	return material


static func _sphere(parent: Node3D, position: Vector3, scale: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 1.0
	instance.mesh = mesh
	instance.position = position
	instance.scale = scale
	instance.material_override = material
	parent.add_child(instance)


static func _box(parent: Node3D, position: Vector3, size: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	instance.mesh = mesh
	instance.position = position
	instance.material_override = material
	parent.add_child(instance)


static func _cylinder(parent: Node3D, position: Vector3, radius: float, height: float, material: Material, rotation: Vector3 = Vector3.ZERO) -> void:
	var instance := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	instance.mesh = mesh
	instance.position = position
	instance.rotation_degrees = rotation
	instance.material_override = material
	parent.add_child(instance)


static func _cone(parent: Node3D, position: Vector3, radius: float, height: float, material: Material, rotation: Vector3 = Vector3.ZERO) -> void:
	var instance := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.0
	mesh.bottom_radius = radius
	mesh.height = height
	instance.mesh = mesh
	instance.position = position
	instance.rotation_degrees = rotation
	instance.material_override = material
	parent.add_child(instance)
