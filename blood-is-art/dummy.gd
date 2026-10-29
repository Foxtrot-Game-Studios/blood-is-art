extends RigidBody3D

@onready var invincibility_timer = $InvincibilityTimer
@onready var self_mesh = $SelfMesh


#func _on_hitbox_body_entered(body: Node3D) -> void:
	#print(body.collision_layer)
	#if(body.collision_layer&3):
		#print("OW OW OW OW")
		#invincibility_timer.start()
		#self_mesh.mesh.material.albedo_color = Color(1.0, 0.0, 0.0, 1.0)



func _on_invincibility_timer_timeout() -> void:
	invincibility_timer.stop()
	self_mesh.mesh.material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)


func _on_hitbox_body_exited(body: Node3D) -> void:
	print("Out")
	print(body.collision_layer)


func _on_hitbox_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	print(area.collision_layer)
	if(area.collision_layer|3):
		print("OW OW OW OW")
		invincibility_timer.start()
		self_mesh.mesh.material.albedo_color = Color(1.0, 0.0, 0.0, 1.0)
