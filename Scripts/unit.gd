class_name Unit
extends Node3D

var Components : Array[UnitComponent] = []
var ComponentLocalCoords : Array[Vector3i] = []
var AnchorLocalCoords := Vector3i(0,0,0)

func GetComponentLocalCoords() :
	pass
	

func GetAABB() -> AABB:
	var Min := Vector3i(-INF, -INF, -INF)
	var Max := Vector3i(INF, INF, INF)
	
	for Component in Components :
		Min.x = mini(Min.x, Component.LocalPosition.x)
		Min.y = mini(Min.y, Component.LocalPosition.y)
		Min.z = mini(Min.z, Component.LocalPosition.z)
		
		Max.x = maxi(Max.x, Component.LocalPosition.x)
		Max.y = maxi(Max.x, Component.LocalPosition.y)
		Max.z = maxi(Max.x, Component.LocalPosition.z)
		
	var Size := Max - Min

	var UnitAABB := AABB(Min, Size)
	
	return UnitAABB
	
	
func AddComponent(Type : PackedScene, Coords : Vector3i, Rotation : Vector3) :
	
	#Logical data
	var Component := Type.instantiate() as UnitComponent
	Component.LocalRotation = Rotation
	Component.LocalPosition = Coords
	Component.Owner = self
	Components.append(Component)
	
	#Physical Mesh
	add_child(Component)
	Component.position = Vector3(Coords)
	Component.rotation = Rotation

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton : 
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed :
			pass

func _ready() -> void:
	AddComponent(ComponentLibrary.Basic ,Vector3i(0,0,0), Vector3.ZERO)
	AddComponent(ComponentLibrary.Prism ,Vector3i(0,0,1), Vector3(0,PI/2,0))
	AddComponent(ComponentLibrary.Prism ,Vector3i(1,0,0), Vector3(0,PI,0))
