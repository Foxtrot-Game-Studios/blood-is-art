extends Area3D
var npcCollision = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and npcCollision==true:
		print("YAY")
		Dialogic.start("res://timelines/timeline.dtl")
	pass

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		npcCollision = true
	pass # Replace with function body.

func _on_area_exited(area: Area3D) -> void:
	npcCollision = false
	pass # Replace with function body.
