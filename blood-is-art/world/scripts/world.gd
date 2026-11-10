extends Node3D

@onready var blood = $Decal
@onready var dummy = $Dummy

func _ready() -> void:
	dummy.hurt.connect(_on_hurt)

func _on_hurt():
	print("yeowch")
	var newBlood = blood.duplicate()
	
	newBlood.position = dummy.position
	newBlood.position.x += randf_range(-2.0, 2.0)
	newBlood.position.z += randf_range(-2.0, 2.0)
	newBlood.show()
	
	add_child(newBlood)
