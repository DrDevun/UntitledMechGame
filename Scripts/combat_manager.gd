extends Node

var UnitCount := 2

var DeployedUnits : PackedScene
var SelectedUnit : Unit
var SelectedUnitRef = TileDictionary.TestUnit.new()

func InitializeUnits() :
	DeployedUnits = preload("res://Scenes/unit.tscn")
	SelectedUnit = DeployedUnits.instantiate() as Unit
	$"..".add_child(SelectedUnit)
	
	
func _ready() -> void:
	
	call_deferred("InitializeUnits")
	
func UnitToGlobalCoords(Coords : Vector3i) -> Array[Vector3i]:
	
	var DelocalizedCoordArray : Array[Vector3i] = []
	for Component in SelectedUnit.Components :
		var DelocalizedCoord : Vector3i = Coords + Component.LocalPosition
		DelocalizedCoordArray.append(DelocalizedCoord)
	return DelocalizedCoordArray

func RotateUnit(RotationVector : Vector3i) -> void:
	var RotationBasis := Basis.from_euler(Vector3(
		RotationVector.x * PI/2, 
		RotationVector.y * PI/2, 
		RotationVector.z * PI/2
		))
	
	for Component in SelectedUnit.Components :
		Component.LocalPosition = Vector3i(RotationBasis * Vector3(Component.LocalPosition))
	
	SelectedUnit.basis = RotationBasis * SelectedUnit.basis

#Connects to StateManager, is called upon LMB during deployment
func PlaceUnit(TileCoords : Vector3i, TileNormal: Vector3i) -> bool:
	var AnchorLocalCoords = TileCoords + TileNormal
	
	var MaxShift := 0
	
	#somehow calculates the farthest block away from anchor in direction opposite of tile normal
	for Component in SelectedUnit.Components :
		var Distance : float = abs(Vector3(Component.LocalPosition).dot(-TileNormal))
		if Distance > MaxShift :
			MaxShift = Distance
	
	print("MaxShift = ", MaxShift)
	for Component in SelectedUnit.Components :
		print("Components = ", Component.LocalPosition)
	
	
	var GlobalCoordsArray := UnitToGlobalCoords(AnchorLocalCoords)
	var IsInvalid := false
	
	print(GlobalCoordsArray)
	
	#checks if there is an invalid tile
	for Coord in GlobalCoordsArray :
			if $"../BoardManager".GetTileType(Coord) != TileDictionary.PlayerSpawner :
				IsInvalid = true
	
	var ShiftCounter :=0
	#########################################################################################
	while ShiftCounter < MaxShift :
		if IsInvalid == false :
			break
		
		ShiftCounter += 1
		AnchorLocalCoords += TileNormal
		
		#updates the globalcoords with new shifted Anchor
		GlobalCoordsArray = UnitToGlobalCoords(AnchorLocalCoords)
		
		
		
		#checks if there is STILL an invalid tile (it's the same function)
		for Coord in GlobalCoordsArray :
			if $"../BoardManager".GetTileType(Coord) != TileDictionary.PlayerSpawner :
				IsInvalid = true
				break
			else : IsInvalid = false
	#########################################################################################
	
	if IsInvalid == false : 
		SelectedUnit.position = $"../GridMap".map_to_local(TileCoords + TileNormal * (1 + ShiftCounter))
		$"../BoardManager".SetTile(TileCoords + TileNormal * (1 + ShiftCounter), SelectedUnitRef)
		$"../CameraController/CameraRayCaster".set_collision_mask_value(2, true)
		
		#To statemanager placement was sucessful
		print("all valid")
		return true
	return false
	
func SelectUnit(TileCoords : Vector3i, _TileNormal: Vector3i) -> bool:
	if $"../BoardManager".GetTileType(TileCoords) is TileDictionary.TestUnit :
		$"../BoardManager".SetTile(TileCoords, TileDictionary.PlayerSpawner)
		$"../CameraController/CameraRayCaster".set_collision_mask_value(2, false)
		return true
	return false
