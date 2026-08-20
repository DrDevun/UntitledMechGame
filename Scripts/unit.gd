class_name Unit
extends Node3D

var Components : Array[UnitComponent] = []

func AddComponent(Type : PackedScene, Coords : Vector3i, Rotation : Vector3) :
	
	#Logical data
	var Component := Type.instantiate() as UnitComponent
	Component.Rotation = Rotation
	Component.Position = Coords
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
