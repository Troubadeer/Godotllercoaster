extends pickup

@export var healing_amount: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		super._on_body_entered(body)
		body.heal(self.healing_amount)
