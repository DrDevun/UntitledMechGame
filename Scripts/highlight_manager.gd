extends Node

func _ready() -> void:
	$"../GridMap/HighlightMesh".visible = false

func MoveUnitHighlight(UnitPos : Vector3, TileNormal : Vector3i, SelectedUnit : Unit, IsValidTile : bool) :
	if IsValidTile :
		SelectedUnit.visible = true
		SelectedUnit.position = UnitPos + Vector3(TileNormal)
	else : SelectedUnit.visible = false
	
	

func MoveSelectorHighlight(TileLocalPos, _TileNormal, IsValidTile) :
	if IsValidTile :
		$"../GridMap/HighlightMesh".visible = true
		$"../GridMap/HighlightMesh".position = TileLocalPos
	else : 
		$"../GridMap/HighlightMesh".visible = false
	
