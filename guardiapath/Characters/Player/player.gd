extends CharacterBody3D
class_name Player

@export var Hp : int = 1000
@onready var weapon_sword: WeaponSword = $Geometry/WeaponSword
@onready var hp_label: Label = $Control/HpLabel
@onready var interaction_arm_pivot: Node3D = $Geometry/InteractionArmPivot
@onready var first_person_controler_3d: FirstPersonControler3D = $FirstPersonControler3D
@onready var interaction_sprite: Sprite3D = $Geometry/InteractionArmPivot/InteractionArm/InteractionGroup/InteractionSprite

var normalWalkSpeed : float = 0
var normalSprintSpeed : float = 0
var normalAtack : int = 25
var atackBoost : int = 0

var speedBoostTimer : float = 0
var atackBoostTimer : float = 0


var itemInRange : ItemBase = null

func _ready() -> void:
	hp_label.text = str(Hp)
	normalWalkSpeed = first_person_controler_3d.Speed_Walk
	normalSprintSpeed = first_person_controler_3d.Speed_Sprint

func _process(delta: float) -> void:
	if speedBoostTimer > 0:
		speedBoostTimer -= delta
		if speedBoostTimer <= 0:
			first_person_controler_3d.Speed_Walk = normalWalkSpeed
			first_person_controler_3d.Speed_Sprint = normalSprintSpeed
	
	if atackBoostTimer > 0:
		atackBoostTimer -= delta
		if atackBoostTimer <= 0:
			atackBoost = 0

func DamageTake(value : int):
	Hp -= value
	hp_label.text = str(Hp)
	if Hp <= 0:
		get_tree().quit()
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("atack") and !weapon_sword.atacking:
		weapon_sword.Atack()
	
	if Input.is_action_just_pressed("interact") and itemInRange != null:
		Interact()
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:        
		interaction_arm_pivot.rotate_x(-(event as InputEventMouseMotion).relative.y * first_person_controler_3d.Mouse_Sensitivity)
		interaction_arm_pivot.rotation.x = clamp(interaction_arm_pivot.rotation.x, deg_to_rad(first_person_controler_3d.Min_Camera_Angle), deg_to_rad(first_person_controler_3d.Max_Camera_Angle))

func Interact():
	var commands = itemInRange.GetCommandList()
	for command in commands:
		match command.Property:
			ItemCommand.PropertyTypes.Hp:
				Hp += command.Value
				hp_label.text = str(Hp)
			ItemCommand.PropertyTypes.Speed:
				first_person_controler_3d.Speed_Walk += command.Value
				first_person_controler_3d.Speed_Sprint += command.Value
				speedBoostTimer = command.Duration
			ItemCommand.PropertyTypes.Atack:
				atackBoost = command.Value
				atackBoostTimer = command.Duration
	itemInRange.queue_free()
	itemInRange = null

func _on_weapon_sword_hit_target(body: Node3D, collisionPoint: Vector3) -> void:
	(body as Enemy).TakeDamage(normalAtack + atackBoost)

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("itens"):
		itemInRange = body
		interaction_sprite.visible = true	

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("itens"):
		itemInRange = null
		interaction_sprite.visible = false
