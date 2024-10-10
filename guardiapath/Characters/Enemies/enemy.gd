extends CharacterBody3D
class_name Enemy

enum States {
	Walking,
	Pursuit,
	Atacking
}

@export var walkSpeed : float = 2.0
@export var runSpeed : float = 8.0

@onready var weapon_sword: WeaponSword = $Geometry/WeaponSword
@onready var hp_label: Label = $SubViewport/Control/HpLabel
@onready var follow_target_3d: FollowTarget3D = $FollowTarget3D
@onready var simple_vision_3d: SimpleVision3D = $SimpleVision3D
@onready var random_target_3d: RandomTarget3D = $RandomTarget3D

var hp : int = 100

var state : States = States.Walking
var target : Node3D
var atacking = false

func _ready() -> void:
	ChangeState(States.Walking)

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if atacking and not weapon_sword.atacking:
		weapon_sword.Atack()

func ChangeState(newState : States) -> void:
	state = newState
	match state:
		States.Walking:
			follow_target_3d.ClearTarget()
			follow_target_3d.Speed = walkSpeed
			follow_target_3d.SetFixedTarget(random_target_3d.GetNextPoint())
			target = null
		States.Pursuit:
			follow_target_3d.Speed = runSpeed
			follow_target_3d.SetTarget(target)
		States.Atacking:
			follow_target_3d.Speed = runSpeed
			follow_target_3d.SetTarget(target)
			atacking = true
			
func TakeDamage(value : int):
	hp -= value
	hp_label.text = str(hp)
	if hp <= 0:
		queue_free()

func _on_follow_target_3d_reached_target(target: Node3D) -> void:	
	ChangeState(States.Atacking)

func _on_simple_vision_3d_lost_sight() -> void:
	ChangeState(States.Walking)

func _on_simple_vision_3d_get_sight(body: Node3D) -> void:
	target = body
	ChangeState(States.Pursuit)
	
func _on_follow_target_3d_navigation_finished() -> void:
	follow_target_3d.SetFixedTarget(random_target_3d.GetNextPoint())

func _on_weapon_sword_hit_target(body: Node3D, collisionPoint: Vector3) -> void:
	(body as Player).DamageTake(25)
