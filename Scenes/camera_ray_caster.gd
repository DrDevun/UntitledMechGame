extends RayCast3D

signal TilePos()
signal TileType()

var LastTileHovered = null
var TileCoords
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

		#$"../../GridMap".map_to_local(TileCoords) takes the center of the block from its coordinates
		var TileLocalPos = $"../../GridMap".map_to_local(TileCoords)
		
		#only sends a signal when the tile actually changes
		if LastTileHovered != [TileCoords] :
			TilePos.emit(TileCoords , TileLocalPos)
		
		return [TileCoords]
		
func _process(delta: float) -> void:
	LastTileHovered = RayCast()
	
	if Input.is_action_just_pressed("LMB") && (get_collider() != null):
		TileType.emit(TileCoords , get_collision_normal())
