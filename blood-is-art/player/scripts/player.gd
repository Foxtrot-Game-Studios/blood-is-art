extends CharacterBody3D

@onready var spring_arm: SpringArm3D = $SpringArm3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const CAM_SENS = 0.002

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAM_SENS
		spring_arm.rotation.x -= event.relative.y * CAM_SENS
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/3)
