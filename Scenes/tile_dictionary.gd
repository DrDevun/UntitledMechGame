extends Node

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
		_ : 
			return null
