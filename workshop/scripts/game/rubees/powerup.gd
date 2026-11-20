extends pickup

@export var powerup_name: player.POWERUPS

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		super._on_body_entered(body)
		body.powerup(self.powerup_name)
