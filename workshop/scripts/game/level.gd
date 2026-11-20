extends Node2D

var player_instance : PackedScene = preload("res://scenes/goobers/player.tscn")
@onready var gamer : player = get_child(0)

@export var starting_checkpoint : Sprite2D
@export var goal : Sprite2D
@export var kill_height : float

@onready var current_checkpoint : Sprite2D = starting_checkpoint
	
func reset_player() -> void:
	gamer = player_instance.instantiate()
	gamer.position = current_checkpoint.position
	add_child(gamer)
