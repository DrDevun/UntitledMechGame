extends Node

var LastSelectedTile = null
var LastSelectedTileCoords = null
var LastSelectedTileNormal = null

func _ready() -> void:
	$"../CameraController/CameraRayCaster".TileType.connect(TileSelector)
	$"../CombatUI/UnitUI/VBoxContainer/Move".pressed.connect(OnMoveButtonPressed)

func ValidateTile (TileCoords : Vector3i) :
	if TileCoords.x < 0 or TileCoords.x >= $BoardMaker.BoardSize.x or TileCoords.y < 0 or TileCoords.y >= $BoardMaker.BoardSize.y or TileCoords.z < 0 or TileCoords.z >= $BoardMaker.BoardSize.z :
		print(TileCoords)
		assert(false)

func RemoveSpawners() :
	for Coords in $BoardMaker.PlayerSpawnerCoords :
		if GetTileType(Coords) is TileDictionary.PlayerSpawner :
			SetTile(Coords, null)
		$"../GridMap".set_cell_item(Coords, -1, 0)
	$"../PlayerSpawners".queue_free()

func TileSelector(TileCoords, TileNormal) : 
	LastSelectedTile = GetTileType(TileCoords)
	LastSelectedTileCoords = TileCoords
	LastSelectedTileNormal = TileNormal

func SetTile (TileCoords : Vector3i, TileType) :
	ValidateTile(TileCoords)
	$BoardMaker.Board[TileCoords.x][TileCoords.y][TileCoords.z] = TileType

func GetTileType (TileCoords : Vector3i) -> Object:
	ValidateTile(TileCoords)
	return $BoardMaker.Board[TileCoords.x][TileCoords.y][TileCoords.z]

func MoveObject (OldCoords : Vector3i, NewCoords : Vector3i) : 
	SetTile(NewCoords, LastSelectedTile)
	SetTile(OldCoords, null)

func MoveObjectByMouse (OldCoords : Vector3i, NewCoords : Vector3i, TileNormal : Vector3i) :
	SetTile(NewCoords + TileNormal, LastSelectedTile)
	SetTile(OldCoords, null)
	$"../Unit".position = $"../GridMap".map_to_local(NewCoords) + Vector3(TileNormal)

func OnMoveButtonPressed() :
	var OldCoords = LastSelectedTileCoords
	var SelectedUnit = LastSelectedTile
	await $"../CameraController/CameraRayCaster".TileType
	if LastSelectedTile is not TileDictionary.TestUnit :
		LastSelectedTile = SelectedUnit
		MoveObjectByMouse(OldCoords, LastSelectedTileCoords, LastSelectedTileNormal)
		LastSelectedTile = null
