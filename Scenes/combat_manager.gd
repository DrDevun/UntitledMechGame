extends Node

var UnitCount := 2

var Unit = load("res://Scenes/unit.tscn")
var SelectedUnit = Unit.instantiate()



func _ready() -> void:
	$"../CameraController/CameraRayCaster".TilePos.connect(MoveHighlight)
	$"../CameraController/CameraRayCaster".TileType.connect(PlaceUnit)
	$"..".add_child.call_deferred(SelectedUnit)
	$"../StateManager".GameState = StateManager.GameStates.Deployment
	$"../StateManager".InteractionState = StateManager.InteractionStates.Spawning

func _process(delta: float) -> void :
	pass

func PlaceUnit(TileCoords : Vector3i, TileNormal : Vector3i) :
	if $"../BoardManager".GetTileType(TileCoords) is TileDictionary.PlayerSpawner :
		$"../StateManager".GameState = StateManager.GameStates.Combat
		
		for Coords in $"../BoardManager/BoardMaker".PlayerSpawnerPositions :
			$"../BoardManager".SetTile(TileCoords, null)

		SelectedUnit.position = $"../GridMap".map_to_local(TileCoords)
		$"../BoardManager".SetTile(TileCoords, TileDictionary.TestUnit.new())
		
		if  $"../BoardManager".GetTileType(TileCoords) is TileDictionary.TestUnit :
			print(1)

		$"../PlayerSpawners".queue_free()
		
		$"../StateManager".InteractionState = StateManager.InteractionStates.Normal

func MoveHighlight(TileLocalPos : Vector3) : 
	if $"../StateManager".GameState == StateManager.GameStates.Deployment && $"../StateManager".InteractionState == StateManager.InteractionStates.Spawning:
		SelectedUnit.position = TileLocalPos
