extends CharacterBody2D

class_name player

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 5
const SHOT_COOLDOWN : float = 0.25

@export var packed_bullet: PackedScene

@onready var reticle : Sprite2D = $reticle
@onready var sprite : Sprite2D = $player_sprite
@onready var current_health : int = MAX_HEALTH
var invuln : bool = false
var reticle_angle: float
var shootable : bool = true

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()
	reticle_angle = mouse_pos.angle_to(Vector2(0, 50))
	if (global_position.distance_to(mouse_pos) >= 25.0):
		reticle.position = Vector2(0,50).rotated(-reticle_angle)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func shoot() -> void:
	if shootable:
		var shooting_bullet: bullet = packed_bullet.instantiate()
		add_sibling(shooting_bullet)
		shooting_bullet.position = position
		shooting_bullet.rotation = PI/2-reticle_angle
		shooting_bullet.update_velocity()
		shootable = false
		await get_tree().create_timer(SHOT_COOLDOWN).timeout
		shootable = true

func take_damage(damage : int) -> void:
	if !invuln:
		current_health -= damage
		if current_health <= 0:
			kill()
		else:
			invuln = true
			sprite.modulate.a *= 0.5
			await get_tree().create_timer(0.75).timeout
			invuln = false
			sprite.modulate.a *= 2.0
	
func kill() -> void:
	GameManager.lives -= 1
	await get_tree().create_timer(0.5).timeout
	if GameManager.lives > 0:
		current_health = MAX_HEALTH
		GameManager.load_level(GameManager.current_level)
	else:
		#TODO: Game Over!
		pass
