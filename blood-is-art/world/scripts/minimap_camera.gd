extends Camera3D

@export var camera_height: float = 100.0
@export var camera_size: float = 20.0

var player: CharacterBody3D

func _ready() -> void:
	player = globals.player

func _process(delta: float) -> void:
	size = camera_size
	global_position = Vector3(player.global_position.x, player.global_position.y + camera_height, player.global_position.z)
