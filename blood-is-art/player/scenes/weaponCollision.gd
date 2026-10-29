extends Area3D
@onready var weapon: StaticBody3D = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		weapon.visible = false;
		print("Collided with player")
	pass # Replace with function body.
