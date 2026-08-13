extends PanelContainer

@export var DistanceMax := 10.0
@export var ScaleFactor := 2.0


func _ready() -> void:
	$"../../CameraController/CameraRayCaster".TileType.connect(ShowUI)
	hide()
	
func ShowUI(TileType, TileNormal) :
	hide()
	#Checks if the RayCast hits a unit and if its the right interactionstate
	if $"../../BoardManager/BoardMaker".Board[TileType.x][TileType.y][TileType.z] is TileDictionary.TestUnit && $"../../StateManager".InteractionState == StateManager.InteractionStates.Normal:
		show()
	else :
		hide()

func _process(delta: float) -> void:
	
	#checks if the UI is actually active
	if is_visible_in_tree() :
		#Gets the position of the unit and projects it onto the screen
		#Then sets the UI position to it.
		position = $"../../CameraController/CameraTarget/PlayerCamera".unproject_position($"../../Unit".global_position)
		var Distance = $"../../CameraController/CameraTarget/PlayerCamera".global_position.distance_to($"../../Unit".global_position)
		
		if Distance > DistanceMax :
			ScaleFactor = DistanceMax/Distance
			
			scale = Vector2.ONE * ScaleFactor
	
	if not get_viewport_rect().has_point(position) : 
		hide()
