extends CharacterBody3D

@onready var player_camera: Camera3D = $SpringArm3D/Camera3D
@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var weapon: StaticBody3D = $Weapon
@onready var marker: Marker3D = $Marker3D

var player_pos: Vector3 = global_position
var weapon_scene = preload("../scenes/weapon.tscn")

const APPROX_ZERO: float = 0.001

const SPEED: float = 10.0
const FRICTION: float = 8.0

const JUMP_VELOCITY: float = 5.0

const SPRINT_VELOCITY: float = 7.0
const SPRINT_ACCEL: float = 17.0

const CAM_SENS: float = 0.005

var sprinting: bool = false
var sprint_boost: Vector3 = Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if not sprinting:
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		elif is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, FRICTION * delta)
			velocity.z = lerp(velocity.z, 0.0, FRICTION * delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("left_shift") and not sprinting:
		sprinting = true
		sprint_boost = -global_transform.basis.z.normalized() * SPRINT_VELOCITY
	
	if sprinting:
		sprint_boost = sprint_boost.lerp(Vector3.ZERO, SPRINT_ACCEL * delta)
		velocity += sprint_boost
		if sprint_boost.x <= APPROX_ZERO and sprint_boost.x >= -APPROX_ZERO and sprint_boost.z <= APPROX_ZERO and sprint_boost.z >= -APPROX_ZERO:
			sprinting = false
			sprint_boost = Vector3.ZERO
	
	if velocity.x <= APPROX_ZERO and velocity.x >= -APPROX_ZERO:
		velocity.x = 0.0
	if velocity.z <= APPROX_ZERO and velocity.z >= -APPROX_ZERO:
		velocity.z = 0.0

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAM_SENS
		spring_arm.rotation.x -= event.relative.y * CAM_SENS
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/3)
		
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("left_click"):
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			get_viewport().set_input_as_handled()
		else:
			weapon.attack()
	
	if event.is_action_pressed("drop"):
		dropItem()

func dropItem() -> void:
	var space_state: PhysicsDirectSpaceState3D = player_camera.get_world_3d().direct_space_state

	var drop_distance: float = 9.0
	var forward_dir: Vector3 = -player_camera.global_transform.basis.z.normalized()
	var start_offset: float = 0.5 
	var target_pos: Vector3 = player_camera.global_transform.origin + forward_dir * drop_distance
	var obstacle_params = PhysicsRayQueryParameters3D.new()
	obstacle_params.collision_mask = 1
	obstacle_params.from = player_camera.global_transform.origin + forward_dir * start_offset
	obstacle_params.to = target_pos
	obstacle_params.exclude = [self, weapon]
	var obstacle_hit: Dictionary = space_state.intersect_ray(obstacle_params)
	if not obstacle_hit.is_empty():
		print("Cannot drop: path blocked", obstacle_hit.collider.name)
		return

	var ground_params = PhysicsRayQueryParameters3D.new()
	ground_params.from = target_pos + Vector3.UP * 1.0
	ground_params.to = target_pos + Vector3.DOWN * 5.0
	ground_params.exclude = [self, weapon]
	ground_params.collision_mask = 1
	var ground_hit: Dictionary = space_state.intersect_ray(ground_params)
	if ground_hit.is_empty():
		print("Cannot drop: no ground")
		return

	var dropped_weapon = weapon_scene.instantiate()
	get_tree().current_scene.add_child(dropped_weapon)
	
	var buffer_height: float = 0.2
	var target_ground_pos: Vector3 = ground_hit.position + Vector3(0, buffer_height, 0)
	var spawn_air_pos: Vector3 = target_ground_pos + Vector3(0, 1.5, 0)
	
	dropped_weapon.global_position = spawn_air_pos
	
	var target_scale := Vector3(0.5, 0.5, 0.5)
	
	var tween := create_tween().set_parallel(true)
	
	tween.tween_property(dropped_weapon, "global_position", target_ground_pos, 0.5)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(dropped_weapon, "scale", target_scale, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
