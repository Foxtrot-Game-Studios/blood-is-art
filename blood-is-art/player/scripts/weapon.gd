extends StaticBody3D

@onready var attack_hitbox: Area3D = $AttackHitbox

var attacking: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func attack() -> void:
	attack_hitbox.monitoring = true

func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body != self:
		print("thing hit: ", body)
