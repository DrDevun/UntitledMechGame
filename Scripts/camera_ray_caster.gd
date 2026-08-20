extends RayCast3D

signal TilePos()
signal TileType()

var LastTileHovered = []
var TileCoords : Vector3i
var TileNormal : Vector3i

func RayCast() :
		#the if statement is there so it doesn't keep running when hitting nothing
		
	if is_colliding() :
		#get_collision_normal gives the facing direction of the surface hit in the form of a vector3i
		#Multiply it by 0.001 and subtract from the get_collision_point for a correction factor because the ray hits the edge of the block
		#This pushes the read position slightly into the block to prevent misreads
		var CorrectionFactor = get_collision_normal() * 0.001
		
		#to_local is a method that converts global position into a position local to the gridmap
		#local_to_map converts local gridmap coordinates into a vector3i coresponding to  a tile's coordinates
		TileCoords = $"../../GridMap".local_to_map($"../../GridMap".to_local(get_collision_point() - CorrectionFactor))

		TileNormal = get_collision_normal()
		
		#$"../../GridMap".map_to_local(TileCoords) takes the center of the block from its coordinates
		var TileLocalPos = $"../../GridMap".map_to_local(TileCoords)
		
		
		
		#only sends a signal when the tile actually changes
		if LastTileHovered != [TileCoords, TileNormal] :
			TilePos.emit(TileLocalPos, TileNormal)
		
		return [TileCoords,TileNormal]
		
func _process(_delta: float) -> void:
	LastTileHovered = RayCast()
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton : 
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed :
			TileType.emit(TileCoords , get_collision_normal())
