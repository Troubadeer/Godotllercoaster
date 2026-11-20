extends enemy

class_name goomber

const MAX_HEALTH : int = 3
const MAX_SPEED : float = 750.0
const CONTACT_DAMAGE : int = 1

@onready var sprite : Sprite2D = $sprite
@onready var area_2d: Area2D = $Area2D

@export var attack_cooldown: float = 0.5
var current_attack_timer: float = 1.0

# Sets all necessary variables when they need to be!
func _ready() -> void:
	current_health = MAX_HEALTH
	current_speed = MAX_SPEED

func _process(delta: float) -> void:
	current_attack_timer += delta
	
	if current_attack_timer >= attack_cooldown:
		for body: Node2D in area_2d.get_overlapping_bodies() \
		.filter(func(body: Node2D) -> bool: return body is player):
			body.take_damage(CONTACT_DAMAGE)
			current_attack_timer = 0
	

# Simple Movement Physics!
func _physics_process(delta: float) -> void:
	if is_on_wall():
		current_speed *= -1
		sprite.flip_h = !sprite.flip_h
	
	velocity.x = 1 * current_speed * delta
	
	move_and_slide()
