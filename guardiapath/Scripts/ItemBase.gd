extends Node3D
class_name ItemBase

@export var Id : String = ""
@export var TypeId : String = ""
@export var Name : String = ""
@export var Description : String = ""
@export var ImageRef : String = ""
@export var Weight : int = 1
@export var Commands : Array[String] = []
@export var MaxStack : int = 1
@export var Consumable : bool = true

func GetCommandList() -> Array[ItemCommand]:
	var result : Array[ItemCommand]	
	for command in Commands:
		result.append(JsonClassConverter.json_string_to_class(ItemCommand, command))	
	return result
