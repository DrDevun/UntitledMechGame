extends Node



#The logical board is a series of nested arrays.
#This script first declares an empty array
var Board = []
var PlayerSpawnerScene = preload("res://Scenes/player_spawner.tscn")
var PlayerSpawnerCoords = []



func CreateBoard (Size : Vector3i) : 
	
	#Then push or .append([])s an array (width) ammount of times, each array representing an x coordinate
	for x in range (Size.x) : 
		Board.append([])
		
		#Board[x] gets the array in index x and .append([])s a new array in each one to represent the y coordinates
		for y in range(Size.y) :
			Board[x].append([])
			
			#Board[x][y] gets the array in index x and inside, gets the array in index y, then .append(null)s null to each array represent the z coordinates
			for z in range(Size.z) :
				Board[x][y].append(null)
	return Board



func FindBoardSize() : 

	#.get_used_cells() gives an array filled with vector3is that contain the coordinates of each tile
	var MinX = $"../../GridMap".get_used_cells()[0].x
	var MinY = $"../../GridMap".get_used_cells()[0].y
	var MinZ = $"../../GridMap".get_used_cells()[0].z
	var MaxX = $"../../GridMap".get_used_cells()[0].x
	# +10 so air units can be placed far above the stage
	var MaxY = $"../../GridMap".get_used_cells()[0].y + 10
	var MaxZ = $"../../GridMap".get_used_cells()[0].z

	for Coords in $"../../GridMap".get_used_cells() :
		if Coords.x <= MinX :
			MinX = Coords.x
		if Coords.y <= MinY :
			MinY = Coords.y
		if Coords.z <= MinY :
			MinY = Coords.z
		if Coords.x >= MaxX :
			MaxX = Coords.x
		if Coords.y >= MaxY :
			MaxY = Coords.y
		if Coords.z >= MaxZ :
			MaxZ = Coords.z
	
	return Vector3i(MaxX - MinX + 1, MaxY - MinY + 1, MaxZ - MinZ + 1)




func FillPlayerSpawners(Coord : Vector3i) : 
#.instantiate() makes a new instance of the playerspawner scene
	var PlayerSpawner = PlayerSpawnerScene.instantiate()
	
	#This is in all in a for loop
	#Which means it makes as many playerspawner scenes as it needs to
	#And moves them all to the right place
	PlayerSpawner.position = $"../../GridMap".map_to_local(Coord)
	
	#Then .addchilds it to the Stage
	#call_deffered because wierd timing issues with adding multiple children on the same process
	$"../../PlayerSpawners".add_child.call_deferred(PlayerSpawner)
	
	#Then removes the spawner visual from the grid
	$"../../GridMap".set_cell_item(Coord, -1, 0)
	
	PlayerSpawnerCoords.append(Coord)



func FillBoard() :
	Board = (CreateBoard(FindBoardSize()))
	
	#Get_used_cells() generates an array containing Vector3is of all coordinates that have a tile in them
	#Then get_cell_item() gets the ID of the tile in that coordinate
	for Coord in $"../../GridMap".get_used_cells() :
		
		var TileID = $"../../GridMap".get_cell_item(Coord)

		#Checks if a tile is a player spawner
		if TileID == 0 :
			FillPlayerSpawners(Coord)
			
		#.Translator turns the tile id into actual instances of tile objects with data and puts it into the corresponding coordinate
		Board[Coord.x][Coord.y][Coord.z] = $"../TileDictionary".Translator(TileID)
	return Board



func _ready() -> void:
	Board = FillBoard()
