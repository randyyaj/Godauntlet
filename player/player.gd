class_name Player
extends CharacterBody2D

signal sig_death
signal sig_health_updated
signal sig_score_updated
signal sig_speed_updated
signal sig_shot_speed_updated
signal sig_magic_power_updated
signal sig_power_updated
signal sig_shot_power_updated
signal sig_defense_updated
signal sig_bombs_updated
signal sig_keys_updated
signal sig_fire_rate_updated

var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()

@export var default_health := 3000
@export var default_power := 1
@export var default_speed := 200
@export var default_shot_power := 1
@export var default_shot_speed := 200
@export var default_magic_power := 0
@export var default_defense := 0
@export var default_fire_rate := .25

@export var max_health := 9999
@export var max_power := 3
@export var max_speed := 500
@export var max_shot_power := 3
@export var max_shot_speed := 500
@export var max_magic_power := 3
@export var max_defense := 3
@export var max_fire_rate := .1

@export var health := 9999 :
	get:
		return health
	set(value):
		health = value
		sig_health_updated.emit(health)
		if (health <= 0):
			die()
		
@export var power := 1 :
	get:
		return power
	set(value):
		power = value
		sig_power_updated.emit(power)
		
@export var shot_power := 1 :
	get:
		return shot_power
	set(value):
		shot_power = value
		sig_shot_power_updated.emit(shot_power)

@export var defense := 0 :
	get:
		return defense
	set(value):
		defense = value
		sig_defense_updated.emit(defense)
		
@export var score := 0:
	get:
		return score
	set(value):
		score = value
		sig_score_updated.emit(score)
		
@export var speed: int = 200 : 
	get:
		return speed
	set(value):
		speed = value
		sig_speed_updated.emit(speed)

@export var shot_speed := 200 : 
	get:
		return shot_speed
	set(value):
		shot_speed = value
		sig_shot_speed_updated.emit(shot_speed)
		
@export var magic_power: int = 1 : 
	get:
		return magic_power
	set(value):
		magic_power = value
		sig_magic_power_updated.emit(magic_power)
		
@export var bombs: int = 0 : 
	get:
		return bombs
	set(value):
		bombs = value
		sig_bombs_updated.emit(bombs)
		
@export var keys: int = 0 : 
	get:
		return keys
	set(value):
		keys = value
		sig_keys_updated.emit(keys)

@export var fire_rate: float = 0.25 : 
	get:
		return fire_rate
	set(value):
		fire_rate = value
		sig_fire_rate_updated.emit(fire_rate)

@export var sfx_shoot: AudioStream
@export var sfx_hurt: AudioStream
@export var sfx_death: AudioStream
@export var projectile: PackedScene

@onready var health_timer: Timer = $HealthTimer
@onready var can_fire_timer = $CanFireTimer
@onready var blast_radius =$BlastRadius
@onready var blast_radius_shape: CollisionShape2D = $BlastRadius/BlastRadiusShape


var projectile_direction = Vector2.DOWN
var is_shooting := false
var can_fire := true


func _ready() -> void:
	PlayerManager.player = self
	PlayerManager.init_player_data()
	can_fire_timer.wait_time = fire_rate
	can_fire_timer.start()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		is_shooting = true

	if event.is_action_released("shoot"):
		is_shooting = false
	
	if event.is_action_pressed("bomb"):
		use_bomb()
		

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")
	if (direction != Vector2.ZERO):
		projectile_direction = direction
	velocity = direction.normalized() * speed * delta
	
	if (not is_shooting):
		var collision = move_and_collide(velocity)
		if (collision):
			var collider = collision.get_collider()
			if (collider is Enemy):
				melee_attack(collider)
	
	if (is_shooting and can_fire):
		shoot_projectile()


## Wrapper function allows us to specify a property name and apply operator logic on it
## Example emit_signal('health', '+', 4) | emit_signal('health', 'ADD', 4) | emit_signal('health', 'PLUS', 2) | emit_signal('health', 'add', 2)
func apply_modifier(property_name: StringName, operand: StringName, amount: int, duration: float) -> void:
	var property: Variant = get(property_name)
	match operand:
		&"+", &"ADD", &"add", &"PLUS", &"plus":
			set(property_name, property + amount)
		&"-", &"SUBTRACT", &"subtract", &"MINUS", &"minus":
			set(property_name, property - amount)
		&"*", &"MULTIPLY", &"multiply":
			set(property_name, property * amount)
		&"/", &"DIVIDE", &"divide":
			set(property_name, property / amount)
		&"=", &"ASSIGN":
			set(property_name, amount)
		_:
			pass


func melee_attack(body: PhysicsBody2D) -> void:
	# performs a short range melee attack
	# todo add animation
	body.health -= power
	

func shoot_projectile() -> void:
	# fires projectile in facing direction
	var bullet = projectile.instantiate()
	bullet.power = shot_power
	bullet.speed = shot_speed
	bullet.global_position = global_position
	bullet.direction = projectile_direction
	get_tree().get_root().add_child(bullet)
	can_fire = false


func use_bomb() -> void:
	# consumes potion and performs an area of affect attack
	# if magic_power level is MAX(5) call enemies group die() wiping all current enemy on screen else multiply BombCollisionShape * magic_power power
	if (bombs != 0):
		bombs -= 1
		var bodies = blast_radius.get_overlapping_bodies()
		for body in bodies:
			body.die()


func die() -> void:
	health = 0
	if (sfx_death):
		audio_stream_player.stream = sfx_death
		audio_stream_player.play()
		await audio_stream_player.finished
	# await animation if there is an animation
	sig_death.emit()


func _on_health_timer_timeout() -> void:
	health -= 1


func _on_can_fire_timer_timeout():
	can_fire = true
	

#checking for doors. If area entered, delete the fence and subtract a key
func _on_door_detector_body_entered(body):
	if body.is_in_group("Door") and (keys >= 1):
		keys -= 1
		body.queue_free()
