extends Node2D

var lives : int = 3
var coins : int = 0
var current_level : String = "res://scenes/levels/test_level_1.tscn"

var pause_menu : String = "res://scenes/menus/pause.tscn"
var game_over : String = "res://scenes/menus/game over.tscn"
var main_menu : String = "res://scenes/menus/title.tscn"

var player_ref : player
@onready var ui_layer : Node = get_tree().current_scene



# Takes in the filepath of the next level
func load_level(path : String) -> void :
	var level : Node = load(path).instantiate()

	ui_layer.get_child(0).queue_free()
	ui_layer.add_child(level)
	ui_layer.move_child(level, 0)
	current_level = name
	
func do_game_over() -> void :
	get_tree().current_scene.add_child(load(game_over).instantiate())
	
func enter_gameplay() -> void :
	get_tree().change_scene_to_file("res://scenes/ui_layer.tscn")
	await get_tree().process_frame
	await get_tree().process_frame
	ui_layer = get_tree().current_scene
	print(ui_layer)
	print(get_tree().current_scene)
	load_level("res://scenes/levels/test_level_1.tscn")
	
func pause_game(Player : player) -> void:
	if not get_tree().paused:
		player_ref = Player
		player_ref.camera.get_child(0).open()
		get_tree().paused = true
	
func unpause_game() -> void:
	if get_tree().paused:
		player_ref.camera.get_child(0).close()
		get_tree().paused = false
	
func add_coin(value : int) -> void:
	coins += value
	if coins >= 10:
		if lives < 99:
			lives += 1
		coins -= 10

func go_to_title() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/title.tscn")

func close_game() -> void:
	get_tree().quit()
	
