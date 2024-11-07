extends Node3D
class_name WeaponSword

signal HitTarget(body : Node3D, collisionPoint : Vector3)

@export var TargetGroups : Array[String] = [] 

@onready var contact_area: Area3D = $Pivot/Sword/ContactArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var atacking : bool = false


func Atack():
	atacking = true
	animation_player.play("Atack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	atacking = false


func _on_contact_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if TargetGroups.any(func(group : String) : return area.is_in_group(group)) and atacking:
		var area_space: RID = PhysicsServer3D.area_get_space(contact_area.get_rid())
		var space_state: PhysicsDirectSpaceState3D = PhysicsServer3D.space_get_direct_state(area_space)
		var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
		query.set_shape(area.shape_owner_get_owner(area_shape_index).shape)
		var collision_points: Array = space_state.collide_shape(query)
		if len(collision_points) > 0:
			emit_signal("HitTarget", area.get_parent_node_3d(), collision_points[0])
		else:
			emit_signal("HitTarget", area.get_parent_node_3d(), area.get_parent_node_3d().global_position)
		
