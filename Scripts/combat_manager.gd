extends Node

var UnitCount := 2

var DeployedUnits = load("res://Scenes/unit.tscn")
var SelectedUnit = DeployedUnits.instantiate()



func _ready() -> void:
	$"..".add_child.call_deferred(SelectedUnit)



func PlaceUnit(TileCoords : Vector3i, _TileNormal: Vector3i) -> bool:
	if $"../BoardManager".GetTileType(TileCoords) is TileDictionary.PlayerSpawner :
		SelectedUnit.position = $"../GridMap".map_to_local(TileCoords)
		$"../BoardManager".SetTile(TileCoords, TileDictionary.TestUnit.new())
		$"../CameraController/CameraRayCaster".set_collision_mask_value(2, true)
		return true
	return false
	
func SelectUnit(TileCoords : Vector3i, _TileNormal: Vector3i) -> bool:
	if $"../BoardManager".GetTileType(TileCoords) is TileDictionary.TestUnit :
		$"../BoardManager".SetTile(TileCoords, TileDictionary.PlayerSpawner.new())
		$"../CameraController/CameraRayCaster".set_collision_mask_value(2, false)
		return true
	return false
