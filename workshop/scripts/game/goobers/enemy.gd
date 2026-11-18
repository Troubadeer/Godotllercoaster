extends CharacterBody2D

class_name enemy

@export var drop_item: PackedScene = null

var current_health : int = 15
var current_speed : float = 0.0

func take_damage(damage : int) -> void:
	current_health -= damage
	if current_health <= 0:
		kill()
	
func kill() -> void:
	if drop_item != null:
		var drop: pickup = drop_item.instantiate()
		drop.position = position
		call_deferred("add_sibling", drop)
	
	queue_free()
