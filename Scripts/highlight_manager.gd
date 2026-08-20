extends Node

func HighlightUnit(UnitPos : Vector3, TileNormal : Vector3i, SelectedUnit) :
	if $"../BoardManager".GetTileType(Vector3i(UnitPos)) is TileDictionary.PlayerSpawner :
		SelectedUnit.position = UnitPos
	else :
		SelectedUnit.position = UnitPos + Vector3(TileNormal)
