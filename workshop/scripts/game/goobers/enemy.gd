extends CharacterBody2D

class_name enemy

var current_health : int = 15
var current_speed : float = 0.0

func take_damage(damage : int) -> void:
	current_health -= damage
	if current_health <= 0:
		kill()
	
func kill() -> void:
	queue_free()
