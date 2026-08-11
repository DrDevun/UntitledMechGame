extends MeshInstance3D

func _ready() -> void:
	$"../../CameraController/CameraRayCaster".TileInfo.connect(MoveHighlight)

func MoveHighlight(TileType, TileCoords, TileLocalPos) : 
	position = TileLocalPos
