extends StaticBody3D

@onready var attack_hitbox: Area3D = $AttackHitbox
@onready var weaponTip: MeshInstance3D = $Tip

@onready var weaponTimer: Timer = $HitTimer

var midTransform: Vector3 = Vector3(-PI/2, 0, 0)
var startTransform: Vector3 = Vector3(0, 0, 0)

var attacking: bool = false
var cooldown: bool = false

#TODO: Change to fit animation
const attackTime = 1;
const cooldownTime = 2;
const ANIMATION_SPEED: float = 25

func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	#print(weaponTimer.is_stopped())
	pass

func attack() -> void:
	if !attacking and !cooldown:
		attack_hitbox.monitoring = true
		attack_hitbox.monitorable = true
		weaponTip.mesh.material.albedo_color = Color(1.0,0,0)
		weaponTimer.wait_time = attackTime
		attacking = true
		weaponTimer.start()
	


func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body != self:
		print("thing hit: ", body)


func _on_hit_timer_timeout() -> void:
	weaponTimer.stop()
	if attacking:
		weaponTimer.wait_time = cooldownTime
		weaponTip.mesh.material.albedo_color = Color(0.0,0,0)
		cooldown = true
		attacking = false
		attack_hitbox.monitoring = false
		attack_hitbox.monitorable = false
	elif cooldown:
		weaponTimer.wait_time=cooldownTime
		weaponTip.mesh.material.albedo_color = Color(0,1,1)
		cooldown = false
	weaponTimer.start()
		
		
func _physics_process(delta: float) -> void:
	if attacking:
		rotation = lerp(rotation, midTransform, ANIMATION_SPEED * delta)
	else:
		rotation = lerp(rotation, startTransform, ANIMATION_SPEED * delta)
		
	
