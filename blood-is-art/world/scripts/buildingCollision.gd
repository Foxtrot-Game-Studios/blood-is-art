extends Area3D
var areaCollision = false
var worldScene = load("res://world/scenes/world.tscn")
var insideScene = load("res://world/scenes/inside.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	print(get_tree().current_scene)
	print(worldScene)

	if body.name == "Player" and get_tree().current_scene.scene_file_path == "res://world/scenes/world.tscn":
		print("inside")
		FadeAnimation.change_scene("res://world/scenes/inside.tscn")
	if body.name == "Player" and get_tree().current_scene.scene_file_path == "res://world/scenes/inside.tscn":
		print("inside")
		FadeAnimation.change_scene("res://world/scenes/world.tscn")
	pass # Replace with function body.
