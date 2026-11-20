extends Node2D

@onready var strobe : ColorRect = $ColorRect
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var background_tween : Tween = create_tween()
@onready var element_tween : Tween = create_tween()

func _ready() -> void :
	modulate_all_the_colors()
	fade_in()
	
func modulate_all_the_colors() -> void :
	background_tween.tween_property(strobe, "color", Color(rng.randf(), rng.randf(), rng.randf(), 0.7), 3.5)
	await get_tree().create_timer(3.5).timeout
	background_tween.kill()
	modulate_all_the_colors()
		
func fade_in() -> void:
	for child in get_children():
		element_tween.tween_property(child, "modulate:a", 1.0, 0.2)
		await get_tree().create_timer(0.2).timeout
		element_tween.kill()

func _on_exit_game_pressed() -> void:
	GameManager.close_game()
	
func _on_resume_pressed() -> void:
	GameManager.unpause_game()

func _on_title_screen_pressed() -> void:
	GameManager.go_to_title()
