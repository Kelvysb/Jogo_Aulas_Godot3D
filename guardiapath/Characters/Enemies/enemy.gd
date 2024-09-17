extends CharacterBody3D

enum States {
	Walking,
	Pursuit
}

@export var walkSpeed : float = 2.0
@export var runSpeed : float = 10.0

@onready var follow_target: FollowTarget = $FollowTarget
@onready var walk_around: WalkAround = $WalkAround
@onready var vision: Vision = $Vision

var state : States = States.Walking
var target : Node3D

func _ready() -> void:
	ChangeState(States.Walking)

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func ChangeState(newState : States) -> void:
	state = newState
	match state:
		States.Walking:
			follow_target.ClearTarget()
			follow_target.Speed = walkSpeed
			follow_target.SetFixedTarget(walk_around.GetNextPoint())
			target = null
		States.Pursuit:
			follow_target.Speed = runSpeed
			follow_target.SetTarget(target)

func _on_follow_target_navigation_finished() -> void:
	follow_target.SetFixedTarget(walk_around.GetNextPoint())

func _on_vision_get_sight(body: Node3D) -> void:
	target = body
	ChangeState(States.Pursuit)

func _on_vision_lost_sight() -> void:
	ChangeState(States.Walking)
