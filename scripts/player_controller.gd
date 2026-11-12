extends CharacterBody3D
## Simple third-person keyboard controller for the MVP.

@export var move_speed: float = 5.4
@export var acceleration: float = 18.0
@export var gravity: float = 22.0

var visual_root: Node3D
var camera_pivot: Node3D


func _ready() -> void:
	add_to_group("player")
	_build_collision()
	_build_character()
	_build_camera()


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward := -camera_pivot.global_basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var right := camera_pivot.global_basis.x
	right.y = 0.0
	right = right.normalized()
	var direction := (right * input_vector.x + forward * -input_vector.y).normalized()
	var target := direction * move_speed

	velocity.x = move_toward(velocity.x, target.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target.z, acceleration * delta)
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	move_and_slide()

	if direction.length_squared() > 0.01:
		visual_root.look_at(visual_root.global_position + direction, Vector3.UP)

	global_position.x = clampf(global_position.x, -19.0, 19.0)
	global_position.z = clampf(global_position.z, -19.0, 19.0)


func _build_collision() -> void:
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.34
	capsule.height = 1.65
	collision.shape = capsule
	collision.position.y = 0.83
	add_child(collision)


func _build_character() -> void:
	visual_root = Node3D.new()
	visual_root.name = "CharacterVisual"
	add_child(visual_root)

	var skin := _mat(Color(0.64, 0.39, 0.24))
	var shirt := _mat(Color(0.12, 0.42, 0.82))
	var trousers := _mat(Color(0.12, 0.20, 0.36))
	var shoes := _mat(Color(0.15, 0.10, 0.08))
	var hair := _mat(Color(0.12, 0.075, 0.045))
	var bag := _mat(Color(0.96, 0.48, 0.12))

	_sphere(visual_root, Vector3(0, 1.20, 0), Vector3(0.43, 0.50, 0.29), shirt)
	_sphere(visual_root, Vector3(0, 1.91, -0.02), Vector3(0.30, 0.31, 0.28), skin)
	_sphere(visual_root, Vector3(0, 2.10, 0.00), Vector3(0.31, 0.16, 0.29), hair)
	_sphere(visual_root, Vector3(-0.11, 1.94, -0.265), Vector3(0.035, 0.045, 0.025), _mat(Color.WHITE))
	_sphere(visual_root, Vector3(0.11, 1.94, -0.265), Vector3(0.035, 0.045, 0.025), _mat(Color.WHITE))
	_sphere(visual_root, Vector3(-0.11, 1.94, -0.286), Vector3(0.016, 0.022, 0.012), _mat(Color(0.08, 0.08, 0.08)))
	_sphere(visual_root, Vector3(0.11, 1.94, -0.286), Vector3(0.016, 0.022, 0.012), _mat(Color(0.08, 0.08, 0.08)))

	_box(visual_root, Vector3(-0.18, 0.62, 0), Vector3(0.18, 0.57, 0.19), trousers)
	_box(visual_root, Vector3(0.18, 0.62, 0), Vector3(0.18, 0.57, 0.19), trousers)
	_box(visual_root, Vector3(-0.18, 0.20, -0.025), Vector3(0.23, 0.15, 0.34), shoes)
	_box(visual_root, Vector3(0.18, 0.20, -0.025), Vector3(0.23, 0.15, 0.34), shoes)
	_sphere(visual_root, Vector3(-0.48, 1.26, 0), Vector3(0.14, 0.37, 0.15), shirt)
	_sphere(visual_root, Vector3(0.48, 1.26, 0), Vector3(0.14, 0.37, 0.15), shirt)
	_box(visual_root, Vector3(0, 1.25, 0.27), Vector3(0.52, 0.54, 0.20), bag)


func _build_camera() -> void:
	camera_pivot = Node3D.new()
	camera_pivot.position = Vector3(0, 1.55, 0)
	add_child(camera_pivot)
	var spring_arm := SpringArm3D.new()
	spring_arm.spring_length = 6.0
	spring_arm.margin = 0.2
	spring_arm.rotation_degrees.x = -12.0
	camera_pivot.add_child(spring_arm)
	var camera := Camera3D.new()
	camera.current = true
	camera.fov = 65.0
	spring_arm.add_child(camera)


func _sphere(parent: Node3D, position: Vector3, scale: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 1.0
	instance.mesh = mesh
	instance.position = position
	instance.scale = scale
	instance.material_override = material
	parent.add_child(instance)


func _box(parent: Node3D, position: Vector3, scale: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3.ONE
	instance.mesh = mesh
	instance.position = position
	instance.scale = scale
	instance.material_override = material
	parent.add_child(instance)


func _mat(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.88
	return material
