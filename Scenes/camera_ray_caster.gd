extends Node3D

signal TileInfo(TileType, TileGridPos, TileLocalPos)

var LastTileHovered = null

func RayCast() :
	var Camera := $"../CameraTarget/PlayerCamera"
	
	#var ScreenCenter := get_viewport().get_visible_rect().get_center()
	#that commented line above was to get screen center. 
	#God knows why it makes godot angry when fed into project_ray_origin and project_ray_normal.
	#Project_ray_origin converts the vector2 ScreenCenter to a Vector 3 of the camera's position.
	#Yes you can just Camera.global_position but project_ray_origin is good generality practice
	var RayOrigin = Camera.project_ray_origin(get_viewport().get_visible_rect().get_center())
	var RayDirection = Camera.project_ray_normal(get_viewport().get_visible_rect().get_center())
	
	#That PhysicsRayQueryParameters3D.create casts a ray from RayOrigin to RayOrigin + RayDirection * 1000 the same way a vector gets added (another vector * a magnitude)
	var RayQuery = PhysicsRayQueryParameters3D.create(RayOrigin , RayOrigin + (RayDirection * 1000))
	
	#collision_mask = 1 makes sure it actually hits the target.
	RayQuery.collision_mask = 1
	
	var RayResult = get_world_3d().direct_space_state.intersect_ray(RayQuery)
	
		#the if statement is there so it doesnt crash upon clicking air
	if !RayResult.is_empty() : 
		
		#RayResult.normal gives the facing direction of the surface hit in the form of a vector3i
		#Multiply it by 0.001 and subtract from the RayResult.position for a correction factor because the ray hits the edge of the block
		#This pushes the read position slightly into the block to prevent misreads
		var CorrectionFactor = RayResult.normal * 0.001
		
		#to_local is a method that converts global position into a position local to the gridmap
		#local_to_map converts local gridmap coordinates into a vector3i coresponding to  a tile's coordinates
		var TileCoords = $"../../GridMap".local_to_map($"../../GridMap".to_local(RayResult.position - CorrectionFactor))

		
		#$"../../GridMap".map_to_local(TileCoords) takes the center of the block from its coordinates
		var TileLocalPos = $"../../GridMap".map_to_local(TileCoords)
		
		#$"../../GridMap".get_cell_item(TileCoords) gets the type of cell at that position
		var TileType = $"../../GridMap".get_cell_item(TileCoords)
		
		#only sends a signal when the tile actually changes
		if LastTileHovered != [TileType, TileCoords] :
			TileInfo.emit(TileType, TileCoords, TileLocalPos)
		
		return [TileType, TileCoords]
		
func _process(delta: float) -> void:
	LastTileHovered = RayCast()
	
