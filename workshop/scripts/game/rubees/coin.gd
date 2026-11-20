extends pickup

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		super._on_body_entered(body)
