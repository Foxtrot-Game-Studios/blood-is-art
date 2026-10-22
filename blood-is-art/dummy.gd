extends RigidBody3D

@onready var invincibility_timer = $InvincibilityTimer
@onready var self_mesh = $SelfMesh


func _on_hitbox_body_entered(body: Node3D) -> void:
	if(body.collision_layer==1):
		print("OW OW OW OW ")
		invincibility_timer.start()
		self_mesh.mesh.material.albedo_color = Color(1.0, 0.0, 0.0, 1.0)



func _on_invincibility_timer_timeout() -> void:
	invincibility_timer.stop()
	self_mesh.mesh.material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
