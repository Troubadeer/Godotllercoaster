extends Node2D

@onready var strobe : ColorRect = $ColorRect
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var tween : Tween = create_tween()

func _ready() -> void :
	modulate_all_the_colors()
	
func modulate_all_the_colors() -> void :
	print("hewo!!!")
	var tween : Tween = create_tween()
	tween.tween_property(strobe, "color", Color(rng.randf(), rng.randf(), rng.randf(), 0.7), 3.5)
	await get_tree().create_timer(3.5).timeout
	tween.kill()
	modulate_all_the_colors()
		
