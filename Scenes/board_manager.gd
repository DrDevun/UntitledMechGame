extends Node

var LastSelectedTile = null
var LastSelectedTileCoords = null
var LastSelectedTileNormal = null

func _ready() -> void:
	$"../CameraController/CameraRayCaster".TileType.connect(TileSelector)
	$"../CombatUI/UnitUI/VBoxContainer/Move".pressed.connect(OnMoveButtonPressed)
	
func TileSelector(TileCoords, TileNormal) : 
	LastSelectedTile = $BoardMaker.Board[TileCoords.x][TileCoords.y][TileCoords.z]
	LastSelectedTileCoords = TileCoords
	LastSelectedTileNormal = TileNormal

func MoveObject (OldCoords : Vector3i, NewCoords : Vector3i) : 
	$BoardMaker.Board[NewCoords.x][NewCoords.y][NewCoords.z] = LastSelectedTile
	$BoardMaker.Board[OldCoords.x][OldCoords.y][OldCoords.z] = null

func MoveObjectByMouse (OldCoords : Vector3i, NewCoords : Vector3i, TileNormal : Vector3i) :
	$BoardMaker.Board[NewCoords.x + TileNormal.x][NewCoords.y + TileNormal.y][NewCoords.z + TileNormal.z] = LastSelectedTile
	$BoardMaker.Board[OldCoords.x][OldCoords.y][OldCoords.z] = null
	$"../Unit".position = $"../GridMap".map_to_local(NewCoords) + Vector3(TileNormal)

func OnMoveButtonPressed() :
	var OldCoords = LastSelectedTileCoords
	var Unit = LastSelectedTile
	await $"../CameraController/CameraRayCaster".TileType
	if LastSelectedTile is not TileDictionary.TestUnit :
		LastSelectedTile = Unit
		MoveObjectByMouse(OldCoords, LastSelectedTileCoords, LastSelectedTileNormal)
		LastSelectedTile = null

	
