extends Node3D

@export var MoveSpeed := 20
@export var MouseSens := 0.001

func RayCast() -> void:
	var Camera := $CameraTarget/PlayerCamera
	#var ScreenCenter := get_viewport().get_visible_rect().get_center()
	#that line above was to get screen center. God knows why it makes godot angry when fed into project_ray_origin and project_ray_normal.
	#Project_ray_origin converts the vector2 ScreenCenter to a Vector 3 of the camera's position.
	#Yes you can just Camera.global_position but project_ray_origin is good generality practice
	var RayOrigin = Camera.project_ray_origin(get_viewport().get_visible_rect().get_center())
	var RayDirection = Camera.project_ray_normal(get_viewport().get_visible_rect().get_center())
	#That PhysicsRayQueryParameters3D.create casts a ray from RayOrigin to RayOrigin + RayDirection * 1000 the same way a vector gets added (another vector * a magnitude)
	var RayQuery = PhysicsRayQueryParameters3D.create(RayOrigin , RayOrigin + (RayDirection * 1000))
	RayQuery.collision_mask = 1
	var RayResult = get_world_3d().direct_space_state.intersect_ray(RayQuery)
	
	#just testing what the ray hits
	print("RayOrigin : ", RayOrigin)
	print("RayDirection : ", RayDirection)
	print("RayEnd : ", (RayOrigin + RayDirection) * 1000)
	print("RayResult : ", RayResult)

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
	
	if Input.is_action_just_pressed("LMB") : 
		RayCast()
