extends MeshInstance3D

func _ready() -> void:
	$"../../CameraController/CameraRayCaster".TilePos.connect(MoveHighlight)

func MoveHighlight(TileLocalPos) : 
	position = TileLocalPos
