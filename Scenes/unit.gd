extends Node3D

func _ready() -> void: 
	position = to_global($"../GridMap".map_to_local(Vector3i(0,1,0)))
