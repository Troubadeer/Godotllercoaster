extends enemy

class_name goomber

@export var horse_point_1 : Vector2

const MAX_HEALTH : int = 3
const MAX_SPEED : float = 450.0
const CONTACT_DAMAGE : int = 1

@onready var sprite : Sprite2D = $sprite

# Sets all necessary variables when they need to be!
func _ready() -> void:
	current_health = MAX_HEALTH
	current_speed = MAX_SPEED

# Simple Movement Physics!
func _physics_process(delta: float) -> void:
	if is_on_wall():
		current_speed *= -1
		sprite.flip_h = !sprite.flip_h
		
	
	velocity.x = 1 * current_speed * delta
	
	# Reverses movement upon hitting a wall
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player:
		body.take_damage(CONTACT_DAMAGE)
