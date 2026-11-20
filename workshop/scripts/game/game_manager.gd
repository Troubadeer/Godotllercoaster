extends Node2D

var lives : int = 3
var coins : int = 0
var current_level : String = "res://scenes/levels/test_level_1.tscn"

var pause_menu : String = "res://scenes/menus/pause.tscn"
var game_over : String = "res://scenes/menus/game over.tscn"
var main_menu : String = "res://scenes/menus/title.tscn"
var ui_layer : Node2D

# Takes in the filepath of the next level
func load_level(name : String) -> void :
	var level : Node = load(name).instantiate()
	
	ui_layer.get_child(0).queue_free()
	ui_layer.add_child(level)
	ui_layer.move_child(level, 0)
	current_level = name
	
func do_game_over() -> void :
	get_tree().current_scene.add_child(load(game_over).instantiate())
	
func enter_gameplay() -> void :
	get_tree().change_scene_to_file("res://scenes/ui_layer.tscn")
	load_level("res://scenes/levels/test_level_1.tscn")
	
func pause_game() -> void:
	if not get_tree().paused:
		get_tree().paused = true
		var paws : Node = load(pause_menu).instantiate()
		ui_layer.add_child(paws)
		ui_layer.move_child(paws, 1)
	
func unpause_game() -> void:
	if get_tree().paused:
		get_tree().paused = false
		ui_layer.get_child(1).queue_free()
	
func add_coin(value : int) -> void:
	coins += value
	if coins >= 10:
		if lives < 99:
			lives += 1
		coins -= 10

func go_to_title() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/title.tscn")

func close_game() -> void:
	get_tree().quit
	
