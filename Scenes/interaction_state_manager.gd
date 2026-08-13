class_name StateManager
extends Node

var InteractionState
var GameState

enum InteractionStates {
	Normal, Spawning
}

enum GameStates {
	Deployment, Combat
}
