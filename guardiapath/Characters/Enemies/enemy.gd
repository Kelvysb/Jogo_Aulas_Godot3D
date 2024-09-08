extends CharacterBody3D

const speed = 5.0
const turnSpeed = 0.3
var target : Node3D
var isTargetSet : bool = false
var lastTargetPosition : Vector3 = Vector3.ZERO

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	isTargetSet = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if target:
		go_to_location(target.global_position)	
	
	move_and_slide()
	
func go_to_location(targetPosition : Vector3):
	if not isTargetSet or lastTargetPosition != targetPosition:
		navigation_agent_3d.set_target_position(targetPosition)
		lastTargetPosition = targetPosition
		isTargetSet = true
		
	var lookDir = atan2(-velocity.x, -velocity.z)
	rotation.y = lerp_angle(rotation.y, lookDir, turnSpeed)
	
	if navigation_agent_3d.is_navigation_finished():
		isTargetSet = false
		return
	
	var nextPathPosition = navigation_agent_3d.get_next_path_position()
	var currentEnemyPosition = global_position
	var newVelocity = (nextPathPosition - currentEnemyPosition).normalized() * speed
	
	if navigation_agent_3d.avoidance_enabled:
		navigation_agent_3d.set_velocity(newVelocity.move_toward(newVelocity, 0.25))
	else:
		velocity = newVelocity.move_toward(newVelocity, 0.25)
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
		velocity = velocity.move_toward(safe_velocity, 0.25)
