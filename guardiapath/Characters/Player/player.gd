extends CharacterBody3D
class_name Player

@export var Hp : int = 1000
@onready var weapon_sword: WeaponSword = $Geometry/WeaponSword
@onready var hp_label: Label = $Control/HpLabel
@onready var interaction_arm_pivot: Node3D = $Geometry/InteractionArmPivot
@onready var third_person_controler_3d: ThirdPersonControler3D = $ThirdPersonControler3D
@onready var action_indicator: TextureRect = $Control/ActionIndicator
@onready var inventory: Inventory = $Inventory

var normalWalkSpeed : float = 0
var normalSprintSpeed : float = 0
var normalAtack : int = 25
var atackBoost : int = 0
var speedBoostTimer : float = 0
var atackBoostTimer : float = 0
var itemInRange : ItemBase = null

func _ready() -> void:
	hp_label.text = str(Hp)
	normalWalkSpeed = third_person_controler_3d.Speed_Walk
	normalSprintSpeed = third_person_controler_3d.Speed_Sprint

func _process(delta: float) -> void:
	if speedBoostTimer > 0:
		speedBoostTimer -= delta
		if speedBoostTimer <= 0:
			third_person_controler_3d.Speed_Walk = normalWalkSpeed
			third_person_controler_3d.Speed_Sprint = normalSprintSpeed
	
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
		
	if Input.is_action_just_pressed("Item1"):
		UseItem(0)
	if Input.is_action_just_pressed("Item2"):
		UseItem(1)
	if Input.is_action_just_pressed("Item3"):
		UseItem(2)
	if Input.is_action_just_pressed("Item4"):
		UseItem(3)
	if Input.is_action_just_pressed("Item5"):
		UseItem(4)
	if Input.is_action_just_pressed("Item6"):
		UseItem(5)
	if Input.is_action_just_pressed("Item7"):
		UseItem(6)
	if Input.is_action_just_pressed("Item8"):
		UseItem(7)

func Interact():
	if inventory.AddItem(itemInRange):	
		itemInRange.get_parent().remove_child(itemInRange)


func UseItem(index : int):
	var item = inventory.UseItem(index)
	if item:
		var commands = item.GetCommandList()
		for command in commands:
			match command.Property:
				ItemCommand.PropertyTypes.Hp:
					Hp += command.Value
					hp_label.text = str(Hp)
				ItemCommand.PropertyTypes.Speed:
					third_person_controler_3d.Speed_Walk += command.Value
					third_person_controler_3d.Speed_Sprint += command.Value
					speedBoostTimer = command.Duration
				ItemCommand.PropertyTypes.Atack:
					atackBoost = command.Value
					atackBoostTimer = command.Duration
	

func _on_weapon_sword_hit_target(body: Node3D, collisionPoint: Vector3) -> void:
	(body as Enemy).TakeDamage(normalAtack + atackBoost)

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("itens"):
		itemInRange = body
		action_indicator.visible = true	

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("itens"):
		itemInRange = null
		action_indicator.visible = false
