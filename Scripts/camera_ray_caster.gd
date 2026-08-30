extends RayCast3D

signal TilePos()
signal TileType()

var LastTileHovered = []
var TileCoords : Vector3i
var TileNormal : Vector3i
var TileLocalPos : Vector3
var SelectionMode := SelectionModes.Surface
var TargetDistance := 5.0
@onready var StageAABB := AABB(Vector3.ZERO,Vector3($"../../BoardManager/BoardMaker".BoardSize))

enum SelectionModes {
	FreeMode, Surface
}

func SwitchMode() :
	if SelectionMode == SelectionModes.Surface :
		SelectionMode = SelectionModes.FreeMode
		
		if is_colliding() :
			TargetDistance = global_position.distance_to(get_collision_point())
		else : 
			TargetDistance = 5
	
	else : 
		SelectionMode = SelectionModes.Surface

func FreeMode() -> void:
	var RayOrigin := global_position
	var RayDirection := -global_basis.z.normalized()
	var RayEnd : Vector3
	var MaxTargetDistance : float
	var MinTargetDistance : float
	var ReverseRayOrigin := RayOrigin + RayDirection * 1000000
	
	var ExitIntersection = StageAABB.intersects_ray(ReverseRayOrigin, -RayDirection)
	var EntryIntersection = StageAABB.intersects_ray(RayOrigin, RayDirection)
	
	
	if EntryIntersection != null :
		#all the 0.1s are correction factors
		if StageAABB.has_point(global_position) :
			MinTargetDistance = 1
		
			MaxTargetDistance = RayOrigin.distance_to(ExitIntersection) - 0.1
			TargetDistance = clamp(TargetDistance, MinTargetDistance, MaxTargetDistance)
	
		else :
			MinTargetDistance = RayOrigin.distance_to(EntryIntersection) + 0.1
		
			#Floating point error nonsense on the AABB edge can cause a ray to have no exit
			if ExitIntersection != null :
				MaxTargetDistance = RayOrigin.distance_to(ExitIntersection) - 0.1
			else : 
				MinTargetDistance -= 0.1
				MaxTargetDistance = MinTargetDistance
			
			TargetDistance = clamp(TargetDistance, MinTargetDistance, MaxTargetDistance)
	
		RayEnd = RayOrigin + RayDirection * TargetDistance
	
		TileLocalPos = $"../../GridMap".map_to_local($"../../GridMap".local_to_map($"../../GridMap".to_local(RayEnd)))
		TileCoords = $"../../GridMap".local_to_map($"../../GridMap".to_local(RayEnd))
	
		if LastTileHovered != [TileCoords, Vector3i.ZERO] :
			TilePos.emit(TileLocalPos, Vector3i.ZERO, true)
	
	else :
		TilePos.emit(TileLocalPos,Vector3i.ZERO, false)
		
	LastTileHovered = [TileCoords, Vector3i.ZERO]



func SurfaceMode() -> Array:
		#the if statement is there so it doesn't keep running when hitting nothing
		
	if is_colliding() :
		#get_collision_normal gives the facing Direction of the surface hit in the form of a vector3i
		#Multiply it by 0.001 and subtract from the get_collision_point for a correction factor because the ray hits the edge of the block
		#This pushes the read position slightly into the block to prevent misreads
		var CorrectionFactor = get_collision_normal() * 0.001
		
		#to_local is a method that converts global position into a position local to the gridmap
		#local_to_map converts local gridmap coordinates into a vector3i coresponding to  a tile's coordinates
		TileCoords = $"../../GridMap".local_to_map($"../../GridMap".to_local(get_collision_point() - CorrectionFactor))

		TileNormal = get_collision_normal()
		
		#$"../../GridMap".map_to_local(TileCoords) takes the center of the block from its coordinates
		TileLocalPos = $"../../GridMap".map_to_local(TileCoords)
		
		
		
		#only sends a signal when the tile actually changes
		if LastTileHovered != [TileCoords, TileNormal] :
			TilePos.emit(TileLocalPos, TileNormal, true)
		return [TileCoords,TileNormal]
	
	else : TilePos.emit(TileLocalPos, TileNormal, false)
	
	return LastTileHovered
	
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("MMB") :
		SwitchMode()

	
	
	if SelectionMode == SelectionModes.Surface :
		LastTileHovered = SurfaceMode()
	elif SelectionMode == SelectionModes.FreeMode :
		FreeMode()
		
		
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton : 
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed :
			if SelectionMode == SelectionModes.Surface :
				TileType.emit(TileCoords , get_collision_normal())
			elif SelectionMode == SelectionModes.FreeMode :
				TileType.emit(TileCoords, Vector3.ZERO)
				
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed :
			TargetDistance += 0.5
	
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed :
			TargetDistance -= 0.5
