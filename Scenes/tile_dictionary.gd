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

func Translator(TileID) :
	match TileID :
		0 :
			return PlayerSpawner.new()
		1 :
			return Dirt.new()
		3 :
			return Stone.new()
		_ : 
			return null
