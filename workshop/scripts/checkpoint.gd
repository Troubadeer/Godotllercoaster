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
