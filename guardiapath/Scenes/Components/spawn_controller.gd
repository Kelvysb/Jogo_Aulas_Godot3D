extends Node3D
class_name SpawnController

@export var WaveCount : int = 8
@export var WaveEnemyCount : Array[int] = [1, 2, 3, 5, 8, 13, 21, 34]
@export var Enemy : String = ""
@export var EnemyGroup : String = ""

@onready var random_target_3d: RandomTarget3D = $RandomTarget3D

var currentWave : int = -1

func _process(delta: float) -> void:
	if currentWave <= (WaveCount - 1):
		var currentEnemies = get_tree().get_nodes_in_group(EnemyGroup)
		if len(currentEnemies) <= 0:
			currentWave += 1
			for index in range(WaveEnemyCount[currentWave]):
				var point = random_target_3d.GetNextPoint()
				var instance = load(Enemy).instantiate()
				get_parent().add_child(instance)
				instance.global_position = point
	
