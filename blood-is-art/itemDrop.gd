extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop"):
		print("drop item")
		
	pass

func dropItem() -> void:
	var distance: float = 2.0
	var forwardDistance: Vector3 = -player_camera.global_transform.basis.z.normalized()
	var 
