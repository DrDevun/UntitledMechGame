extends PanelContainer

@export var DistanceMax := 10.0
@export var ScaleFactor := 2.0

var UIPos : Vector2
var UIPos3D: Vector3
func _ready() -> void:
	hide()

func ShowUI () :
	if is_visible_in_tree() :
		hide()
	else :
		#Gets the camera's position, shifts it along -z a bit because godot's cam looks along -z
		UIPos3D = $"../../CameraController/CameraTarget/PlayerCamera". global_position + (-$"../../CameraController/CameraTarget/PlayerCamera".global_transform.basis.z * 5)
		show()

func _process(_delta: float) -> void:
	
	#checks if the UI is actually active
	if is_visible_in_tree() :
		
		#Then sets the UI position to the previous screen center
		UIPos = $"../../CameraController/CameraTarget/PlayerCamera".unproject_position(UIPos3D)
		
		#-size/2 puts the UI in the exact center of screen
		position = UIPos - size/2
	#hides UI if offscreen
	if not get_viewport_rect().has_point(position) : 
		hide()
