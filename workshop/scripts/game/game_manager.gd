extends Node2D

var lives : int = 3
var current_level : String

func load_level(name : String) -> void :
	var level : Node2D = load(name).instantiate()
	
