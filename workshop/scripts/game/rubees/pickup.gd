extends Area2D
class_name pickup

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
