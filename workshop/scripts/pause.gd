extends Node2D

@onready var strobe : ColorRect = $ColorRect
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var background_tween : Tween
@onready var element_tween : Tween

func open() -> void :
	visible = true
	modulate_all_the_colors()
	for child in get_children():
		await fade_in(child)

func close() -> void :
	visible = false
	for child in get_children():
		child.modulate.a = 0.0
	
func modulate_all_the_colors() -> void :
	background_tween = create_tween()
	background_tween.tween_property(strobe, "color", Color(rng.randf(), rng.randf(), rng.randf(), 0.7), 3.5)
	await get_tree().create_timer(3.5).timeout
	background_tween.kill()
	if visible:
		modulate_all_the_colors()
		
func fade_in(child : Node) -> void:
	element_tween = create_tween()
	element_tween.tween_property(child, "modulate:a", 1.0, 0.20)
	await get_tree().create_timer(0.2).timeout

func _on_exit_game_pressed() -> void:
	GameManager.close_game()
	
func _on_resume_pressed() -> void:
	GameManager.unpause_game()

func _on_title_screen_pressed() -> void:
	get_tree().paused = false
	GameManager.go_to_title()
