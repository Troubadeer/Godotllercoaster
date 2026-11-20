extends CharacterBody2D

class_name player

const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 5
const SHOT_COOLDOWN : float = 0.25
const MAX_COYOTE : int = 7

const AIR_JUMP_SPEED_BOOST : float  = 2.25

@export var packed_bullet: PackedScene

@onready var reticle : Sprite2D = $reticle
@onready var sprite : Sprite2D = $player_sprite
@onready var camera : Camera2D = $camera
@onready var current_health : int = MAX_HEALTH

var speed = 100.0
var invuln : bool = false
var reticle_angle: float
var shootable : bool = true
var air_jump : bool = true
var coyote : int = MAX_COYOTE
var current_powerup: POWERUPS = POWERUPS.NONE

enum POWERUPS {NONE, BIG, SPEED}

func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()
	reticle_angle = mouse_pos.angle_to(Vector2(0, 50))
	if (global_position.distance_to(mouse_pos) >= 25.0):
		reticle.position = Vector2(0,50).rotated(-reticle_angle)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("pause"):
		GameManager.pause_game(self)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		air_jump = true
		coyote = MAX_COYOTE
	elif coyote > 0:
		coyote -= 1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction && is_on_floor():
		sprite.flip_h = direction - 1
		velocity.x = move_toward(velocity.x, direction * speed, speed / 3)
	elif direction && signf(direction) == signf(velocity.x):
		sprite.flip_h = direction - 1
		velocity.x = move_toward(velocity.x, direction * speed, speed / 60)
	elif direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed / 15)
		sprite.flip_h = direction - 1
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed / 20)
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif air_jump:
			do_air_jump(direction, coyote > 0)
	
	set_current_animation()
	move_and_slide()

func shoot() -> void:
	if shootable:
		var shooting_bullet: bullet = packed_bullet.instantiate()
		add_sibling(shooting_bullet)
		shooting_bullet.position = position
		shooting_bullet.rotation = PI/2-reticle_angle
		shooting_bullet.update_velocity()
		
		if current_powerup == POWERUPS.BIG:
			shooting_bullet.damage = 2
			shooting_bullet.scale *= 2
		
		shootable = false
		play_sfx(shoot_sfx)
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

func heal(health: int) -> void:
	current_health = clamp(current_health + health, current_health, MAX_HEALTH)
	
func do_air_jump(direction : float, ledge : bool) -> void:
	velocity.y = JUMP_VELOCITY * 0.8
	velocity.x = speed * AIR_JUMP_SPEED_BOOST
	if signf(direction) != signf(velocity.x):
		velocity.x *= direction
	air_jump = ledge
	play_sfx(air_jump_sfx)
	
	await get_tree().create_timer(0.4).timeout
	
	
func kill() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	GameManager.lives -= 1
	await get_tree().create_timer(0.5).timeout
	if GameManager.lives > 0:
		current_health = MAX_HEALTH
		GameManager.load_level(GameManager.current_level)
	else:
		GameManager.do_game_over()
	get_parent().queue_free()

func set_current_animation() -> void:
	pass

func powerup(type: POWERUPS) -> void:
	print(type)
	match type:
		POWERUPS.BIG:
			bigify()
		POWERUPS.SPEED:
			speedify()

func bigify() -> void:
	current_powerup = POWERUPS.BIG
	scale *= 2
	
	await get_tree().create_timer(10).timeout
	
	scale *= .5
	current_powerup = POWERUPS.NONE

func speedify() -> void:
	current_powerup = POWERUPS.SPEED
	speed += 50
	
	await get_tree().create_timer(10).timeout
	
	speed -= 50
	current_powerup = POWERUPS.NONE


var air_jump_sfx : AudioStream = load("res://assets/Sound Effects/trick.mp3")
var shoot_sfx : AudioStream = load("res://assets/Sound Effects/bang_whonk.mp3")

func play_sfx(sfx : AudioStream) -> void:
	var sfx_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	sfx_player.stream = sfx
	add_child(sfx_player)
	sfx_player.play()
	await sfx_player.finished
	sfx_player.queue_free()
