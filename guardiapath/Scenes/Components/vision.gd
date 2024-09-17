extends Node3D
class_name Vision

signal GetSight(body : Node3D)
signal LostSight

@export var Enabled : bool = true
@export var LookUpGroup : String = "player"

var target : Node3D
@onready var parent : Node3D = get_parent()
@onready var vision: Area3D = $Vision

func _process(delta: float) -> void:
	if not Enabled:
		return
	
	if target:
		if not CheckSight(target):
			target = null
			emit_signal("LostSight")
	else:
		CheckOverlaping()
	
	
func CheckSight(sightTarget : Node3D) -> bool:
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(parent.global_position, sightTarget.global_position)
	var collision = space.intersect_ray(query)
	if collision:
		if collision.collider == sightTarget:
			return true
	return false

func CheckOverlaping():
	var overlapingBodies = vision.get_overlapping_bodies()
	var targetOverlap = overlapingBodies.filter(func(item : Node3D) : return item.is_in_group(LookUpGroup))
	if len(targetOverlap) > 0:
		if CheckSight(targetOverlap[0]):
			target = targetOverlap[0]
			emit_signal("GetSight", target)
	
