extends Node2D

func _on_title_button_pressed() -> void:
	GameManager.go_to_title()

func _on_exit_game_pressed() -> void:
	GameManager.close_game()
