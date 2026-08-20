extends Node3D

@export var MoveSpeed := 20
@export var MouseSens := 0.001

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		rotation.y -= (event.relative.x * MouseSens)
		rotation.x -= (event.relative.y * MouseSens)
		rotation.x = clamp(rotation.x , -9*PI/20 , 9*PI/20)

func _process(delta: float) -> void:
	var HorizontalInput := Input.get_vector("Left" , "Right" , "Forward" , "Backward")
	var Direction := Vector3(HorizontalInput.x , 0, HorizontalInput.y)
	Direction = Direction.rotated(Vector3.UP, rotation.y)
	position += Direction * delta * MoveSpeed
	
	var VerticalInput = Input.get_axis("Down", "Up")
	position.y += VerticalInput * MoveSpeed * delta
