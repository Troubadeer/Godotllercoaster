extends CharacterBody2D
class_name bullet

const SPEED: float = 450.0
var damage: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	print(velocity)
	print("I live")

func update_velocity() -> void:
	velocity = Vector2.from_angle(rotation).normalized() * SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#position += Vector2.from_angle(rotation).normalized() * SPEED * delta
	
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		queue_free()
		
	move_and_slide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is enemy:
		body.take_damage(damage)
		queue_free()
