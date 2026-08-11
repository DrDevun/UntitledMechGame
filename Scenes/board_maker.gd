extends Node

#The logical board is a series of nested arrays.
#This script first declares an empty array
var Board = []

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
	var MaxY = $"../../GridMap".get_used_cells()[0].y
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
	
func LoadBoard() :
	Board = (CreateBoard(FindBoardSize()))
	
	for Coord in $"../../GridMap".get_used_cells() :
		var TileID = $"../../GridMap".get_cell_item(Coord)
		Board[Coord.x][Coord.y][Coord.z] = $"../TileDictionary".Translator(TileID)
	
	#just a unit test
	(Board[0][1][0]) = $"../TileDictionary".Translator(2)
	
	return Board

func _ready() -> void:
	Board = LoadBoard()
