extends CharacterBody3D
class_name Player

@export var Hp : int = 1000
@onready var weapon_sword: WeaponSword = $Geometry/WeaponSword
@onready var hp_label: Label = $SubViewport/Control/HpLabel

func _ready() -> void:
	hp_label.text = str(Hp)

func DamageTake(value : int):
	Hp -= value
	hp_label.text = str(Hp)
	if Hp <= 0:
		get_tree().quit()
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("atack") and !weapon_sword.atacking:
		weapon_sword.Atack()

func _on_weapon_sword_hit_target(body: Node3D, collisionPoint: Vector3) -> void:
	(body as Enemy).TakeDamage(25)
