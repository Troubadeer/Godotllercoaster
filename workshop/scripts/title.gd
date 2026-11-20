extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.play_track(1)





func _on_exit_button_pressed() -> void:
	GameManager.close_game()

func _on_start_button_pressed() -> void:
	GameManager.enter_gameplay()
