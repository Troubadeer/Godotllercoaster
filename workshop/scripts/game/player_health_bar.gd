extends Node2D

@onready var health_notches : Array = get_children()
@onready var life_label : Label = $Label

func _ready() -> void:
	health_notches.resize(6)
	life_label.text = "x %s" % GameManager.lives


func update_health_bar(health : int) -> void:
	for i in health_notches.size() - 1:
		if i < health:
			health_notches[i].modulate.a = 1.0
		if i >= health:
			health_notches[i].modulate.a = 0.4
