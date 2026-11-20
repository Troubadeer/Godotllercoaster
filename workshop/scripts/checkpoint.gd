extends Sprite2D

var active : bool
# Called when the node enters the scene tree for the first time.
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not active and body is player:
		get_parent().current_checkpoint = self
		active = true
		if self == get_parent().goal:
			if get_parent().next_level == "fin":
				GameManager.go_to_title()
			else:
				GameManager.load_level(get_parent().next_level)
		
		$AnimationPlayer.play("flag_gotten")
		await get_tree().create_timer(3).timeout
		$AnimationPlayer.play("flag_happy_idle")
