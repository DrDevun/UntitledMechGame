class_name TileDictionary
extends Node

class TestUnit :
	var HP = 10

class Dirt : 
	var HP = 1

class Stone : 
	var HP = 3

func Translator(TileID) :
	match TileID :
		0 :
			return Stone.new() 
		1 :
			return Dirt.new()
		2 :
			return TestUnit.new()
		_ : 
			return null
