extends Node

var InteractionState : int
var GameState : int
var TurnOwner : int
var TurnCounter : int = 0

enum InteractionStates {
	Selecting, Placing
}

enum GameStates {
	Deployment, Combat
}

enum Turn {
	Player, Enemy
}


	

func _ready() :
	$"../CameraController/CameraRayCaster".TileType.connect(HandleClick)
	$"../CameraController/CameraRayCaster".TilePos.connect(HandleHover)
	$"../CombatUI/TurnUI/VBoxContainer/EndTurn".pressed.connect(EndTurn)
	
	
	GameState = GameStates.Deployment
	InteractionState = InteractionStates.Placing

	#Handle E
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("OpenTurnUI") :
		if CanOpenTurnUI() :
			$"../CombatUI/TurnUI".ShowUI()
	
	if CanRotateUnit() :
		if Input.is_action_just_pressed("Rotate+x") :
			$"../CombatManager".RotateUnit(Vector3i(1,0,0))
		if Input.is_action_just_pressed("Rotate-x") :
			$"../CombatManager".RotateUnit(Vector3i(-1,0,0))
		if Input.is_action_just_pressed("Rotate+y") :
			$"../CombatManager".RotateUnit(Vector3i(0,1,0))
		if Input.is_action_just_pressed("Rotate-y") :
			$"../CombatManager".RotateUnit(Vector3i(0,-1,0))
		if Input.is_action_just_pressed("Rotate+z") :
			$"../CombatManager".RotateUnit(Vector3i(0,0,+1))
		if Input.is_action_just_pressed("Rotate-z") :
			$"../CombatManager".RotateUnit(Vector3i(0,0,-1))

func NextTurn () :
	
	TurnCounter += 1
	if TurnCounter == 1 :
		$"../BoardManager".RemoveSpawners()
		GameState = GameStates.Combat

	match TurnCounter % 2 :
		0 : 
			TurnOwner = Turn.Player
			print("PLAYER TURN")

		1 : 
			TurnOwner = Turn.Enemy
			print("ENEMY TURN")



func EndTurn () :
	if GameState == GameStates.Deployment && InteractionState == InteractionStates.Selecting :
		print("TURN ENDED")
		NextTurn()
	else :
		print("CANNOT END TURN")
	$"../CombatUI/TurnUI".hide()

func CanRotateUnit() :
	if InteractionState == InteractionStates.Placing && GameState == GameStates.Deployment :
		return true
	return false

func CanOpenTurnUI () :
	if InteractionState != InteractionStates.Placing :
		return true
	return false 

func CanHighlightUnit() -> bool :
	if GameState == GameStates.Deployment && InteractionState == InteractionStates.Placing :
		return true
	return false

func CanHighlight () -> bool :
	if InteractionState != InteractionStates.Placing :
		return true
	return false
	
func CanPlaceUnit() -> bool :
	if GameState == GameStates.Deployment && InteractionState == InteractionStates.Placing :
		return true
	return false

func CanSelectUnit() -> bool :
	if GameState == GameStates.Deployment && InteractionState == InteractionStates.Selecting :
		return true
	return false

func CanAct () -> bool :
	if GameState == GameStates.Combat && InteractionState == InteractionStates.Selecting :
		return true
	return false



func HandleHover(TilePos : Vector3, TileNormal : Vector3i, IsValidTile : bool) :
	if CanHighlightUnit() :
		$"../HighlightManager".MoveUnitHighlight(TilePos, TileNormal, $"../CombatManager".SelectedUnit, IsValidTile)
	
	if CanHighlight() :
		$"../HighlightManager".MoveSelectorHighlight(TilePos, TileNormal, IsValidTile)
	else : $"../GridMap/HighlightMesh".visible = false

func HandleClick(TileCoords : Vector3i, TileNormal : Vector3i) :
	
	#If an action can fail, its function has a bool return type
	#S that it doesnt change game state upon fail
	if CanPlaceUnit() :
		if $"../CombatManager".PlaceUnit(TileCoords, TileNormal) :
			InteractionState = InteractionStates.Selecting
	
	elif CanSelectUnit() :
		if $"../CombatManager".SelectUnit(TileCoords, TileNormal) :
			InteractionState = InteractionStates.Placing

	elif CanAct() :
		$"../CombatUI/UnitUI".ShowUI(TileCoords, TileNormal)
