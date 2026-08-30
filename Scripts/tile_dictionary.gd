class_name TileDictionary
extends Node

class PlayerSpawner :
	pass

class TestUnit :
	var HP = 10

class Dirt : 
	var HP = 1

class Stone : 
	var HP = 3
	
class Empty :
	pass

func Translator(TileID) :
	match TileID :
		0 :
			return PlayerSpawner
		1 :
			return Dirt.new()
		2 :
			return Stone.new()
		-1 : 
			return Empty
