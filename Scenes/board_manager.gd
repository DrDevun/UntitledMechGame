extends Node

var LastClickedObject = null
var ObjectPreviousCoords = null

func _ready() -> void:
	$"../CameraController/CameraRayCaster".TileType.connect(ObjectSelector)

func MoveObjectTo(TileCoords, TileNormal) :
	$BoardMaker.Board[TileCoords.x + TileNormal.x][TileCoords.y + TileNormal.y][TileCoords.z + TileNormal.z] = LastClickedObject
	$BoardMaker.Board[ObjectPreviousCoords.x][ObjectPreviousCoords.y][ObjectPreviousCoords.z] = null
	$"../Unit".position = $"../GridMap".map_to_local(TileCoords) + TileNormal
	
func ObjectSelector(TileCoords, TileNormal) :
	
	if LastClickedObject != null :
		MoveObjectTo(TileCoords, TileNormal)
		LastClickedObject = null

	if $BoardMaker.Board[TileCoords.x][TileCoords.y][TileCoords.z] is TileDictionary.TestUnit :
		LastClickedObject = $BoardMaker.Board[TileCoords.x][TileCoords.y][TileCoords.z]
		ObjectPreviousCoords = TileCoords
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("RMB") :
		print($BoardMaker.Board[0][1][0])
		print($BoardMaker.Board[0][1][1])
		print($BoardMaker.Board[0][0][1])
		

	
